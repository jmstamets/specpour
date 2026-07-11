namespace SpecPour.Modules.Notifications.Application.Ports;

/// <summary>
/// Email delivery port (R12/FR-040a): carries both the V1 opt-in alert channel and
/// identity transactional mail (recovery, verification) — nothing sends email ad hoc
/// outside this port. V1's implementation logs instead of delivering (no feature
/// calls this yet); the real dev SMTP mail-catcher adapter lands in T146. Any
/// implementation, including that one, must satisfy the same contract tests
/// (EmailChannelAdapterContractTests) so swapping adapters is safe.
/// </summary>
public interface IEmailChannelAdapter
{
    Task SendAsync(EmailMessage message, CancellationToken cancellationToken);
}

public sealed record EmailMessage(string ToAddress, string Subject, string BodyText, string? BodyHtml = null);
