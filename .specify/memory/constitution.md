<!--
Sync Impact Report
==================
Version change: 1.3.0 → 1.4.0 (amendment from revised docs/constitution-statement.md:
anti-gamification guardrail added to Principle XIII — engagement mechanics must never
reward consumption volume or drinking frequency, and no prompts may encourage
additional in-session drinking).
Prior amendments: 1.2.0 → 1.3.0 (sensitive-PII data classification in Engineering
Standards); 1.1.0 → 1.2.0 (platform-administration governance in Principle XIV);
1.0.0 → 1.1.0 (network-era principles ahead of the Phase 2 addendum)
Modified principles:
  - III. Architecture: Modular Monolith, Extraction-Ready — added explicit Clean
    Architecture paragraph: absolute dependency rule; every external integration
    (LLM, POS, object storage, notification channels, map/geocoding, identity- and
    business-verification, retailer, payment/subscription) behind a port/adapter pair;
    contract tests per port.
  - VI. Authorization and Tier-Gating Infrastructure from Day One — replaced
    "super-admin-equivalent" default-tier framing with "unlocks all end-user
    capabilities"; tier display names are localizable configuration while identifiers
    are stable keys; tiers, platform-staff roles, and scope-bound roles are three
    independent authorization axes.
Added sections:
  - X. Multi-Sided Platform Boundaries
  - XI. Communications and Notification Infrastructure
  - XII. Geolocation Privacy
  - XIII. Regulated-Industry Posture (Alcohol)
  - XIV. Trust, Verification, and Content Integrity
  - XV. Analytics and External Data Ingestion
  - Governance: three new encoded assumptions (client-side geofencing default;
    license-document retention window; strictest-applicable-rule age gating)
Removed sections: none
Templates:
  - .specify/templates/plan-template.md ✅ updated (Constitution Check gates III and VI
    expanded; new gates X–XV added)
  - .specify/templates/spec-template.md ✅ aligned (no new mandatory spec sections)
  - .specify/templates/tasks-template.md ✅ aligned (ATDD mandate unchanged)
  - .specify/templates/checklist-template.md ✅ aligned (no principle-specific content)
  - .specify/templates/commands/ — directory does not exist; check skipped
Specs:
  - specs/001-specpour-v1/spec.md ✅ already consistent (FR-004a/FR-004b
    encode the three-axis authorization model; new principles govern Phase 2 surfaces)
Follow-up TODOs: none
-->

# SpecPour Constitution

SpecPour (working name) is a cross-platform craft-cocktail application serving both
home enthusiasts and professional bartenders. This constitution defines the
non-negotiable engineering principles, architectural fundamentals, and development
practices for the project. Business logic and functional scope are defined separately in
the specification (see `docs/specification-statement-rev2.md` and, for Phase 2,
`docs/phase2-specification-statement.md`).

## Core Principles

### I. Test-First Development — ATDD (NON-NEGOTIABLE)

Acceptance Test Driven Development governs all feature work. Acceptance criteria MUST be
written in business-readable Given/When/Then form and agreed upon before any
implementation code is written. No production code may be merged without failing-first
acceptance tests that subsequently pass (red-green). Unit and integration tests
supplement, but never substitute for, acceptance tests.

Specific tooling is not mandated by this constitution — teams select tools that best
express the practice (e.g., Gherkin-based frameworks for .NET, container-backed
integration tests against real PostgreSQL, Flutter integration testing frameworks) — but
the practice is mandatory and enforced by CI gates: no merge without green acceptance,
unit, integration, and contract tests, and no reduction in coverage of critical paths.

### II. Contract-First API Design

The API contract is the source of truth. All backend/frontend interaction MUST be
REST-over-HTTPS, described in OpenAPI, versioned, and reviewed before implementation on
either side. Client SDKs (Dart) MUST be generated from the contract, never
hand-maintained. Breaking changes require a new API version with a documented deprecation
window. Contract tests MUST verify the implementation never drifts from the published
contract.

### III. Architecture: Modular Monolith, Extraction-Ready

