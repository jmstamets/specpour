# Spec-Kit Constitution Statement — SpecPour

Use the following statement as the input to spec-kit's `/constitution` step. It defines the non-negotiable engineering principles, architectural fundamentals, and development practices for the project. It deliberately avoids business logic, which is defined in the specification statement.

---

Create a constitution for a cross-platform craft-cocktail application (working name: SpecPour) serving both home enthusiasts and professional bartenders, built on the following principles:

## 1. Test-First Development (ATDD) — Non-Negotiable

Acceptance Test Driven Development governs all feature work. Acceptance criteria are written in business-readable Given/When/Then form and agreed upon _before_ any implementation code is written. No production code may be merged without failing-first acceptance tests that subsequently pass (red-green). Unit and integration tests supplement, but never substitute for, acceptance tests. Specific tooling is not mandated by this constitution — teams select tools that best express the practice (e.g., Gherkin-based frameworks for .NET, container-backed integration tests against real PostgreSQL, Flutter integration testing frameworks) — but the _practice_ is mandatory and enforced by CI gates: no merge without green acceptance, unit, integration, and contract tests, and no reduction in coverage of critical paths.

## 2. Contract-First API Design

The API contract is the source of truth. All backend/frontend interaction is defined REST-over-HTTPS, described in OpenAPI, versioned, and reviewed _before_ implementation on either side. Client SDKs (Dart) are generated from the contract, never hand-maintained. Breaking changes require a new API version with a documented deprecation window. Contract tests verify the implementation never drifts from the published contract.

## 3. Architecture: Modular Monolith, Extraction-Ready

The backend is a single deployable modular monolith with strict internal boundaries (clean/hexagonal architecture): each business module (e.g., recipes, ingredients, inventory, glossary, AI-assist, media) owns its domain model, exposes capabilities only through explicit internal contracts, and never reaches into another module's persistence. Modules must be extractable into independent microservices without rewriting domain logic — communication patterns, dependency direction, and data ownership are designed for extraction from day one. The AI-assist module is the presumed first extraction candidate and must be especially loosely coupled. Cross-module transactions are avoided; where consistency spans modules, use domain events and eventual consistency patterns.

Clean Architecture is explicit, not aspirational: the dependency rule is absolute — domain and application layers depend on nothing external; all frameworks, drivers, and third-party services are reached only through ports (interfaces owned by the application core) implemented by adapters at the boundary. **Every** external integration is behind a port/adapter pair, without exception: LLM providers, POS systems, object storage, notification channels (email/SMS/push), map/geocoding providers, identity- and business-verification services, retailer integrations, and payment/subscription processors. No domain or application code may reference a vendor SDK directly. Adapters are independently testable and swappable via configuration; contract tests exist per port so new adapters verify against the same suite.

## 4. Technology Foundation

- **Backend:** C# / .NET (current LTS), containerized (OCI images), stateless service processes, horizontally scalable behind a load balancer. All state lives in PostgreSQL, object storage, or cache — never in the process.
- **Database:** PostgreSQL. Schema changes only via versioned, forward-only, automated migrations reviewed like code. No shared-database integration between modules; each module owns its schema (separate schemas within one database until extraction).
- **Frontend:** Flutter/Dart, single codebase targeting Android, iOS, and web as first-class citizens. Platform parity is the default; any platform-specific divergence must be justified and documented.
- **Media:** All binary media (photos, future video) is stored in S3-compatible object storage behind an abstraction; never in the database (metadata only) and never on local disk.
- **Cloud posture:** Cloud-agnostic. Initial development runs entirely locally via Docker Compose; production is expected to land on Azure, but no code may take a hard dependency on Azure-specific services without an abstraction seam. Infrastructure is defined as code.

## 5. Offline-First, Configurable, Storage-Tiered Client

The client is architected offline-first: core reading and reference workflows function without connectivity, syncing when connection resumes. Offline capability is _optional and user-configurable_ because full offline content is storage-heavy. The client supports tiered offline profiles (e.g., recipe text only; recipes + glossary; recipes + glossary + key photos; full media), user-selectable and adjustable, with clear storage-usage reporting. Sync uses a documented conflict-resolution strategy (last-writer-wins is insufficient for user-authored content; user-authored edits require merge-or-prompt semantics). The offline architecture is expected to evolve — design for iteration: sync protocol versioned, local schema migratable.

## 6. AI Integration: Provider-Agnostic, Gracefully Degrading

