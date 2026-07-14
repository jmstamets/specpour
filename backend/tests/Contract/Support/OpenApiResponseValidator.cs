using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using Json.Schema;

namespace SpecPour.Tests.Contract.Support;

/// <summary>
/// Looks up the response schema for a given (path, method, status) in the bundled
/// OpenAPI document and validates a live response body against it. Request paths
/// carry the /api/v1 prefix (BuildingBlocks.Http.ApiV1RouteGroupExtensions); the
/// bundled document's paths are relative to the `servers[0].url: /api/v1` entry, so
/// the prefix is stripped before matching.
///
/// Evaluates via a $ref into the whole bundled document (registered once under a
/// fixed URI) rather than extracting and evaluating the schema fragment in
/// isolation: OpenAPI schemas commonly $ref sibling components (e.g.
/// EntitlementManifest -> RoleGrantSummary), and those refs are only resolvable
/// with the full document as context.
/// </summary>
public static partial class OpenApiResponseValidator
{
    private static readonly Uri BundleUri = new("https://specpour.internal/bundled-openapi.json");
    private static readonly SemaphoreSlim RegistrationLock = new(1, 1);
    private static bool _registered;

    public static async Task<EvaluationResults> ValidateAsync(string method, string requestPath, int statusCode, string responseBody)
    {
        var document = await OpenApiBundle.LoadAsync();
        await EnsureRegisteredAsync(document);

        var pointer = FindResponseSchemaPointer(document, method, requestPath, statusCode)
            ?? throw new InvalidOperationException(
                $"No OpenAPI schema found for {method} {requestPath} -> {statusCode}. " +
                "Either the path isn't yet authored in contracts/openapi/, or the status code isn't documented.");

        var refSchema = JsonSchema.FromText($$"""{"$ref": "{{BundleUri}}{{pointer}}"}""");

        var instance = JsonDocument.Parse(responseBody).RootElement;
        return refSchema.Evaluate(instance, new EvaluationOptions { OutputFormat = OutputFormat.List });
    }

    private static async Task EnsureRegisteredAsync(JsonNode document)
    {
        if (_registered)
        {
            return;
        }

        await RegistrationLock.WaitAsync();
        try
        {
            if (!_registered)
            {
                // The bundled document is OpenAPI, not itself a JSON Schema (its root
                // has non-schema keywords like "openapi"/"info"/"paths") — register it
                // as a plain ref-resolvable document rather than JsonSchema.FromText,
                // which would try to interpret the whole thing as a schema and reject
                // those keywords.
                var element = JsonDocument.Parse(document.ToJsonString()).RootElement;
                SchemaRegistry.Global.Register(BundleUri, new JsonElementBaseDocument(element, BundleUri));
                _registered = true;
            }
        }
        finally
        {
            RegistrationLock.Release();
        }
    }

