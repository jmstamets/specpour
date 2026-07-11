using System.Diagnostics;
using System.Text.RegularExpressions;
using OpenTelemetry;

namespace SpecPour.Api.Observability;

/// <summary>
/// Trace-side counterpart to <see cref="SensitiveFieldScrubbingEnricher"/> (R6a):
/// redacts any span tag whose key looks DOB-shaped before the span is exported, as a
/// defensive backstop alongside the logging enricher.
/// </summary>
public sealed partial class SensitiveTagScrubbingProcessor : BaseProcessor<Activity>
{
    private const string RedactedPlaceholder = "[REDACTED]";

    public override void OnEnd(Activity activity)
    {
        List<KeyValuePair<string, object?>>? replacements = null;

        foreach (var tag in activity.TagObjects)
        {
            if (SensitiveNamePattern().IsMatch(tag.Key))
            {
                replacements ??= [];
                replacements.Add(new KeyValuePair<string, object?>(tag.Key, RedactedPlaceholder));
            }
        }

        if (replacements is null)
        {
            return;
        }

        foreach (var replacement in replacements)
        {
            activity.SetTag(replacement.Key, replacement.Value);
        }
    }

    [GeneratedRegex(@"^(date_?of_?birth|dob|birth_?date)$", RegexOptions.IgnoreCase)]
    private static partial Regex SensitiveNamePattern();
}
