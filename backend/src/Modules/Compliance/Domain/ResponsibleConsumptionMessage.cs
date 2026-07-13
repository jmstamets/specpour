namespace SpecPour.Modules.Compliance.Domain;

/// <summary>
/// data-model.md ResponsibleConsumptionMessage (FR-067, T150): the persistent
/// responsible-consumption message shown on recipe pages, batch outputs, and the
/// footer/about surface. Text and placement are counsel-reviewed per launch market
/// — the <see cref="MessageContentKey"/> is an i18n key resolved client-side
/// (never hard-coded copy, per the i18n principle). A <see cref="DefaultCode"/> row
/// per surface class is the strictest-rule-style fallback when a jurisdiction can't
/// be resolved, mirroring <see cref="JurisdictionRule"/>.
/// </summary>
public sealed class ResponsibleConsumptionMessage
{
    public const string DefaultCode = "default";

    public required Guid Id { get; init; }

    public required string JurisdictionCode { get; set; }

    /// <summary>"recipe", "batch_output", or "footer_about" — matches <see cref="ResponsibleConsumptionSurface"/> by name.</summary>
    public required string SurfaceClass { get; set; }

    public required string PlacementDescriptor { get; set; }

    public required string MessageContentKey { get; set; }

    public required DateTimeOffset EffectiveAt { get; set; }
}

/// <summary>The surfaces FR-067 mandates a persistent responsible-consumption message on.</summary>
public enum ResponsibleConsumptionSurface
{
    Recipe,
    BatchOutput,
    FooterAbout,
}
