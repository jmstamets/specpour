using Microsoft.Extensions.Logging.Abstractions;
using SpecPour.Modules.Notifications.Application.Ports;
using SpecPour.Modules.Notifications.Infrastructure;

namespace SpecPour.Tests.Contract.Modules.Notifications;

public sealed class LoggingEmailChannelAdapterContractTests : EmailChannelAdapterContractTests
{
    protected override IEmailChannelAdapter CreateAdapter() =>
        new LoggingEmailChannelAdapter(NullLogger<LoggingEmailChannelAdapter>.Instance);
}
