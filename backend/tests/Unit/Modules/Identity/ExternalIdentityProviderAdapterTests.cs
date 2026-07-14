using System.Security.Claims;
using SpecPour.Modules.Identity.Infrastructure.ExternalProviders;

namespace SpecPour.Tests.Unit.Modules.Identity;

/// <summary>
/// T049: unit coverage for the pure claims-normalization each provider adapter does.
/// The OAuth handshake itself (each provider's own ASP.NET Core handler) can't be
/// exercised without real Google/Apple/Microsoft app credentials, which don't exist in
/// this environment — see ExternalAuthEndpoints' own doc comment and the Phase 4
/// progress memory for that caveat. This is deliberately the boundary of what's
/// testable without them: given a claims principal shaped the way each real handler
/// produces one, does Normalize() extract the right fields.
/// </summary>
public sealed class ExternalIdentityProviderAdapterTests
{
    private static ClaimsPrincipal PrincipalWith(string? subject, string? email, string? name)
    {
        var claims = new List<Claim>();
        if (subject is not null)
        {
            claims.Add(new Claim(ClaimTypes.NameIdentifier, subject));
        }

        if (email is not null)
        {
            claims.Add(new Claim(ClaimTypes.Email, email));
        }

        if (name is not null)
        {
            claims.Add(new Claim(ClaimTypes.Name, name));
        }

        return new ClaimsPrincipal(new ClaimsIdentity(claims, "TestExternal"));
    }

    [Fact]
    public void Google_normalizes_subject_email_and_name()
    {
        var adapter = new GoogleExternalIdentityProviderAdapter();
        var identity = adapter.Normalize(PrincipalWith("google-sub-1", "a@example.test", "A Name"));

        Assert.Equal("google-sub-1", identity.Subject);
        Assert.Equal("a@example.test", identity.Email);
        Assert.Equal("A Name", identity.DisplayName);
    }

    [Fact]
    public void Microsoft_normalizes_subject_email_and_name()
    {
        var adapter = new MicrosoftExternalIdentityProviderAdapter();
        var identity = adapter.Normalize(PrincipalWith("ms-sub-1", "b@example.test", "B Name"));

        Assert.Equal("ms-sub-1", identity.Subject);
        Assert.Equal("b@example.test", identity.Email);
        Assert.Equal("B Name", identity.DisplayName);
    }

    [Fact]
    public void Apple_normalizes_subject_and_tolerates_missing_email_and_name()
    {
        // Apple only ever supplies email/name on the very first authorization — every
        // later sign-in carries just the subject. The adapter must not throw for that.
        var adapter = new AppleExternalIdentityProviderAdapter();
        var identity = adapter.Normalize(PrincipalWith("apple-sub-1", null, null));

        Assert.Equal("apple-sub-1", identity.Subject);
        Assert.Null(identity.Email);
        Assert.Null(identity.DisplayName);
    }

    [Fact]
    public void Normalize_throws_when_the_principal_has_no_subject_claim()
    {
        var adapter = new GoogleExternalIdentityProviderAdapter();

        Assert.Throws<InvalidOperationException>(() => adapter.Normalize(PrincipalWith(null, "a@example.test", "A")));
    }
}
