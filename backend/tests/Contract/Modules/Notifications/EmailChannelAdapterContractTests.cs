using SpecPour.Modules.Notifications.Application.Ports;

namespace SpecPour.Tests.Contract.Modules.Notifications;

/// <summary>
/// T023's port contract-test suite for IEmailChannelAdapter: the behavior every
/// implementation must satisfy, independent of how it actually delivers mail. T146's
/// real dev-SMTP adapter subclasses this same base and gets the identical assertions
/// for free — a swap is only safe once both pass the same suite.
/// </summary>
public abstract class EmailChannelAdapterContractTests
{
    protected abstract IEmailChannelAdapter CreateAdapter();

    [Fact]
    public async Task SendAsync_completes_for_a_valid_message()
    {
        var adapter = CreateAdapter();

        await adapter.SendAsync(new EmailMessage("guest@example.com", "Welcome", "Hello!"), CancellationToken.None);
    }

    [Fact]
    public async Task SendAsync_rejects_an_empty_recipient()
    {
        var adapter = CreateAdapter();

        await Assert.ThrowsAnyAsync<ArgumentException>(() =>
            adapter.SendAsync(new EmailMessage(string.Empty, "Welcome", "Hello!"), CancellationToken.None));
    }

    [Fact]
    public async Task SendAsync_rejects_an_empty_subject()
    {
        var adapter = CreateAdapter();

        await Assert.ThrowsAnyAsync<ArgumentException>(() =>
            adapter.SendAsync(new EmailMessage("guest@example.com", string.Empty, "Hello!"), CancellationToken.None));
    }

    [Fact]
    public async Task SendAsync_accepts_a_message_with_no_html_body()
    {
        var adapter = CreateAdapter();

        await adapter.SendAsync(new EmailMessage("guest@example.com", "Welcome", "Hello!", BodyHtml: null), CancellationToken.None);
    }
}