The backend is a single deployable modular monolith with strict internal boundaries
(clean/hexagonal architecture). Each business module (e.g., recipes, ingredients,
inventory, glossary, AI-assist, media) owns its domain model, exposes capabilities only
through explicit internal contracts, and MUST NOT reach into another module's
persistence. Modules MUST be extractable into independent microservices without
rewriting domain logic — communication patterns, dependency direction, and data ownership
are designed for extraction from day one. The AI-assist module is the presumed first
extraction candidate and MUST be especially loosely coupled. Cross-module transactions
are avoided; where consistency spans modules, use domain events and eventual consistency
patterns.

Clean Architecture is explicit, not aspirational: the dependency rule is absolute —
domain and application layers depend on nothing external; all frameworks, drivers, and
third-party services are reached only through ports (interfaces owned by the application
core) implemented by adapters at the boundary. Every external integration MUST be behind
a port/adapter pair, without exception: LLM providers, POS systems, object storage,
notification channels (email/SMS/push), map/geocoding providers, identity- and
business-verification services, retailer integrations, and payment/subscription
processors. No domain or application code may reference a vendor SDK directly. Adapters
MUST be independently testable and swappable via configuration; contract tests MUST
exist per port so new adapters verify against the same suite.

### IV. Offline-First, Configurable, Storage-Tiered Client

The client is architected offline-first: core reading and reference workflows MUST
function without connectivity, syncing when connection resumes. Offline capability is
optional and user-configurable because full offline content is storage-heavy. The client
MUST support tiered offline profiles (e.g., recipe text only; recipes + glossary;
recipes + glossary + key photos; full media), user-selectable and adjustable, with clear
storage-usage reporting. Sync MUST use a documented conflict-resolution strategy —
last-writer-wins is insufficient for user-authored content; user-authored edits require
merge-or-prompt semantics. The offline architecture is expected to evolve — design for
iteration: sync protocol versioned, local schema migratable.

### V. AI Integration: Provider-Agnostic, Gracefully Degrading

All LLM functionality MUST sit behind a provider abstraction; providers (hosted or local)
are swappable via configuration. Prompts are versioned artifacts, managed per
model/provider — prompt versioning is a first-class concept: a prompt version is tied to
model, provider, and evaluation results. Every AI-assisted feature MUST degrade
gracefully: when AI is disabled (by the user, by the operator, or by outage), the feature
either falls back to a deterministic implementation or disappears cleanly — never a
broken UI or hard dependency. AI features MUST be individually toggleable. AI outputs
presented to users MUST be labeled as AI-generated. No user data may be sent to AI
providers beyond what the invoked feature requires, and AI data-sharing MUST be disclosed
and controllable.

### VI. Authorization and Tier-Gating Infrastructure from Day One

Authentication, role-based authorization, and feature-tier gating MUST be built into the
platform from the start, even though V1 launches with a single default tier that unlocks
all end-user capabilities. Every feature MUST be declared against a capability/
entitlement map that is configuration-driven, so commercial tiers (e.g., free/home vs.
paid/professional, and constituency-specific tiers such as patron, enthusiast, venue,
producer) can be introduced, split, or re-shaped later without code changes to feature
logic. Tier definitions live in configuration/data, not in code branches scattered
through features. Tier display names and descriptions are configuration and localizable
content (per Principle VII); tier identifiers are stable internal keys. Tiers,
platform-staff roles (curator/admin/moderator), and scope-bound roles (e.g.,
venue-scoped staff access) are three independent authorization axes — commercial
entitlement, platform trust, and per-scope access — and changes to one axis MUST NOT
implicitly alter another.

### VII. Internationalization from Day One

The platform is architected for i18n from the first commit: no user-facing string may be
hard-coded; all strings MUST be externalized and keyed; layouts MUST accommodate text
expansion and RTL; dates, numbers, and units MUST render through locale-aware formatting;
measurement-unit preference (ml/oz/cl) is a user setting handled by a single conversion
service. Content translation may ship later; the architecture MUST NOT require rework to
support it.

### VIII. Long-Horizon Foundations and Economic Decision Rule

Where a short-term implementation shortcut conflicts with a foreseeable, planned platform
need, the default decision is the lower long-term total cost of ownership, not the faster
initial build. Deviations are permitted but MUST be documented in an ADR with the
explicit payback rationale and the anticipated cost of later correction. Standing
applications of this rule:

- **Identity is its own module**, built to consumer scale from the first release
  (registration, OIDC social sign-in, optional MFA, recovery, session/device management,
  account lifecycle), regardless of how few tiers or users exist at launch.
  Authentication providers sit behind the standard port/adapter boundary.
