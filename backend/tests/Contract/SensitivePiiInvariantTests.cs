using System.Text.Json.Nodes;
using SpecPour.Tests.Contract.Support;

namespace SpecPour.Tests.Contract;

/// <summary>
/// T047: enforces openapi.yaml's own documented sensitive-PII invariant (FR-002b) —
/// "no schema in this document may expose a raw dateOfBirth field except the
/// MeExport schema returned by GET /me/export." Scans the fully-bundled document
/// (every path file's $refs resolved) rather than trusting each path file to
/// self-police, the same way a code reviewer can't just check the file someone
/// changed — a property named dateOfBirth could be introduced from any schema.
/// </summary>
public sealed class SensitivePiiInvariantTests
{
    // MeExport (T053, not yet built): the sole RESPONSE surface allowed to return a
    // raw dateOfBirth (FR-002b/SC-017). RegisterRequest/CompleteExternalRegistrationRequest
    // (T049, social sign-in's own DOB-completion step): accept dateOfBirth as INPUT
    // only — it's a request body, never returned; OpenApiConformanceTests'
    // PostAuthRegister_conforms_to_its_schema separately asserts the actual response
    // body never contains the string "dateOfBirth", covering what this schema-only
    // scan can't (a request schema having the property is fine; a response schema
    // having it is the violation).
    private static readonly HashSet<string> AllowedSchemaNames = ["MeExport", "RegisterRequest", "CompleteExternalRegistrationRequest"];

    [Fact]
    public async Task No_schema_other_than_the_allowed_ones_carries_a_raw_dateOfBirth_property()
    {
        var document = await OpenApiBundle.LoadAsync();
        var schemas = document["components"]?["schemas"]?.AsObject()
            ?? throw new InvalidOperationException("Bundled document has no components/schemas.");

        var offenders = new List<string>();
        foreach (var (schemaName, schemaNode) in schemas)
        {
            if (AllowedSchemaNames.Contains(schemaName) || schemaNode is null)
            {
                continue;
            }

            if (ContainsDateOfBirthProperty(schemaNode))
            {
                offenders.Add(schemaName);
            }
        }

        Assert.True(offenders.Count == 0, $"Schemas exposing a raw dateOfBirth property (only {string.Join(", ", AllowedSchemaNames)} may): {string.Join(", ", offenders)}");
    }

    private static bool ContainsDateOfBirthProperty(JsonNode schemaNode)
    {
        var properties = schemaNode["properties"]?.AsObject();
        return properties is not null && properties.ContainsKey("dateOfBirth");
    }
}