All LLM functionality sits behind a provider abstraction; providers (hosted or local) are swappable via configuration. Prompts are versioned artifacts, managed per model/provider (prompt versioning is a first-class concept: a prompt version is tied to model, provider, and evaluation results). Every AI-assisted feature must degrade gracefully: when AI is disabled (by the user, by the operator, or by outage), the feature either falls back to a deterministic implementation or disappears cleanly — never a broken UI or hard dependency. AI features are individually toggleable. AI outputs presented to users are labeled as AI-generated. No user data is sent to AI providers beyond what the invoked feature requires, and AI data-sharing is disclosed and controllable.

## 7. Authorization and Tier-Gating Infrastructure from Day One

Authentication, role-based authorization, and _feature-tier gating_ are built into the platform from the start, even though V1 launches with a single default tier that unlocks all end-user capabilities. Every feature is declared against a capability/entitlement map that is configuration-driven, so commercial tiers (e.g., free/home vs. paid/professional, and constituency-specific tiers such as patron, enthusiast, venue, producer) can be introduced, split, or re-shaped later without code changes to feature logic. Tier definitions live in configuration/data, not in code branches scattered through features. Tier _display names_ and descriptions are configuration and localizable content (per the i18n principle); tier _identifiers_ are stable internal keys. Tiers, platform-staff roles (curator/admin/moderator), and scope-bound roles (e.g., venue-scoped staff access) are three independent authorization axes: commercial entitlement, platform trust, and per-scope access — changes to one axis never implicitly alter another.

## 8. Internationalization from Day One

The platform is architected for i18n from the first commit: no user-facing string is hard-coded; all strings are externalized and keyed; layouts accommodate text expansion and RTL; dates, numbers, and units render through locale-aware formatting; measurement-unit preference (ml/oz/cl) is a user setting handled by a single conversion service. Content translation may ship later; the architecture must not require rework to support it.

## 9. Engineering Standards (Sensible Defaults)

- **Versioning:** Semantic versioning for the API, client apps, and published contracts.
- **Observability:** Structured logging (correlation IDs across client→API→module boundaries), metrics, health/readiness endpoints suitable for container orchestration, and distributed-tracing readiness.
- **Security & privacy:** OWASP-aligned secure defaults; secrets never in code or images; TLS everywhere; least-privilege data access; user data exportable and deletable (privacy-regulation-ready, e.g., GDPR posture); dependency and container image scanning in CI. **Data classification with heightened controls for sensitive PII** (e.g., DOB, verification documents): purpose-bound collection, application/column-level encryption beyond disk encryption, exclusion from logs/traces/analytics/BI exports, owning-module encapsulation with access via derived predicates rather than raw values, audit-logged access, and non-retention of data from failed or ineligible attempts (notably any data indicating a minor).
- **Accessibility:** WCAG 2.1 AA is the target for all client surfaces, including the hands-free/large-type operational modes the product requires.
- **Code quality:** Enforced formatting and static analysis in CI for both C# and Dart; all merges require review independent of the author: human peer review where a team exists; in solo-developer operation, documented human review of AI-authored changes (or independent, higher-tier AI review of human-authored changes) plus the full CI gate set satisfies this — unreviewed direct merges are prohibited in either mode; architecture decision records (ADRs) for significant decisions.
- **Documentation:** The OpenAPI contract, ADRs, and module boundary definitions are living, versioned documentation and part of the definition of done.

## 10. Long-Horizon Foundations and Economic Decision Rule

Where a short-term implementation shortcut conflicts with a _foreseeable, planned_ platform need, the default decision is the lower long-term total cost of ownership, not the faster initial build. Deviations are permitted but must be documented in an ADR with the explicit payback rationale and the anticipated cost of later correction. Specific standing applications of this rule:

- **Identity is its own module**, built to consumer scale from the first release (registration, OIDC social sign-in, optional MFA, recovery, session/device management, account lifecycle), regardless of how few tiers or users exist at launch. Authentication providers sit behind the standard port/adapter boundary.
- **Evaluative user data is stored as immutable per-user events** (ratings now; analogous interaction events later); all aggregates are derived, versioned, recomputable projections. Storing only computed aggregates is prohibited.
- **Search is an internal port:** feature code consumes a search abstraction; the initial engine (PostgreSQL full-text is acceptable) is swappable for a dedicated engine as pure adapter replacement.
- **Geospatial capability is enabled in the database from day one** (PostGIS or equivalent), ahead of any feature using it.

This principle does not license speculative gold-plating: it applies to needs already on the product roadmap, not hypotheticals. The test is "planned and foreseeable," documented in the specification.

## 11. Domain Language Discipline

The ubiquitous language of the codebase, contracts, and tests follows professional bartending and craft-cocktail industry terminology (as reflected by authoritative trade references). Where the industry itself is inconsistent, the project's glossary module is the internal authority: code, contracts, and UI use the terms as the project glossary defines them, and taxonomy decisions are documented with rationale.

