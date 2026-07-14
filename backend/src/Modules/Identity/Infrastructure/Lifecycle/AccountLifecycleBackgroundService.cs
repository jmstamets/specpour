using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SpecPour.BuildingBlocks.Events;
using SpecPour.BuildingBlocks.Time;
using SpecPour.Modules.Identity.Application.Lifecycle;
using SpecPour.Modules.Identity.Contracts.Events;
using SpecPour.Modules.Identity.Domain;
using SpecPour.Modules.Identity.Infrastructure;

namespace SpecPour.Modules.Identity.Infrastructure.Lifecycle;

/// <summary>
/// T052/FR-003's "warned before expiry, then automatically deleted" half. Same
/// poll-loop shape as OutboxDispatcherBackgroundService (fresh DI scope per cycle,
/// try/catch around the work so one bad cycle doesn't kill the service). Two passes
/// per cycle: first warn accounts entering their warning window (recording
/// DeactivationWarningSentAt so this is one-shot), then delete accounts whose grace
/// period has fully elapsed via the same AccountDeletionService the self-service
/// DELETE /me endpoint uses — one deletion mechanism for both paths. Lives in
/// Infrastructure (not Application/Lifecycle/ as tasks.md's original text suggested)
/// because it touches IdentityDbContext/EF Core directly — Application has zero
/// infrastructure dependency throughout this module (see e.g. Otp.NET's placement
/// rationale), so a DbContext-touching hosted service can't live there;
/// LifecycleOptions itself (a pure POCO) still does.
/// </summary>
public sealed partial class AccountLifecycleBackgroundService(
    IServiceScopeFactory scopeFactory,
    IOptions<LifecycleOptions> options,
    IClock clock,
    ILogger<AccountLifecycleBackgroundService> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var interval = options.Value.PollingInterval;

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await RunCycleAsync(stoppingToken);
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                Log.LifecycleCycleFailed(logger, ex);
            }

            try
            {
                await Task.Delay(interval, stoppingToken);
            }
            catch (OperationCanceledException)
            {
                // Shutting down.
            }
        }
    }

    private async Task RunCycleAsync(CancellationToken cancellationToken)
    {
        using var scope = scopeFactory.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<IdentityDbContext>();
        var dispatcher = scope.ServiceProvider.GetRequiredService<IDomainEventDispatcher>();
        var now = clock.UtcNow;

        var gracePeriod = TimeSpan.FromDays(options.Value.GracePeriodDays);
        var warningWindow = TimeSpan.FromDays(options.Value.WarningDaysBeforeExpiry);
        var warnCutoff = now - (gracePeriod - warningWindow);
        var expiryCutoff = now - gracePeriod;

        var toWarn = await db.Users
            .Where(u => u.LifecycleState == UserLifecycleState.Deactivated
                && u.DeactivatedAt != null
                && u.DeactivationWarningSentAt == null
                && u.DeactivatedAt <= warnCutoff)
            .ToListAsync(cancellationToken);

        foreach (var user in toWarn)
        {
            dispatcher.Raise(new DeactivationExpiryApproaching(user.Id, user.DeactivatedAt!.Value + gracePeriod));
            user.DeactivationWarningSentAt = now;
        }

        if (toWarn.Count > 0)
        {
            await db.SaveChangesAsync(cancellationToken);
        }

        var toDelete = await db.Users
            .Where(u => u.LifecycleState == UserLifecycleState.Deactivated
                && u.DeactivatedAt != null
                && u.DeactivatedAt <= expiryCutoff)
            .Select(u => u.Id)
            .ToListAsync(cancellationToken);

        if (toDelete.Count == 0)
        {
            return;
        }

        var deletionService = scope.ServiceProvider.GetRequiredService<AccountDeletionService>();
        foreach (var userId in toDelete)
        {
            await deletionService.DeleteAsync(userId, cancellationToken);
        }
    }

    private static partial class Log
    {
        [LoggerMessage(Level = LogLevel.Error, Message = "Account lifecycle cycle failed")]
        public static partial void LifecycleCycleFailed(ILogger logger, Exception exception);
    }
}
