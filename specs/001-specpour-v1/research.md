# Phase 0 Research: SpecPour V1

All Technical Context unknowns resolved. Each decision below is constrained first by the
constitution (v1.1.0); where the constitution is silent, the decision optimizes for the
Long-Horizon Rule (Principle VIII) and ATDD practicability (Principle I).

## R1. Backend runtime and framework

- **Decision**: .NET 10 (current LTS at project start) with ASP.NET Core Minimal APIs
  hosted as a single containerized service.
- **Rationale**: Constitution mandates C#/.NET current LTS, containerized, stateless.
  .NET 10 is the active LTS (Nov 2025, supported through Nov 2028). Minimal APIs keep
  per-module endpoint registration explicit, which suits per-module endpoint ownership.
- **Alternatives considered**: .NET 8 LTS (older, shorter runway); MVC controllers
  (more ceremony, no benefit for a contract-first API where OpenAPI is authored, not
  inferred).

## R2. Modular monolith composition

- **Decision**: One solution; each business module is a set of projects
  (`<Module>.Domain`, `<Module>.Application`, `<Module>.Infrastructure`,
  `<Module>.Contracts`) with `InternalsVisibleTo` disabled across modules. Modules
  register into the host via a per-module `IModule` composition interface. Cross-module
  calls go only through `<Module>.Contracts` interfaces; cross-module consistency uses
  domain events on an in-process outbox-backed dispatcher (extraction-ready: the outbox
  table and event envelope are transport-agnostic).
- **Rationale**: Principle III demands strict boundaries, one-way dependencies, and
  extraction without domain rewrite. The outbox pattern gives eventual consistency now
  and a message-broker seam later.
- **Alternatives considered**: Single project with folder conventions (unenforceable
  boundaries); MediatR-style shared bus for commands across modules (encourages
  boundary leaks); separate services now (violates single-deployable mandate).

## R3. Persistence and migrations

- **Decision**: PostgreSQL 17 with PostGIS extension enabled in the base migration.
  EF Core per module with one `DbContext` per module mapped to a dedicated PostgreSQL
  schema (`identity`, `catalog`, `ingredients`, …). Migrations are per-module,
  forward-only, applied by a migration runner job at deploy (never at app start in
  production). No cross-schema foreign keys — cross-module references are by stable ID
  only.
- **Rationale**: Constitution: module-owned schemas within one database until
  extraction; versioned forward-only migrations; PostGIS from day one (FR-058).
  ID-only references keep extraction to separate databases mechanical.
- **Alternatives considered**: Dapper (more control, but EF migrations tooling and
  LINQ productivity win for a large domain); single shared DbContext (violates module
  schema ownership); cross-schema FKs (blocks extraction).

## R4. ATDD and test tooling

- **Decision**: Reqnroll (Gherkin for .NET, the maintained SpecFlow successor) for
  acceptance tests, executed against the real composed host with Testcontainers-managed
  PostgreSQL. Unit tests in xUnit. Contract tests validate the running API against the
  authored OpenAPI documents (schema + response validation per operation). Flutter:
  `integration_test` for client acceptance flows, `flutter_test` for unit/widget.
  CI gate: acceptance + unit + integration + contract must be green to merge.
- **Rationale**: Principle I requires business-readable Given/When/Then agreed before
  code, failing-first; the constitution names these tool families as examples. Real
  PostgreSQL (not in-memory) keeps FTS/PostGIS behavior honest.
- **Alternatives considered**: SpecFlow (unmaintained); plain xUnit acceptance tests
  (loses business-readable criteria); mocked persistence in acceptance tests (violates
  the spirit of container-backed integration testing).

## R5. API contract authoring and client generation

- **Decision**: Contract-first: OpenAPI 3.1 documents are authored by hand (one root
  document, per-module path files bundled at build), versioned under `/api/v1`.
  The Dart client SDK is generated in CI (openapi-generator, `dart-dio`) and published
  as a package the Flutter app consumes; hand-editing generated code is prohibited.
  Breaking changes require `/api/v2` plus a documented deprecation window.
- **Rationale**: Principle II: the contract is the source of truth, reviewed before
  implementation on either side; Dart SDKs generated, never hand-maintained.
- **Alternatives considered**: Code-first Swashbuckle generation (contract becomes an
  implementation artifact — violates contract-first); GraphQL (constitution mandates
  REST-over-HTTPS).

## R6. Identity and authentication

