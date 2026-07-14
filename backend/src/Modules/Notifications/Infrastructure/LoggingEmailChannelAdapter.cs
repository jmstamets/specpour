using Microsoft.Extensions.Logging;
using SpecPour.Modules.Notifications.Contracts;

namespace SpecPour.Modules.Notifications.Infrastructure;

/// <summary>
/// Interim <see cref="IEmailChannelAdapter"/> (T023): logs instead of delivering.
/// Correct behavior today — no feature calls this port yet (registration/MFA/
/// recovery land in Phase 4) — not a stub masquerading as complete. Replaced by a
/// real dev SMTP mail-catcher adapter in T146 without any caller-side changes,
/// since both satisfy the same contract tests.
/// </summary>
public sealed partial class LoggingEmailChannelAdapter(ILogger<LoggingEmailChannelAdapter> logger) : IEmailChannelAdapter
{
    public Task SendAsync(EmailMessage message, CancellationToken cancellationToken)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(message.ToAddress);
        ArgumentException.ThrowIfNullOrWhiteSpace(message.Subject);

        Log.EmailLogged(logger, message.ToAddress, message.Subject);
        return Task.CompletedTask;
    }

    private static partial class Log
    {
        [LoggerMessage(Level = LogLevel.Information, Message = "Email would be sent to {ToAddress}: {Subject} (no real adapter until T146)")]
        public static partial void EmailLogged(ILogger logger, string toAddress, string subject);
    }
}
