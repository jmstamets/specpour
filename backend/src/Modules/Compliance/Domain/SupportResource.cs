namespace SpecPour.Modules.Compliance.Domain;

/// <summary>
/// data-model.md SupportResource (FR-069, T150): jurisdiction-aware helpline/
/// organization links surfaced from the responsible-consumption messaging and
/// settings/about. Configuration-driven; a <see cref="ResponsibleConsumptionMessage.DefaultCode"/>
/// jurisdiction row is the fallback when the caller's jurisdiction is unresolved.
/// </summary>
public sealed class SupportResource
{
    public required Guid Id { get; init; }

    public required string JurisdictionCode { get; set; }

    public required string ResourceName { get; set; }

    /// <summary>A URL or tel: link — localized/configuration-driven, shown as-is.</summary>
    public required string Link { get; set; }

    public required int DisplayOrder { get; set; }

    public required DateTimeOffset EffectiveAt { get; set; }
}
