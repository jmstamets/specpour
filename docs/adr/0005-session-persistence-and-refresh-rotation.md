# ADR-0005: Persisted refresh-token session with rotation, restored on app start

**Status**: Approved (2026-07-16, John, with three riders — see "Decision" and
"Consequences") — implementation proceeding
**Date**: 2026-07-16
**Decided during**: Phase 4 (US2), T177 — walkthrough finding F3 ("refreshing
the browser logs the user out").

## Context

The Flutter client holds the access token and refresh token only in in-memory
Riverpod state (`authTokenProvider` / `refreshTokenProvider`,
`api_client_provider.dart`) — nothing writes them to disk. A page reload (web) or
app restart (native) drops both, so the user is silently signed out and must
re-authenticate.

This interacts badly with two decisions already in place:

- **T166's 10-minute access-token lifetime** (`IdentityModule.cs`
  `SetAccessTokenLifetime`): access tokens are deliberately short-lived to bound
  the post-revocation exposure window. Refresh is therefore a *hot path* — a
  working session must silently refresh roughly every 10 minutes. Without
  persistence, "refresh works within a live session but not across a reload" means
  a web user is effectively re-logging-in every 10 minutes.
- **The SessionDevice model** (`TokenEndpoints.HandleTokenAsync`,
  `SessionDevice.cs`): one row per OpenIddict authorization (refresh-token family).
  A **new `authorization_code` grant creates a new SessionDevice row**; a
  `refresh_token` grant only updates the existing row's `LastSeenAt`. Because a
  reload today forces a *full re-login* (a fresh `authorization_code` grant), every
  reload spawns a **new** "active session" and orphans the old one — the exact
  symptom John recorded in walkthrough section (e): "refreshing the browser …
  results in a new entry in Active sessions."

So the reload bug and the orphan-session bug are the same root cause: the client
can't resume its existing authorization, so it starts a brand-new one every time.

## Decision

**Persist the refresh token across app restarts and, on app start, silently
restore the session by exchanging it for a fresh token pair (a `refresh_token`
grant against the *existing* authorization) — never a fresh `authorization_code`
grant.** Concretely:

