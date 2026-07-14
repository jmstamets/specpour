namespace SpecPour.Modules.Notifications.Infrastructure.Email;

/// <summary>
/// T146: config-driven SMTP settings (`Email:Smtp:*` / `Email__Smtp__*` env vars) —
/// the "production provider selected by configuration" half of the adapter rule.
/// Most transactional-email providers (SendGrid, Postmark, AWS SES, etc.) expose an
/// SMTP relay, so one adapter configured differently per environment covers dev
/// (smtp4dev, no auth) and production without a provider-specific adapter class; a
/// provider needing a non-SMTP API would get its own adapter later; nothing today
/// needs that.
/// </summary>
public sealed class SmtpEmailOptions
{
    /// <summary>Defaults match docker-compose.yml's smtp4dev port mapping, so a bare `dotnet run` against a manually-started smtp4dev container works without extra config.</summary>
    public string Host { get; set; } = "localhost";

    public int Port { get; set; } = 2525;

    public bool UseSsl { get; set; }

    public string? Username { get; set; }

    public string? Password { get; set; }

    public string FromAddress { get; set; } = "noreply@specpour.local";
}