- **Decision**: Isolated `identity` module built on ASP.NET Core Identity for
  credential storage/lifecycle, with OpenIddict issuing platform tokens
  (authorization code + refresh flows for the Flutter/web clients). External OIDC
  social sign-in (Google, Apple, Microsoft at launch) consumed through an
  `IExternalIdentityProviderPort` adapter per provider. Optional TOTP MFA; secure
  recovery; session/device management modeled as first-class entities backing the
  device list UI. DOB captured at registration (FR-002). Deactivation grace period is
  an operator config (default 12 months) enforced by a scheduled job.
- **Rationale**: Principle VIII names identity as its own consumer-scale module with
  providers behind ports. ASP.NET Core Identity + OpenIddict are the proven
  open-source pair (no commercial license dependency like Duende).
- **Alternatives considered**: Duende IdentityServer (license cost); external IDaaS
  (Auth0/Entra — hard vendor dependency contradicting cloud-agnostic posture; still
  fine later as an adapter if wanted).

## R6a. Sensitive-PII handling: stored DOB

- **Decision**: The identity module exclusively owns the stored DOB. The column is
  encrypted at the application layer (AES-GCM via .NET Data Protection with a
  dedicated key ring, rotated; ciphertext in PostgreSQL — protection beyond disk
  encryption, no plaintext ever at rest). Identity's internal contract exposes only
  derived predicates — `IsOfLegalDrinkingAge(userId, jurisdiction)` and analytics age
  bands — no method returns the raw value; the sole raw-value read path is the
  owner's data-export flow, and every decrypt is written through the audit port.
  Registration validates entered DOB against the jurisdiction rule (coarse GeoIP,
  strictest-rule default) before persisting anything: underage attempts return a
  rejection and persist nothing (no DOB, no identifying attempt record); retry-gaming
  is resisted by client-side flagging plus the anonymous-traffic rate limiter. Serilog
  destructuring policy + OTel processors scrub any `dateOfBirth`-shaped field
  defensively; contract tests assert no API schema outside `/me/export` contains a DOB
  field (SC-017).
- **Rationale**: Constitution v1.3.0 Engineering Standards (sensitive-PII data
  classification); FR-002b/FR-002c; COPPA posture for under-13 data.
- **Alternatives considered**: pgcrypto column encryption (keys visible to the
  database session; app-layer keeps keys out of the DB tier); storing failed attempts
  hashed for abuse analysis (still an identifying record of a minor — prohibited);
  storing only an age-verified boolean and discarding DOB (vetoed by the source
  statement: future age-gated features need the stored DOB to activate without
  re-collection).

## R7. Authorization: tiers, roles, scopes

- **Decision**: `authorization` module owning (a) the capability/entitlement map —
  feature code declares capability keys; tier→capability mapping lives in database
  configuration with cached evaluation; Guest is a configured pseudo-tier floor
  (FR-004b) — and (b) role grants as `(user, role, scope)` rows with granular
  permissions, platform scope only in V1 (FR-004a). Enforcement via a policy layer
  that resolves capability + role checks server-side; the client receives an
  entitlement manifest to shape UI.
- **Rationale**: Principle VI: three independent axes, configuration-driven, no code
  branches per tier (SC-011 requires new tiers by configuration only).
- **Alternatives considered**: Claims-only JWT roles (bakes entitlements into tokens —
  stale on tier change); policy constants in code (violates configuration mandate).

## R8. Search

- **Decision**: `ISearchPort` internal port; V1 adapter uses PostgreSQL full-text
  search (tsvector columns maintained per searchable entity, `websearch_to_tsquery`,
  trigram index for name fuzziness) plus faceted filtering composed in SQL. Port
  contract tests define behavior so a dedicated engine is a pure adapter swap.
- **Rationale**: FR-049 and Principle VIII: search behind a port, PostgreSQL FTS
  acceptable initially.
