# OAuth Provider Setup (Google / Microsoft / Apple)

For John: how to register real OAuth credentials for local development so the
social sign-in buttons (T049, T173) actually work end to end. Until you do
this, `GET /auth/external/providers` returns an empty list and the frontend
correctly renders no social buttons at all — that's expected, not a bug.

## How "configured" is decided

`IdentityModule.RegisterServices` registers a provider's handler — and with
it, `IExternalIdentityProviderPort` — only when that provider's `ClientId`
config key is non-empty (`backend/src/Modules/Identity/Infrastructure/IdentityModule.cs`).
`GET /auth/external/providers` (T173) reports exactly the set of registered
ports, by name, with no secrets in the response. The Flutter app fetches this
once per sign-in/register screen mount and renders only the matching buttons,
omitting the whole "or sign in with" section (divider included) when the set
is empty.

Nothing needs to change in code to add a provider — only configuration.

## Config keys

Set these via `dotnet user-secrets` in `backend/src/Api` (never commit real
secrets to `appsettings*.json`):

```
dotnet user-secrets set "ExternalProviders:Google:ClientId" "..."
dotnet user-secrets set "ExternalProviders:Google:ClientSecret" "..."

dotnet user-secrets set "ExternalProviders:Microsoft:ClientId" "..."
dotnet user-secrets set "ExternalProviders:Microsoft:ClientSecret" "..."

dotnet user-secrets set "ExternalProviders:Apple:ClientId" "..."
dotnet user-secrets set "ExternalProviders:Apple:TeamId" "..."
dotnet user-secrets set "ExternalProviders:Apple:KeyId" "..."
dotnet user-secrets set "ExternalProviders:Apple:PrivateKey" "-----BEGIN PRIVATE KEY-----..."
```

Apple has no static client secret — `IdentityModule` generates the required
signed JWT itself from `TeamId`/`KeyId`/`PrivateKey` (`options.GenerateClientSecret
= true`), so don't hunt for a "client secret" value in Apple's console.

## Redirect URIs (local dev)

The backend's callback endpoint is what you register with each provider —
not anything on the Flutter side. Local dev backend runs at
`https://localhost:7131` (`backend/src/Api/Properties/launchSettings.json`):

| Provider | Redirect URI to register |
|---|---|
| Google | `https://localhost:7131/api/v1/auth/external/google/callback` |
| Microsoft | `https://localhost:7131/api/v1/auth/external/microsoft/callback` |
| Apple | `https://localhost:7131/api/v1/auth/external/apple/callback` |

## Scopes

Request only `openid email profile` for every provider. Per the DOB-completion
design (registration/complete-registration collects date of birth as a
separate, explicit step — see `CompleteExternalRegistrationScreen`), we
deliberately never request a birthdate scope from any provider; age
verification stays in SpecPour's own hands rather than trusting a provider's
claim.

### Google (Google Cloud Console)

1. console.cloud.google.com → APIs & Services → Credentials → Create
   Credentials → OAuth client ID → Web application.
2. Authorized redirect URI: the Google row above.
3. OAuth consent screen: add the `openid`, `email`, `profile` scopes (usually
   pre-selected as "non-sensitive").
4. Copy the generated Client ID / Client Secret into the config keys above.

### Microsoft (Azure Portal / Entra ID)

1. entra.microsoft.com (or portal.azure.com → Microsoft Entra ID) → App
   registrations → New registration.
2. Supported account types: choose based on whether you want personal
   Microsoft accounts, work/school accounts, or both — SpecPour has no
   tenant restriction, so "Accounts in any organizational directory and
   personal Microsoft accounts" is the closest match to a public consumer
   product.
3. Redirect URI platform: Web. URI: the Microsoft row above.
4. Certificates & secrets → New client secret → copy the value (shown once)
   into `ExternalProviders:Microsoft:ClientSecret`.
5. API permissions: `openid`, `email`, `profile` (Microsoft Graph delegated,
   usually pre-granted by default for a new registration).
6. Application (client) ID → `ExternalProviders:Microsoft:ClientId`.

### Apple (Apple Developer)

1. developer.apple.com/account → Certificates, Identifiers & Profiles →
   Identifiers → register a Services ID (this is the OAuth "client ID",
   distinct from your app's bundle ID).
2. Enable "Sign in with Apple" on that Services ID → Configure → add the
   Apple redirect URI above and your web domain.
3. Keys → create a new key with "Sign in with Apple" enabled → download the
   `.p8` file once (Apple will not let you download it again) → its contents
   are `ExternalProviders:Apple:PrivateKey`.
4. Note the Key ID (shown when you create the key) → `ExternalProviders:Apple:KeyId`.
5. Team ID is shown on your Apple Developer membership page →
   `ExternalProviders:Apple:TeamId`.
6. The Services ID identifier itself → `ExternalProviders:Apple:ClientId`.

**Apple + iOS note (App Store Review Guideline 4.8):** if SpecPour offers any
other social sign-in option on iOS, Apple requires Sign in with Apple be
offered too. This doesn't block registering Apple credentials now (harmless
on web-only), but flags that once an iOS build ships with Google/Microsoft
sign-in enabled, Apple must ship alongside it, not trail behind. iOS hasn't
shipped yet, so this is a forward note, not a current gap.

## What still needs real credentials before it can be verified

Once you've registered credentials and set the config keys above, the actual
provider handshake (redirect → provider login → callback → token exchange)
needs to be walked through by hand in a real browser — it can't be exercised
by the sandbox (no real OAuth consent screen to click through, and T165's
fake-provider-handler test infrastructure is parked, not wired up). The
DOB-completion branch (`needsDateOfBirth=true` callback path) in particular
should get a manual pass once Google or Microsoft credentials exist, since
today it's only covered by `_FakeIdentityInterceptor`-driven widget tests
(`external_sign_in_widget_test.dart`), never a real provider round trip.
