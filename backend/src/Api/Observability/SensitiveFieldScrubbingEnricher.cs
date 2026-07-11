using System.Text.RegularExpressions;
using Serilog.Core;
using Serilog.Events;

namespace SpecPour.Api.Observability;

/// <summary>
/// Defensive log/trace scrubbing for DOB-shaped fields (R6a: the identity module's
/// stored date_of_birth is application-layer encrypted and the sole raw-value read path
/// is the owner's data export; this enricher is a defense-in-depth backstop, not the
/// primary control, in case a future call site ever accidentally logs a raw or
/// deserialized DOB value). Redacts by property name — case-insensitive match against
/// "dateOfBirth", "date_of_birth", "dob", "birthDate" — at any depth in a structured
/// log property, including nested destructured objects.
/// </summary>
public sealed partial class SensitiveFieldScrubbingEnricher : ILogEventEnricher
{
    private const string RedactedPlaceholder = "[REDACTED]";

    public void Enrich(LogEvent logEvent, ILogEventPropertyFactory propertyFactory)
    {
        foreach (var (name, value) in logEvent.Properties)
        {
            var scrubbed = IsSensitiveName(name)
                ? new ScalarValue(RedactedPlaceholder)
                : Scrub(value);

            if (!ReferenceEquals(scrubbed, value))
            {
                logEvent.AddOrUpdateProperty(new LogEventProperty(name, scrubbed));
            }
        }
    }

    private static LogEventPropertyValue Scrub(LogEventPropertyValue value) => value switch
    {
        StructureValue structure => ScrubStructure(structure),
        DictionaryValue dictionary => ScrubDictionary(dictionary),
        SequenceValue sequence => ScrubSequence(sequence),
        _ => value,
    };

    private static StructureValue ScrubStructure(StructureValue structure)
    {
        var properties = structure.Properties.Select(p =>
            IsSensitiveName(p.Name)
                ? new LogEventProperty(p.Name, new ScalarValue(RedactedPlaceholder))
                : new LogEventProperty(p.Name, Scrub(p.Value)));

        return new StructureValue(properties, structure.TypeTag);
    }

    private static DictionaryValue ScrubDictionary(DictionaryValue dictionary)
    {
        var elements = dictionary.Elements.Select(kvp =>
        {
            var keyText = kvp.Key.Value?.ToString();
            var scrubbedValue = keyText is not null && IsSensitiveName(keyText)
                ? new ScalarValue(RedactedPlaceholder)
                : Scrub(kvp.Value);
            return new KeyValuePair<ScalarValue, LogEventPropertyValue>(kvp.Key, scrubbedValue);
        });

        return new DictionaryValue(elements);
    }

    private static SequenceValue ScrubSequence(SequenceValue sequence) =>
        new(sequence.Elements.Select(Scrub));

    private static bool IsSensitiveName(string name) => SensitiveNamePattern().IsMatch(name);

    [GeneratedRegex(@"^(date_?of_?birth|dob|birth_?date)$", RegexOptions.IgnoreCase)]
    private static partial Regex SensitiveNamePattern();
}