- **Alternatives considered**: OpenSearch/Meilisearch now (premature operational
  cost); LIKE queries (can't meet SC-002 quality).

## R9. Offline-first client architecture

- **Decision**: Flutter with a local SQLite store via Drift as the offline cache and
  sync workspace. Read model: synced content tables per offline profile tier
  (per-device profile; per-account pinned collections per FR-052). Local search and
  makeability (FR-053a) run against the local store (FTS5 for text search; makeability
  computed from synced hierarchy/substitution data). Sync protocol: versioned
  (`syncVersion` handshake), change-log based pull with cursor, push queue for
  user-authored edits; conflicts on user-authored content produce a merge-or-prompt
  resolution flow (FR-053), never silent last-writer-wins. Local schema migrations via
  Drift's versioned migrator.
- **Rationale**: Principle IV: offline-first, tiered profiles, versioned sync
  protocol, migratable local schema. Drift is the mature Dart relational store with
  migration support and FTS5.
- **Alternatives considered**: Hive/Isar (weak relational querying for makeability
  math); replicating server DB wholesale (storage-tier profiles require selective
  sync); CRDTs (overkill — merge-or-prompt is the mandated semantics).

## R10. AI provider abstraction and prompts

- **Decision**: `ai` module exposing feature-level ports (`IChatAssistPort`,
  `IInsightPort`, `IAuthoringAssistPort`, `IDiscoveryPort`, `ILabelRecognitionPort`)
  over a provider adapter layer (`ILlmProviderAdapter`, `IVisionProviderAdapter`).
  Providers configured per deployment (hosted or local). Prompts are versioned
  artifacts in a prompt registry: each prompt version records model, provider, and
  evaluation results (Principle V). Every AI feature has a feature flag (individually
  toggleable), a deterministic fallback (discovery similarity scorer) or clean absence,
  and AI output labeling in the API contract (`aiGenerated: true`). Barcode scan is a
  non-AI on-device path; label photo recognition degrades to pre-filled manual form
  (FR-030).
- **Rationale**: Principle V verbatim; AI-assist is the presumed first extraction
  candidate, so it gets the loosest coupling (its own module, event/HTTP-shaped
  internal contract).
- **Alternatives considered**: Direct SDK calls from features (violates ports rule);
  a single generic "IAiPort" (feature-level toggles and fallbacks need feature-level
  seams).

## R11. Media storage

- **Decision**: `media` module with `IObjectStoragePort`; V1 adapter targets any
  S3-compatible endpoint (MinIO in local Docker Compose; S3-compatible layer in
  production). Uploads via pre-signed URLs; DB stores metadata + attachment records
  only (generic media-attachment structure per FR-023, video-ready).
- **Rationale**: Constitution: binary media in S3-compatible object storage behind an
  abstraction, never in DB or local disk.
- **Alternatives considered**: Azure Blob SDK directly (hard Azure dependency without
  a seam — prohibited).

## R12. Notifications (thin V1 slice)

- **Decision**: `notifications` module: inbox message store (always-on channel),
  `IPushChannelAdapter` (FCM/APNs via a unified adapter) as per-user opt-in channel.
  Producers publish typed notification events (prep expiry, deactivation-expiry
  warning); the module owns delivery, preferences, and audit. No email digests in V1;
  transactional identity emails (recovery, verification) go through the same module's
  `IEmailChannelAdapter` so nothing is ad hoc.
- **Rationale**: FR-040a and Principle XI: single notifications capability, inbox
  default, opt-in channels, auditable, adapters at the boundary.
- **Alternatives considered**: Per-feature direct push/email calls (prohibited);
  deferring the whole module to Phase 2A (FR-040a explicitly pulls a thin slice into
  V1).

## R13. Age-affirmation capability

- **Decision**: `compliance` module holding per-surface gate configuration
  (off/soft/mandatory) and per-jurisdiction legal-age values (legal-counsel-supplied
  data). Client renders the DOB-entry gate; jurisdiction selected by coarse
  IP-geolocation through an `IGeoIpPort` adapter (no device location — avoids
  Principle XII consent machinery for this feature), strictest-rule default when
  uncertain. Entered DOB is validated client-side against the served rule and never
  transmitted or stored; only a client-side "affirmed" flag persists. Registered
  users gate on account DOB server-side.
- **Rationale**: FR-002a verbatim; data minimization (Principle XII) — checked, never
  stored.
- **Alternatives considered**: Server-side DOB validation (would transmit DOB —
  contradicts checked-never-stored); precise geolocation (unnecessary, consent-heavy).

## R14. Measurement, dilution, and ABV conventions

- **Decision**: A single `measurements` conversion/calculation service (Principle VII
  requires one conversion service) with documented, versioned convention constants:
  canonical storage in millilitres (counts stored as counts with per-unit ml
  equivalences: dash = 0.92 ml, barspoon = 5 ml — documented, curator-adjustable);
  method-standard dilution assumptions (stirred ≈ 20–25%, shaken ≈ 25–30%, built/no
  added dilution configurable per method) captured as a documented convention table
  used by ABV, standard-drinks (jurisdiction-aware standard-drink gram values), and
  pre-dilution batch math. All convention values live in versioned reference data, not
  code.
- **Rationale**: FR-032/FR-033/FR-034/SC-005 require *documented* conventions and
  exact acceptance-test conformance; values-as-data lets curators refine without
  release.
- **Alternatives considered**: Hard-coded constants (blocks refinement); per-recipe
  dilution entry only (defaults still needed).

## R15. Rating events and projections

- **Decision**: `community` module stores immutable rating events (append-only table:
  rater, subject ID + subject type, value, occurred-at, context). Projections
  (per-subject aggregate: mean over each user's latest event, count) are separate
  recomputable tables updated transactionally-adjacent via the outbox; a recompute
  job can rebuild any projection from events (SC-010 test asserts equality).
- **Rationale**: FR-009/FR-057 and clarified latest-per-user semantics.
- **Alternatives considered**: Full event-sourcing framework for the whole domain
  (overkill); computed-on-read aggregates (fine at V1 scale but projection tables are
  the documented pattern and match SC-012 headroom).

## R16. Observability and API infrastructure

- **Decision**: OpenTelemetry SDK (traces/metrics/logs) with correlation ID propagated
  from client → API → module boundaries; Serilog structured logging; `/health/live`
  and `/health/ready` endpoints; rate limiting middleware on anonymous traffic
  (FR-004b) via ASP.NET Core rate limiter. Docker Compose for the full local stack
  (API, PostgreSQL+PostGIS, MinIO, otel-collector). Infrastructure-as-code from the
  first deployment target onward.
- **Rationale**: Constitution Engineering Standards; cloud-agnostic (OTel is
  vendor-neutral).
- **Alternatives considered**: Application Insights SDK (Azure-specific without a
  seam — prohibited).

## R17. Flutter app architecture

- **Decision**: Feature-first folder structure with Riverpod for state/DI, go_router
  for navigation (deep links for web/SEO surface), generated `dart-dio` API client as
  a separate package, i18n via Flutter's `intl`/ARB workflow with all strings keyed
  from the first commit (Principle VII), WCAG 2.1 AA-aligned theming (contrast,
  scalable type) with bar mode as a dedicated high-contrast large-type theme + wakelock
  + speech-to-text voice advance behind an accessibility service seam.
- **Rationale**: Single codebase, three first-class platforms; parity default;
  accessibility and i18n constitutional from day one.
- **Alternatives considered**: BLoC (fine, but Riverpod composes better with the
  generated client and offline repositories); separate web app (violates single
  codebase).

## R18a. Platform administration (staff surface, roles, audit)

- **Decision**: The `authorization` module owns the platform role catalog
  (configuration data: role → permission set; Super Admin, Curator, Moderator,
  Support, dormant Billing Admin) and the append-only audit log (partitioned table,
  no UPDATE/DELETE grants, writes via a single audit port used by every module's
  administrative operations). Staff consoles ship as a web-only feature area in the
  Flutter app (`features/admin`), route-guarded by the entitlement manifest +
  platform-role check and compiled into the web target's admin routes (mobile builds
  exclude the routes — the justified parity exception, FR-066). First Super Admin is
  seeded by the MigrationRunner/Seeder from environment configuration; a break-glass
  procedure (documented runbook: deployment-level re-seed with dual-control) covers
  total Super Admin loss. Identity enforces mandatory MFA at token issuance for any
  account holding a platform-scoped role (FR-064). Platform-scope grants require a
  Super Admin approval step recorded in the audit log.
- **Rationale**: Spec §19 / FR-061–FR-066; constitution v1.2.0 Principle XIV
  (append-only audit, mandatory staff MFA, explicit-grant-only).
- **Alternatives considered**: Separate admin web app (violates single-codebase
  economics; the role-guarded feature area is sufficient at V1 staff headcount);
  audit log per module (fragments the mandated single append-only record); database
  triggers for audit (opaque; the port keeps before/after capture explicit and
  testable).

## R18. Web SEO surface for guest content

- **Decision**: Flutter web serves the app; public content pages (recipes, glossary,
  concept pages) additionally get server-rendered lightweight HTML for crawlers via an
  API-backed static rendering endpoint (same OpenAPI surface, HTML projection) —
  crawlable/shareable URLs per FR-004b without abandoning the single Flutter codebase.
- **Rationale**: FR-004b requires crawlable/shareable public web content; Flutter web
  alone is weak for SEO.
- **Alternatives considered**: Full SSR web frontend duplicate (violates platform
  parity/single codebase economics); no SEO surface (fails FR-004b).