## 12. Multi-Sided Platform Boundaries

The platform serves multiple constituencies (patrons/consumers, venues, producers, curators) over shared domain data. Constituency-specific concerns are separate modules with their own boundaries; shared domain concepts (recipes, ingredients, products, establishments) are owned by exactly one module and consumed by others through internal contracts. Two domain separations are architectural law: (1) **recipe** (a thing you make) vs. **beverage product** (a thing you consume/rate/stock) are distinct concepts with an explicit relationship, never conflated; (2) **establishment** identity/verification is a distinct module from establishment _content_ (menus, posts, events).

## 13. Communications and Notification Infrastructure

All platform-to-user and establishment-to-subscriber communication flows through a single notifications module: in-app inbox is the default and always-on channel; email, SMS, and push are opt-in per channel and per user, with per-establishment unsubscribe and global quiet controls. Anti-abuse policy (frequency caps, sender rate limits, content moderation hooks) is enforced by the platform in the notifications module — never left to sender discretion. Channel providers sit behind adapters (Principle 3). All communications are auditable.

## 14. Geolocation Privacy

Location features require explicit, purpose-specific consent. Principles: purpose limitation (location is used only for the feature the user invoked — discovery, geofenced check-in verification), data minimization (coarse location by default; precise only where the feature demands it), minimal retention (raw coordinates are not retained beyond the operation; derived facts like "verified visit" are stored instead), no background tracking, and no sale or sharing of location data. Geofence checks are performed client-side where feasible so raw location never leaves the device. Location consent is revocable, and every location-dependent feature degrades gracefully without it.

## 15. Regulated-Industry Posture (Alcohol)

The platform operates in a regulated space. Legal-drinking-age gating (jurisdiction-aware, defaulting to the strictest applicable rule) is required for consumer-facing social and discovery features. Responsible-consumption messaging is a product requirement, not decoration. Jurisdiction-aware compliance is a first-class configuration concern (age thresholds, marketing-to-consumer rules for alcohol, data-protection variances). Features that let establishments market to patrons must be designed to comply with alcohol-advertising norms and provide the controls venues need to comply locally. Engagement and gamification mechanics must never reward consumption volume or drinking frequency: badges, achievements, trails, streaks, and notifications may reward exploration, variety, knowledge, and venues visited — never quantity consumed — and the platform must not send prompts whose effect is to encourage additional drinking in-session.

## 16. Trust, Verification, and Content Integrity

Identity and authenticity mechanisms are platform infrastructure: business claiming/verification, review-integrity mechanics (e.g., verified-visit signals), moderation tooling, and dispute/appeal workflows are built as reusable services, not per-feature bolt-ons. Verification evidence (e.g., license documents) is handled as sensitive data: encrypted, access-restricted, retained only as long as required. Aggregate ratings computation is deterministic, documented, and resistant to manipulation (weighting rules are versioned and auditable). All administrative and staff actions (curation, moderation, role grants, tier configuration, account and billing interventions) are recorded in an append-only audit log; platform-scoped roles require mandatory multi-factor authentication and are grantable only by explicit administrative action, never by signup or tier assignment.

## 17. Analytics and External Data Ingestion

Third-party operational data (e.g., POS sales) enters the platform only through the adapter layer (Principle 3) into an ingestion module that normalizes to platform entities via stable identifiers. Ingested data is clearly provenance-tagged (in-app signal vs. manual entry vs. integrated source) end-to-end, including in every analytics display. The platform never becomes a system of record for a venue's financial data; it stores only what its analytics features require.

## 18. Fail-Closed Verification

Every automated check, gate, scan, or test in the development and deployment pipeline must fail loudly on its own inability to run. A verification step that cannot complete, cannot reach its data source, unexpectedly matches zero items, or has its failure signal swallowed (e.g., by shell pipeline semantics) must report failure — never success. "Pass" is reserved exclusively for "checked and verified," never for "could not check." Where inconclusiveness is expected and acceptable, that acceptance must be explicit and visible (a distinct skipped/warned state), not a silent pass. Scripts composing checks must propagate failure across pipelines (e.g., pipefail alongside errexit). Every new check is reviewed against this principle at introduction, and the question asked of any verification is not "does it catch the bad case?" but "what does it do when it cannot tell?"

---

_Assumptions encoded above (veto any):_ current .NET LTS at project start; OCI/Docker as the container standard; S3-compatible abstraction for media even on Azure (via compatible layer or storage abstraction); GDPR-grade privacy posture even if initial market is US; WCAG 2.1 AA as accessibility bar; client-side geofencing as the default verification mechanism; license documents retained only until verification completes plus a short audit window; strictest-applicable-rule default for age gating.
