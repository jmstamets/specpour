using SpecPour.BuildingBlocks.Modules;

namespace SpecPour.Api;

/// <summary>
/// The fixed, explicit set of business modules composed into this host (constitution
/// Principle III). Populated incrementally as each module's Infrastructure project
/// lands an <see cref="IModule"/> implementation — Identity first (T016), then
/// Authorization (T018), and so on. Deliberately a hand-maintained list rather than
/// assembly scanning, so composition order is a reviewable decision, not an accident.
/// </summary>
public static class ModuleRegistry
{
    public static IReadOnlyList<IModule> All { get; } =
    [
        new Modules.Identity.Infrastructure.IdentityModule(), // T016
        new Modules.Authorization.Infrastructure.AuthorizationModule(), // T018
        new Modules.Compliance.Infrastructure.ComplianceModule(), // T020
        new Modules.Media.Infrastructure.MediaModule(), // T021
        new Modules.Search.Infrastructure.SearchModule(), // T022
        new Modules.Notifications.Infrastructure.NotificationsModule(), // T023
        new Modules.Measurements.Infrastructure.MeasurementsModule(), // T024
        // ...
    ];
}
