# ADR-0003: First-party cookie login, then client-driven PKCE token exchange

**Status**: Implemented (backend T047, 2026-07-13; Flutter client T055's
register/sign-in slice, 2026-07-13 — verified end-to-end against the live
docker-compose stack via a browser-realistic curl round trip with a
cross-origin `Origin` header)
**Date**: 2026-07-13
**Decided during**: Phase 4 (US2) implementation, T047.

## Context

Phase 2 (T017) configured OpenIddict for `authorization_code` + PKCE and
`refresh_token` grants only — deliberately excluding the password grant
(`AllowPasswordFlow`), the standards-correct posture for a public/native client per
the OAuth 2.0 Security Best Current Practice (resource-owner-password-credentials is
discouraged for exactly this kind of client).

`/connect/authorize` requires an existing cookie session before it will issue an
authorization code; nothing established that cookie yet (`IdentityModule.cs`'s own
comment: "a login endpoint that establishes that cookie session lands in
T047/T051"). Two ways to fill that gap were considered:

1. A full system-browser/embedded-webview AppAuth flow (`flutter_appauth` or
   equivalent) — the client opens a real browser context, the user authenticates via
   an HTML login form served by the API, the browser redirects back to the app via a
   custom URL scheme.
2. A first-party REST login/registration endpoint that establishes the cookie
   directly from a native form (no browser/webview), followed by the client
   completing the *same* standards-compliant PKCE code exchange against
   `/connect/authorize` → `/connect/token`, reusing the cookie via a cookie-aware
   HTTP client — no user-visible browser step at all.

## Decision

**Option 2.** `POST /auth/register` and `POST /auth/login` (`AuthEndpoints.cs`)
validate credentials directly and call `SignInManager.SignInAsync`/
`PasswordSignInAsync`, establishing the cookie. The Flutter client then issues the
standard PKCE dance itself, using a cookie-jar-enabled HTTP client so the
already-established cookie is presented automatically:

1. `POST /auth/register` or `/auth/login` → cookie set.
2. Client generates a PKCE `code_verifier`/`code_challenge`, issues
   `GET /connect/authorize?...` with `followRedirects: false` and reads the
   authorization code from the `Location` header (OpenIddict issues a 302 with the
   code in the query string — no interactive UI is shown since the cookie already
   satisfies the auth challenge).
3. `POST /connect/token` with `grant_type=authorization_code` + `code_verifier` →
   access + refresh tokens.

This keeps the actual token-issuance surface (`/connect/token`) standards-compliant
and PKCE-only — nothing weakens or bypasses that. The first-party endpoints only
ever produce a cookie, never a token directly; a third party could not use
`/auth/login` to obtain an API access token without also completing the real PKCE
exchange.

## Consequences

- No system browser or webview is needed on the client, keeping the native app
  simpler than a full AppAuth integration, at the cost of the client needing to
  implement the redirect-following/PKCE logic itself (rather than delegating it to
  an established library built for the browser-redirect case).
- `/auth/register` and `/auth/login` are first-party-only in spirit — they are not
  a generic OAuth grant type and MUST NOT be exposed to third-party clients as an
  alternative token-issuance path.
- Email confirmation (`SignIn.RequireConfirmedEmail = true`, set in T017) has no
  corresponding verification flow yet; `AuthEndpoints.RegisterAsync` auto-confirms
  for V1 (tracked as new deferred task T160 — same treatment as T153/T159).
- **Flutter Web needs a different cookie mechanism than native platforms**,
  discovered building T055's client: `dio_cookie_manager`'s `CookieManager`
  explicitly asserts against web use (the browser owns cookies there — JS
  cannot read or set the `Cookie` header, it's a forbidden header name). The
  client branches on `kIsWeb`: web sets `Options.extra['withCredentials'] =
  true` (read by `dio_web_adapter`'s `BrowserHttpClientAdapter`, which then
  lets the browser's own cookie jar do the work on cross-origin requests);
  native platforms use `CookieManager` + a shared `CookieJar` as originally
  designed, since no browser is in the loop there to do it automatically. The
  web path additionally requires the API's CORS policy to
  `AllowCredentials()` (browsers silently drop `Set-Cookie` on a
  credentialed cross-origin response otherwise) — this was also missing
  (`CorsExtensions.cs` only had `AllowAnyHeader().AllowAnyMethod()`) and is
  now fixed alongside this decision.

## Alternatives considered

- Full AppAuth/system-browser flow: more standards-idiomatic for third-party OAuth
  clients, but unnecessary complexity for a first-party app that controls both ends;
  rejected for V1.
- Enabling the password grant on `/connect/token` directly: rejected — this would
  expose ROPC as a documented, reusable OAuth grant type on the standard token
  endpoint, available to any client that discovers it, not just the first-party app.