1. **Client persistence, platform-appropriate:**
   - **Native** (iOS/Android): `flutter_secure_storage` (Keychain / Encrypted
     SharedPreferences-backed Keystore).
   - **Web**: persisted browser storage (`shared_preferences`, already a
     dependency → `localStorage`). This is deliberately **readable by JavaScript**,
     so it carries an **XSS token-theft exposure** that native secure storage does
     not. That exposure is accepted for V1 **only with a strict Content-Security-
     Policy as the compensating control** — filed as a **rider on T139's launch
     gate** (see "Consequences"). The token's own short lifetime (10-min access,
     bounded refresh lifetime below) is *not* the primary compensating control by
     itself; **one-time-use rotation with reuse detection** (above) is what
     actually caps a stolen token's value to a single use, and is cited here as
     part of this rider's own rationale, not treated as a separate concern.

   **The multi-tab trap (John's rider — design for it now, not after it ships as
   a bug).** One-time-use refresh tokens plus a web app open in two tabs is a
   classic self-inflicted wound: both tabs' access tokens expire around the same
   time, both race to refresh, the loser presents a refresh token the winner has
   already redeemed — and reuse detection, doing exactly its job, revokes the
   session for what was actually a benign race, not theft. OpenIddict's
   `RefreshTokenReuseLeeway` (30-second default grace window for concurrent
   requests using a just-redeemed token, confirmed in the package's XML docs) is
   a **backstop for near-simultaneous requests**, not a substitute for real
   coordination — a background tab that only attempts its refresh when the user
   switches to it minutes later falls well outside any such window. **Web needs
   explicit cross-tab refresh coordination**: a single-refresher election (Web
   Locks API, with a `BroadcastChannel` fallback for browsers without Web Locks)
   so only one tab ever redeems a given refresh token; the winner distributes the
   new token pair to the other tabs via the same channel. Skipping this ships as
   an intermittent everyone's-logged-out bug indistinguishable from T167's
   original ghost — exactly the class of defect this ADR-first sequence exists
   to prevent.

   **Leeway is the safety net; single-refresher election is the design — the
   test must verify the design, not the net** (John's rider, 2026-07-16, after
   the backend work confirmed the 30-second leeway is real and legitimately
   forgiving). Because the leeway tolerates most realistic two-tab timings on
   its own, an acceptance test asserting only "both tabs remain signed in, zero
   revocations" could pass with the election mechanism **entirely broken** — the
   leeway would quietly cover for it, exactly as long as both tabs happen to
   race within 30 seconds of each other, which is the common case but not a
   guarantee (a backgrounded tab that only wakes minutes later is the case that
   actually needs coordination, and a leeway-masked test would never catch its
   own mechanism failing). **The browser-tier test must assert the mechanism
   directly**: exactly ONE refresh request crosses the wire at the expiry
   boundary (a network-request count or an instrumented refresh-attempt
   counter), with both tabs ending up holding the same rotated token pair. "Both
   stay signed in" is necessary but not sufficient; the request-count assertion
   is what actually proves the election worked rather than the leeway quietly
   absorbing a broken one.

2. **Refresh-token rotation, explicit not implicit, two explicit lifetime
   numbers.** Verified directly against the installed `OpenIddict.Server` 7.5.0
   package's XML docs (not assumed): **rolling refresh tokens and sliding
   expiration are both already ON by default** — `DisableRollingRefreshTokens`
   and `DisableSlidingRefreshTokenExpiration` are opt-*out* flags, and
   `IdentityModule.cs` calls neither today, so rotation is already active; it has
   simply never been *stated* as a deliberate choice, and the lifetime itself has
   never been set (silently inheriting whatever OpenIddict's internal default is).
   Per John's ruling, sliding-only is rejected as insufficient on its own — an
   active session would live forever, which both defeats orphan hygiene at the
   limit and weakens the revocation story. Two explicit numbers, both stated here
   rather than silently defaulted:
   - **14-day sliding inactivity window** — `SetRefreshTokenLifetime(TimeSpan.
     FromDays(14))`. Each successful refresh rotates the token and resets this
     window (sliding expiration's default behavior), so an actively-used session
     never surprise-expires.
   - **90-day absolute cap** — regardless of activity, a session older than 90
     days from its `authorization_code` grant (its `SessionDevice.CreatedAt`)
     must re-authenticate. OpenIddict has no built-in "sliding + absolute cap"
     combination — `SetRefreshTokenLifetime` alone only gives the sliding half.
     The absolute cap is enforced with a custom check in
     `TokenEndpoints.HandleTokenAsync`'s `refresh_token` grant branch: if
     `clock.UtcNow - session.CreatedAt > 90.Days()`, revoke the authorization and
     refuse the grant instead of issuing a new token pair, the same way an
     explicit `RevokeAsync` call does today.

   **Reuse detection is load-bearing security, not an implementation detail**
   (John's rider). Rolling refresh tokens mean a redeemed (already-used) refresh
   token being presented again is a reuse signal — normally the fingerprint of a
   stolen, persisted token being used by both the thief and the legitimate client.
   OpenIddict's own framing for why rolling is on by default is explicit:
   *"Disabling rolling refresh tokens is NOT recommended, for security reasons"*
   (`OpenIddictServerBuilder.DisableRollingRefreshTokens` XML doc). This is
   exactly the compensating control that caps the value of the exact
   `localStorage` exfiltration rider 2 below accepts: a stolen refresh token gets
   **one use** before the legitimate client's own next refresh trips reuse
   detection. **Acceptance test, explicit**: redeem the same refresh token twice
   → the second attempt fails, and the underlying authorization/session is
   revoked (subsequent refresh attempts with the *rotated* token also fail; the
   client lands cleanly signed out, not on an error). The exact runtime behavior
   on detected reuse (full-authorization revocation vs. single-token refusal) is
   asserted by this test, not merely assumed from the docs above — the XML
   comments confirm the *setting surface* (rolling is on, `RefreshTokenReuseLeeway`
   defaults to a 30-second grace window for genuinely concurrent, non-malicious
   requests — see rider 3 below), not the exact enforcement consequence, which
   this test pins down empirically.

3. **App-start restore flow:** on launch, read the persisted refresh token (if
   any) and attempt a silent `refresh_token` grant.
   - **Success** → restore the session (same authorization → same SessionDevice →
     stable session id, `LastSeenAt` updated, **no new session row**).
   - **Failure** (expired, consumed, or revoked refresh token) → **clean
     signed-out state, never a surfaced error** — the user simply starts as a guest,
     exactly the outcome a fully-expired session already produces. **This
     guarantee is not just for the "closed while revoked" case (rider (c)
     below) — John's rider (2026-07-16): the 90-day absolute cap and a detected
     reuse are two MORE triggers that land the client in exactly this same
     failure branch** (both, per the backend implementation, present as an
     ordinary refresh_token-grant rejection — no distinct error shape the client
     needs to special-case). All three triggers (revoked-while-closed, cap
     expiry, reuse detection) must be asserted to produce the identical clean
     sign-out, never an error screen or a limbo state.

4. **Orphan hygiene** (SessionDevice "active" semantics): a SessionDevice whose
   refresh-token family is no longer usable (revoked, or `LastSeenAt` older than the
   refresh-token lifetime → its family has necessarily expired) must **not render as
   "active."** `GET /me/sessions` filters to genuinely-live sessions, and the dev
   data's existing reload-spawned orphans get cleaned up. Once app-start uses
   refresh instead of re-login, no *new* orphans are created — this is both a
   backfill and a forward guarantee.

## Alternatives considered

**BFF / cookie-session (rejected for V1 as disproportionate).** A
backend-for-frontend would keep the web client from ever holding tokens at all: the
browser holds only an `httpOnly`, `Secure`, `SameSite` session cookie (unreadable
by JS, so **no XSS token-theft vector**), and a server-side session store maps that
cookie to the real tokens, which a thin proxy attaches to upstream API calls.

Rejected for V1 because:

- It requires a **stateful server-side session store** and a **token-handling
  proxy layer** that don't exist today — net-new infrastructure for a
  low-frequency, already-mitigated risk.
- It **splits the platform by client type**: native apps can't use a browser
  `httpOnly` cookie the same way, so we'd run *two* session models (BFF for web,
  bearer tokens for native) instead of one, or bolt a second scheme onto native.
  ADR-0003 deliberately unified web and native on one cookie-then-PKCE-bearer flow;
  a BFF re-splits exactly what that ADR joined.
- The compensating control we already need for other reasons — a **strict CSP**
  (T139) — substantially reduces the very XSS vector the BFF exists to eliminate.

The BFF is the right answer if/when the web client's threat model warrants
eliminating browser-resident tokens entirely (e.g. handling higher-sensitivity data
than V1's). It is recorded here as **deferred, not foreclosed** — nothing in this
decision blocks adopting it later behind the same `IdentityAuthService` seam.

## Consequences

- **New client dependency**: `flutter_secure_storage` (native); `shared_preferences`
  (web) is already present. A small `TokenStore` abstraction picks the backend by
  platform (conditional import, same pattern as `web_authorize.dart`), so the rest
  of the app is unaware.
- **New launch-gate rider on T139 (CSP hardening)**: web token persistence's XSS
  exposure is accepted *only* with a strict CSP shipped. This must be filed as an
  explicit T139 sub-item and gate launch — persisting tokens in `localStorage`
  without a CSP is not an acceptable production posture. **Web token persistence and
  the CSP ship together, or neither does.**
- **Session-identity guarantees now testable** (the T177 acceptance set): (a)
  reload resumes the *same* session (stable id, unchanged count, `LastSeenAt`
  updated — a new row on reload is a failure); (b) orphan hygiene (explicit
  refresh-token lifetime; dead sessions don't render active; existing orphans
  cleaned up); (c) revocation linkage — revoke from browser B while browser A is
  closed → A's next launch does a `refresh_token` grant against a now-revoked
  authorization → OpenIddict refuses it → A lands **signed out**, not silently
  resumed. (c) works *for free* from OpenIddict's existing `TryRevokeAsync`
  semantics precisely because restore uses refresh (not a fresh login). (d)
  reuse detection — redeem the same refresh token twice → second attempt fails,
  authorization revoked, client lands cleanly signed out. (e) multi-tab
  coordination — asserts the MECHANISM (John's rider 2, 2026-07-16), not just
  the outcome: two tabs open across a token-expiry boundary → exactly ONE
  refresh request crosses the wire (request-count/attempt-counter assertion),
  both tabs end up holding the identical rotated token pair, zero revocation
  events. "Both stay signed in" alone is insufficient — OpenIddict's own
  30-second reuse leeway would mask a fully broken election in most realistic
  timings, so only the request-count assertion actually proves coordination
  works rather than the leeway quietly covering for it. (f) cap/reuse clean
  sign-out (John's rider 3) — the SAME clean-signed-out assertion as (c),
  extended to two more triggers: a session hitting the 90-day absolute cap, and
  a detected reuse. All three (c)/(f)'s two triggers must land the client
  identically signed out, never an error screen or limbo state.
- **T167 disposition: unaffected, pending confirmation — not yet closed** (John's
  rider: "accepted as unaffected, not yet closed"). The tie-break fix
  (`ThenByDescending(s => s.Id)` in `SessionsEndpoints.ListAsync`) stands as the
  deterministic ordering guarantee, and this design *reduces* the rate of
  same-tick session creation (reload now reuses the authorization instead of
  minting a new row), so the reasoning can only lessen, never reintroduce, the
  timestamp-collision condition that originally surfaced the flake. But T177
  rebuilds the exact refresh-validation path the flake lived on, so reasoning
  alone doesn't close it. **Once implementation lands, the revocation-adjacent
  acceptance set (session list ordering, revoke-then-list, the new reuse-detection
  and multi-tab tests above) must be run repeated — ≥10 iterations — with clean
  results on every run.** T177's final report must cite that evidence line before
  T167 is marked closed for real.
- **Not in scope**: true immediate mid-lifetime access-token invalidation for
  high-severity events remains T166 (launch-gated with T139). This ADR is about
  *session continuity*, not shortening the ≤10-minute revocation window T166 owns.

## Cross-tab coordination — as built (T177 #100, 2026-07-16)

**What was built.** The single-refresher election lives in
`core/auth/refresh_coordinator.dart`'s `coordinatedRefresh`, which both refresh
callers now go through instead of `silentlyRefreshTokens` directly
(`TokenRefreshInterceptor`'s 401 recovery, and `sessionRestoreProvider`'s
app-start restore). The web/native split is a conditional import
(`cross_tab_channel_stub.dart` vs `cross_tab_channel_web.dart`, matching
`web_authorize.dart`'s established pattern):

- **Web**: `navigator.locks.request('specpour.refresh', …)` is the election —
  exactly one tab holds the exclusive lock and does the refresh; queued tabs, on
  acquiring the lock, see the rotated token already in storage and **adopt** it
  rather than redeeming the now-stale one. The winner's fresh `{access, refresh}`
  pair is distributed to the other tabs over a `BroadcastChannel('specpour.auth')`
  (the access token is never persisted, so it must travel in the message); a
  persistent listener (`crossTabAuthSyncProvider`, watched once at app start)
  applies it to the other tabs' in-memory providers. The queued adopter waits on
  that broadcast (bounded), with a documented fallback to a single refresh with
  the fresh stored token only in the pathological "broadcast never arrives" case.
- **Native**: the channel primitives are no-ops — a native app is single-context,
  so the lock is always uncontended and `coordinatedRefresh` degenerates cleanly
  to a plain `silentlyRefreshTokens`. Zero behavioural change off-web.

**Leeway interplay (unchanged from the decision above, restated for the reader
here).** OpenIddict's 30-second `RefreshTokenReuseLeeway` is the *safety net* that
absorbs most near-simultaneous races; the election is the *design*. The mechanism
test therefore asserts the mechanism (exactly one refresh **attempt** crosses the
wire — see the counter rider below), not merely the outcome, because the leeway
would make an outcome-only test ("both tabs stay signed in") pass even with the
election entirely broken.

**Harness fidelity — iframe vs tab (so this isn't re-litigated).** The existing
headless-Chrome `flutter drive` tier is single-context. A probe that opened a
second same-origin **tab** via `window.open()` from inside a driven test **wedged
the entire run** (killed after 11 minutes): the driver controls exactly one tab,
and a second tab/window handle hangs it. So two real *tabs* are not drivable in
this harness. The chosen path is a same-origin **`<iframe>`** hosting a second
agent: an iframe shares the origin's `LockManager` (Web Locks), its
`BroadcastChannel`, and its `localStorage`/`storage` events with the top document,
so the second agent exercises the *identical* cross-context coordination
primitives — the assertion is about refresh coordination between two real agents,
and the second agent runs unmodified production `coordinatedRefresh` code. One
production nuance to note, not a fidelity hole: real browsers **throttle
background tabs** (timers, rAF, and — on some engines — lock acquisition urgency)
in ways a same-page iframe is not throttled; the coordination primitives are
identical, only the timing/throttling environment differs slightly, and the
election's correctness does not depend on timing (the lock serialises regardless).

**Server-side attempt counter (test-only, Development-gated).** The mechanism
assertion needs to count `refresh_token` *grant requests received* per
authorization — **attempts, not successes**: if coordination is broken but both
requests land inside the reuse leeway, both *succeed*, so a success counter would
read a false-green "2 successes fine" while an attempt counter correctly reads "2
attempts → FAIL." That counter's observable surface is **Development-environment
only** (gated test endpoint/hook) — never a production surface, to avoid leaking
grant telemetry.
