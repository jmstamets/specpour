using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Options;
using MimeKit;
using SpecPour.Modules.Notifications.Contracts;

namespace SpecPour.Modules.Notifications.Infrastructure.Email;

/// <summary>
/// T146: the real <see cref="IEmailChannelAdapter"/> — dev SMTP mail-catcher
/// (smtp4dev, docker-compose) for local/CI, any real SMTP-speaking provider in
/// production, selected purely by <see cref="SmtpEmailOptions"/> configuration.
/// Satisfies the same EmailChannelAdapterContractTests base LoggingEmailChannelAdapter
/// does (verified by SmtpEmailChannelAdapterContractTests against a real Testcontainers
/// smtp4dev instance), so the swap from Logging is safe.
/// </summary>
public sealed class SmtpEmailChannelAdapter(IOptions<SmtpEmailOptions> options) : IEmailChannelAdapter
{
    public async Task SendAsync(EmailMessage message, CancellationToken cancellationToken)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(message.ToAddress);
        ArgumentException.ThrowIfNullOrWhiteSpace(message.Subject);

        var settings = options.Value;

        var mime = new MimeMessage();
        mime.From.Add(MailboxAddress.Parse(settings.FromAddress));
        mime.To.Add(MailboxAddress.Parse(message.ToAddress));
        mime.Subject = message.Subject;
        mime.Body = new BodyBuilder { TextBody = message.BodyText, HtmlBody = message.BodyHtml }.ToMessageBody();

        using var client = new SmtpClient();
        await client.ConnectAsync(
            settings.Host,
            settings.Port,
            settings.UseSsl ? SecureSocketOptions.SslOnConnect : SecureSocketOptions.None,
            cancellationToken);

        if (!string.IsNullOrEmpty(settings.Username))
        {
            await client.AuthenticateAsync(settings.Username, settings.Password, cancellationToken);
        }

        await client.SendAsync(mime, cancellationToken);
        await client.DisconnectAsync(true, cancellationToken);
    }
}