- **Evaluative user data is stored as immutable per-user events** (ratings now; analogous
  interaction events later); all aggregates are derived, versioned, recomputable
  projections. Storing only computed aggregates is prohibited.
- **Search is an internal port**: feature code consumes a search abstraction; the initial
  engine (PostgreSQL full-text is acceptable) is swappable for a dedicated engine as pure
  adapter replacement.
- **Geospatial capability is enabled in the database from day one** (PostGIS or
  equivalent), ahead of any feature using it.

This principle does not license speculative gold-plating: it applies to needs already on
the product roadmap, not hypotheticals. The test is "planned and foreseeable,"
documented in the specification.

### IX. Domain Language Discipline

The ubiquitous language of the codebase, contracts, and tests MUST follow professional
bartending and craft-cocktail industry terminology (as reflected by authoritative trade
references). Where the industry itself is inconsistent, the project's glossary module is
the internal authority: code, contracts, and UI use the terms as the project glossary
defines them, and taxonomy decisions are documented with rationale.

### X. Multi-Sided Platform Boundaries

The platform serves multiple constituencies (patrons/consumers, venues, producers,
curators) over shared domain data. Constituency-specific concerns MUST be separate
modules with their own boundaries; shared domain concepts (recipes, ingredients,
products, establishments) are owned by exactly one module and consumed by others through
internal contracts. Two domain separations are architectural law: (1) recipe (a thing
you make) vs. beverage product (a thing you consume/rate/stock) are distinct concepts
with an explicit relationship, never conflated; (2) establishment identity/verification
is a distinct module from establishment content (menus, posts, events).

### XI. Communications and Notification Infrastructure

All platform-to-user and establishment-to-subscriber communication MUST flow through a
single notifications module: in-app inbox is the default and always-on channel; email,
SMS, and push are opt-in per channel and per user, with per-establishment unsubscribe
and global quiet controls. Anti-abuse policy (frequency caps, sender rate limits,
content moderation hooks) is enforced by the platform in the notifications module —
never left to sender discretion. Channel providers sit behind adapters (Principle III).
All communications MUST be auditable.

### XII. Geolocation Privacy

Location features require explicit, purpose-specific consent. Non-negotiable rules:
purpose limitation (location is used only for the feature the user invoked — discovery,
geofenced check-in verification); data minimization (coarse location by default;
precise only where the feature demands it); minimal retention (raw coordinates are not
retained beyond the operation — derived facts like "verified visit" are stored
instead); no background tracking; and no sale or sharing of location data. Geofence
checks MUST be performed client-side where feasible so raw location never leaves the
device. Location consent is revocable, and every location-dependent feature MUST
degrade gracefully without it.

### XIII. Regulated-Industry Posture (Alcohol)

The platform operates in a regulated space. Legal-drinking-age gating
(jurisdiction-aware, defaulting to the strictest applicable rule) is required for
consumer-facing social and discovery features. Responsible-consumption messaging is a
product requirement, not decoration. Jurisdiction-aware compliance is a first-class
configuration concern (age thresholds, marketing-to-consumer rules for alcohol,
data-protection variances). Features that let establishments market to patrons MUST be
designed to comply with alcohol-advertising norms and provide the controls venues need
to comply locally. Engagement and gamification mechanics MUST never reward consumption
volume or drinking frequency: badges, achievements, trails, streaks, and notifications
may reward exploration, variety, knowledge, and venues visited — never quantity
consumed — and the platform MUST NOT send prompts whose effect is to encourage
additional drinking in-session.

### XIV. Trust, Verification, and Content Integrity

Identity and authenticity mechanisms are platform infrastructure: business
claiming/verification, review-integrity mechanics (e.g., verified-visit signals),
moderation tooling, and dispute/appeal workflows MUST be built as reusable services,
not per-feature bolt-ons. Verification evidence (e.g., license documents) is handled as
sensitive data: encrypted, access-restricted, retained only as long as required.
Aggregate ratings computation MUST be deterministic, documented, and resistant to
manipulation (weighting rules are versioned and auditable). All administrative and
staff actions (curation, moderation, role grants, tier configuration, account and
billing interventions) MUST be recorded in an append-only audit log; platform-scoped
roles require mandatory multi-factor authentication and are grantable only by explicit
administrative action — never by signup or tier assignment.

### XV. Analytics and External Data Ingestion

