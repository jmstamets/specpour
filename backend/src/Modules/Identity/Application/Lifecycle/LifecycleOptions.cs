namespace SpecPour.Modules.Identity.Application.Lifecycle;

/// <summary>
/// T052/FR-003: "an operator-configurable grace period, default 12 months." In-class
/// defaults (same style as OutboxDispatcherOptions) plus config binding under
/// "Identity:Lifecycle" (same style as SmtpEmailOptions) so an operator can actually
/// override them without a code change.
/// </summary>
public sealed class LifecycleOptions
{
    public int GracePeriodDays { get; set; } = 365;

    /// <summary>How long before grace-period expiry the one-time warning is sent.</summary>
    public int WarningDaysBeforeExpiry { get; set; } = 30;

    /// <summary>
    /// How often AccountLifecycleBackgroundService scans for accounts to warn/delete.
    /// Day-granularity work doesn't need frequent polling in production; the
    /// acceptance test host overrides this the same way it overrides
    /// OutboxDispatcherOptions.PollingInterval.
    /// </summary>
    public TimeSpan PollingInterval { get; set; } = TimeSpan.FromHours(1);
}
