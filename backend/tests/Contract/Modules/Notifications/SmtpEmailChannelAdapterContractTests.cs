using DotNet.Testcontainers.Builders;
using DotNet.Testcontainers.Containers;
using Microsoft.Extensions.Options;
using SpecPour.Modules.Notifications.Contracts;
using SpecPour.Modules.Notifications.Infrastructure.Email;

namespace SpecPour.Tests.Contract.Modules.Notifications;

/// <summary>
/// T146: verifies the real SMTP adapter against a real (Testcontainers-managed)
/// smtp4dev instance, satisfying the same EmailChannelAdapterContractTests base
/// LoggingEmailChannelAdapterContractTests does — the swap from Logging to Smtp in
/// NotificationsModule is safe only because both pass this identical suite. Isolated
/// from the shared ComposedHostFixture (which overrides back to Logging — no
/// reachable SMTP server there) so this is the one place that actually exercises SMTP.
/// </summary>
public sealed class SmtpEmailChannelAdapterContractTests : EmailChannelAdapterContractTests, IAsyncLifetime
{
    private const int SmtpPort = 25;

    private readonly IContainer _smtp4dev = new ContainerBuilder("rnwood/smtp4dev:v3")
        .WithPortBinding(SmtpPort, true)
        .WithWaitStrategy(Wait.ForUnixContainer().UntilInternalTcpPortIsAvailable(SmtpPort))
        .Build();

    public Task InitializeAsync() => _smtp4dev.StartAsync();

    public Task DisposeAsync() => _smtp4dev.DisposeAsync().AsTask();

    protected override IEmailChannelAdapter CreateAdapter()
    {
        var options = new SmtpEmailOptions
        {
            Host = _smtp4dev.Hostname,
            Port = _smtp4dev.GetMappedPublicPort(SmtpPort),
            FromAddress = "noreply@specpour.local",
        };

        return new SmtpEmailChannelAdapter(Options.Create(options));
    }
}
