using System.Net;
using SpecPour.Tests.Acceptance.Support;

namespace SpecPour.Tests.Acceptance;

/// <summary>
/// T043's "anonymous rate limiting verified" deliverable (FR-004b, R16). Uses its
/// OWN composed host (a fresh <see cref="SpecPourWebApplicationFactory"/>, constructed
/// with <c>enableRateLimiting: true</c>) rather than the shared AcceptanceHooks.Factory,
/// whose limiter is disabled by default (T051 gap review, 2026-07-14) precisely because
/// exhausting the anonymous 100-req/min budget on the shared host would spuriously
/// 429 every other anonymous scenario in the same run. Reuses the already-migrated
/// Testcontainers database via AcceptanceHooks.ConnectionString.
///
/// [Collection] pins this to the same collection as the Gherkin scenarios so it
/// doesn't run in parallel with them (Reqnroll's xUnit plugin runs the feature as
/// its own collection; a plain [Fact] would otherwise run concurrently and could
/// still race for the container). It shares only the DB, not the rate limiter.
///
/// CORRECTNESS NOTE (found 2026-07-17, T177 #100 item 0(b)): this class never
/// actually carried the [Collection] attribute the comment above describes —
/// only the doc comment existed, not the code. It went unnoticed because
/// RateLimitingTests was the only test in the project that boots its own
/// separate SpecPourWebApplicationFactory outside AcceptanceHooks.Factory, so
/// there was nothing else running concurrently that also reboots
/// OpenIddictClientSeedingHostedService (which syncs the seeded OpenIddict
/// client's redirect URIs against the shared Testcontainers row on every host
/// start). Adding DevOnlyRefreshAttemptsEndpointTests — which needs its own
/// Production-configured factory for the same reason — exposed it: two
/// concurrently-booting hosts race to UpdateAsync the same application row and
/// one loses to a DbUpdateConcurrencyException. The attribute below (matching
/// Reqnroll's generated "ReqnrollNonParallelizableFeatures" collection name) is
/// the fix now actually applied, not just documented.
/// </summary>
[Collection("ReqnrollNonParallelizableFeatures")]
public sealed class RateLimitingTests
{
    [Fact]
    public async Task AnonymousTrafficIsRateLimitedWith429()
    {
        using var factory = new SpecPourWebApplicationFactory(AcceptanceHooks.ConnectionString, enableRateLimiting: true);
        using var client = factory.CreateClient();

        // Anonymous limit is 100/min (AnonymousRateLimiterExtensions). Fire enough
        // to cross it and assert at least one 429 with the problem+json body.
        var sawTooManyRequests = false;
        for (var i = 0; i < 130; i++)
        {
            var response = await client.GetAsync(new Uri("/health/live", UriKind.Relative));
            if (response.StatusCode == HttpStatusCode.TooManyRequests)
            {
                sawTooManyRequests = true;
                Assert.Equal("application/problem+json", response.Content.Headers.ContentType?.MediaType);
                break;
            }
        }

        Assert.True(sawTooManyRequests, "Expected anonymous traffic to be rate-limited (429) after exceeding the anonymous permit limit.");
    }
}