Third-party operational data (e.g., POS sales) enters the platform only through the
adapter layer (Principle III) into an ingestion module that normalizes to platform
entities via stable identifiers. Ingested data MUST be provenance-tagged (in-app signal
vs. manual entry vs. integrated source) end-to-end, including in every analytics
display. The platform never becomes a system of record for a venue's financial data; it
stores only what its analytics features require.

## Technology Foundation & Constraints

- **Backend**: C# / .NET (current LTS), containerized (OCI images), stateless service
  processes, horizontally scalable behind a load balancer. All state lives in PostgreSQL,
  object storage, or cache — never in the process.
- **Database**: PostgreSQL. Schema changes only via versioned, forward-only, automated
  migrations reviewed like code. No shared-database integration between modules; each
  module owns its schema (separate schemas within one database until extraction).
- **Frontend**: Flutter/Dart, single codebase targeting Android, iOS, and web as
  first-class citizens. Platform parity is the default; any platform-specific divergence
  MUST be justified and documented.
- **Media**: All binary media (photos, future video) is stored in S3-compatible object
  storage behind an abstraction; never in the database (metadata only) and never on local
  disk.
- **Cloud posture**: Cloud-agnostic. Initial development runs entirely locally via Docker
  Compose; production is expected to land on Azure, but no code may take a hard
  dependency on Azure-specific services without an abstraction seam. Infrastructure is
  defined as code.

## Engineering Standards & Quality Gates

- **Versioning**: Semantic versioning for the API, client apps, and published contracts.
- **Observability**: Structured logging (correlation IDs across client→API→module
  boundaries), metrics, health/readiness endpoints suitable for container orchestration,
  and distributed-tracing readiness.
- **Security & privacy**: OWASP-aligned secure defaults; secrets never in code or images;
  TLS everywhere; least-privilege data access; user data exportable and deletable
  (privacy-regulation-ready, e.g., GDPR posture); dependency and container image scanning
  in CI. Data classification with heightened controls for sensitive PII (e.g., DOB,
  verification documents): purpose-bound collection; application/column-level encryption
  beyond disk encryption; exclusion from logs, traces, analytics, and BI exports;
  owning-module encapsulation with access via derived predicates rather than raw values;
  audit-logged access; and non-retention of data from failed or ineligible attempts —
  notably any data indicating a minor.
- **Accessibility**: WCAG 2.1 AA is the target for all client surfaces, including the
  hands-free/large-type operational modes the product requires.
- **Code quality**: Enforced formatting and static analysis in CI for both C# and Dart;
  peer review required for all merges; architecture decision records (ADRs) for
  significant decisions.
- **Documentation**: The OpenAPI contract, ADRs, and module boundary definitions are
  living, versioned documentation and part of the definition of done.

## Governance

This constitution supersedes all other development practices for the project. All PRs,
reviews, and implementation plans MUST verify compliance with these principles; the
plan-template Constitution Check is a hard gate before design work proceeds.

- **Amendment procedure**: Amendments are proposed as changes to this document, reviewed
  and approved by the project owner (John), and MUST include a Sync Impact Report and
  propagation of changes to dependent templates (`plan-template.md`, `spec-template.md`,
  `tasks-template.md`) and guidance docs.
- **Versioning policy**: This document follows semantic versioning. MAJOR for
  backward-incompatible governance or principle removals/redefinitions; MINOR for new
  principles/sections or materially expanded guidance; PATCH for clarifications and
  non-semantic refinements.
- **Compliance review**: Every feature plan MUST pass the Constitution Check against the
  principles above before Phase 0 research and again after Phase 1 design. Violations
  MUST be justified in the plan's Complexity Tracking table or removed. Complexity beyond
  what a principle allows requires an ADR per Principle VIII.
- **Encoded assumptions** (veto any by amendment): current .NET LTS at project start;
  OCI/Docker as the container standard; S3-compatible abstraction for media even on Azure
  (via compatible layer or storage abstraction); GDPR-grade privacy posture even if the
  initial market is US; WCAG 2.1 AA as the accessibility bar; client-side geofencing as
  the default verification mechanism; license documents retained only until verification
  completes plus a short audit window; strictest-applicable-rule default for age gating.

**Version**: 1.4.0 | **Ratified**: 2026-07-10 | **Last Amended**: 2026-07-10
