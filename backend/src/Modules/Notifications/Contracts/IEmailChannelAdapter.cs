namespace SpecPour.Modules.Notifications.Contracts;

/// <summary>
/// Email delivery port (R12/FR-040a): carries both the V1 opt-in alert channel and
/// identity transactional mail (recovery, verification) — nothing sends email ad hoc
/// outside this port. T146 supplies the real dev SMTP mail-catcher adapter; T050 (the
/// account-recovery flow) is the first cross-module caller, which is why this lives in
/// Contracts (constitution Principle III) rather than Application.Ports — it moved here
/// from there when that caller landed, matching ILegalDrinkingAgePort/IAgePredicatePort's
/// established cross-module port location.
/// </summary>
public interface IEmailChannelAdapter
{
    Task SendAsync(EmailMessage message, CancellationToken cancellationToken);
}

public sealed record EmailMessage(string ToAddress, string Subject, string BodyText, string? BodyHtml = null);