    private static string? FindResponseSchemaPointer(JsonNode document, string method, string requestPath, int statusCode)
    {
        var apiV1Prefix = "/api/v1";
        var relativePath = requestPath.StartsWith(apiV1Prefix, StringComparison.Ordinal)
            ? requestPath[apiV1Prefix.Length..]
            : requestPath;
        if (string.IsNullOrEmpty(relativePath))
        {
            relativePath = "/";
        }

        var paths = document["paths"]?.AsObject()
            ?? throw new InvalidOperationException("Bundled OpenAPI document has no 'paths' object.");

        // Exact literal paths win over templated ones (e.g. '/auth/external/complete-registration'
        // over '/auth/external/{provider}') — matching real ASP.NET Core route precedence,
        // where a literal segment always beats a parameter for the same request.
        var pathKey = paths.ContainsKey(relativePath)
            ? relativePath
            : paths.FirstOrDefault(kvp => PathTemplateMatches(kvp.Key, relativePath)).Key
                ?? throw new InvalidOperationException($"No OpenAPI path entry matches '{relativePath}'.");

        var pathItem = paths[pathKey]!;
        var methodKey = method.ToLowerInvariant();
        var operation = pathItem[methodKey]
            ?? throw new InvalidOperationException($"No '{method}' operation documented for '{relativePath}'.");

        var statusKey = statusCode.ToString(System.Globalization.CultureInfo.InvariantCulture);
        var responses = operation["responses"]?.AsObject();
        var (actualStatusKey, rawResponse) = responses is not null && responses.ContainsKey(statusKey)
            ? (statusKey, responses[statusKey])
            : (responses?.ContainsKey("default") == true ? "default" : null, responses?["default"]);

        if (rawResponse is null || actualStatusKey is null)
        {
            return null;
        }

        // Response objects are frequently authored as `$ref: '../openapi.yaml#/components/responses/X'`
        // (e.g. UnauthorizedResponse) rather than inlined — follow the ref within the
        // bundled document (Redocly rewrites cross-file refs to same-document
        // pointers) before looking for `content` on it.
        var responsePointer = $"#/paths/{JsonPointerEscape(pathKey)}/{methodKey}/responses/{actualStatusKey}";
        var (response, resolvedPointer) = ResolveRef(document, rawResponse, responsePointer);

        var mediaTypeKey = response["content"]?["application/json"] is not null ? "application/json" : "application/problem+json";
        var schemaNode = response["content"]?[mediaTypeKey]?["schema"];
        if (schemaNode is null)
        {
            return null;
        }

        var schemaPointer = $"{resolvedPointer}/content/{JsonPointerEscape(mediaTypeKey)}/schema";

        // Resolve a bare `{"$ref": "#/components/schemas/X"}` wrapper down to the
        // real schema body ourselves (JsonSchema.Net's own $ref resolution against a
        // plain JsonElementBaseDocument — not a pre-parsed JsonSchema tree — doesn't
        // chase a second-level ref reliably). A LATERAL ref inside that schema body
        // (e.g. EntitlementManifest's `roles` items pointing at RoleGrantSummary) is
        // still left for JsonSchema.Net itself, which handles that case correctly.
        var (_, finalPointer) = ResolveRef(document, schemaNode, schemaPointer);
        return finalPointer;
    }

    /// <summary>Follows a `{"$ref": "#/a/b/c"}` node to its target within the same document, returning the target node and its own pointer. Non-ref nodes pass through unchanged.</summary>
    private static (JsonNode Node, string Pointer) ResolveRef(JsonNode document, JsonNode node, string currentPointer)
    {
        var seen = new HashSet<string>();
        var current = node;
        var pointer = currentPointer;

        while (current["$ref"]?.GetValue<string>() is { } refValue)
        {
            var targetPointer = refValue.Contains('#', StringComparison.Ordinal)
                ? refValue[(refValue.IndexOf('#', StringComparison.Ordinal) + 1)..]
                : refValue;
            if (!seen.Add(targetPointer))
            {
                throw new InvalidOperationException($"Circular $ref detected resolving '{currentPointer}'.");
            }

            current = NavigatePointer(document, targetPointer)
                ?? throw new InvalidOperationException($"$ref '{refValue}' (from '{pointer}') does not resolve within the bundled document.");
            pointer = "#" + targetPointer;
        }

        return (current, pointer);
    }

    private static JsonNode? NavigatePointer(JsonNode document, string pointer)
    {
        var node = document;
        foreach (var rawSegment in pointer.Split('/', StringSplitOptions.RemoveEmptyEntries))
        {
            var segment = rawSegment.Replace("~1", "/", StringComparison.Ordinal).Replace("~0", "~", StringComparison.Ordinal);
            node = node?[segment];
        }

        return node;
    }

    private static string JsonPointerEscape(string segment) =>
        segment.Replace("~", "~0", StringComparison.Ordinal).Replace("/", "~1", StringComparison.Ordinal);

    private static bool PathTemplateMatches(string template, string actualPath)
    {
        if (template == actualPath)
        {
            return true;
        }

        var pattern = "^" + PathParameterPattern().Replace(Regex.Escape(template).Replace("\\{", "{").Replace("\\}", "}"), "[^/]+") + "$";
        return Regex.IsMatch(actualPath, pattern);
    }

    [GeneratedRegex(@"\{[^}]+\}")]
    private static partial Regex PathParameterPattern();
}
