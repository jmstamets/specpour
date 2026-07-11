# Implementation Plan: SpecPour V1

**Branch**: `main` (repo initialized at T001; V1 implementation proceeds directly on trunk — the `001-specpour-v1` name lives on as the spec directory, not a git branch) | **Date**: 2026-07-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-specpour-v1/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Build SpecPour V1, the craft-cocktail platform: a curated recipe/ingredient/equipment/glossary
reference with consumer-scale identity, personal and venue bar libraries, community
publish/copy/rate, inventory-driven makeability, dilution-aware scaling/batching/
costing, shopping intelligence, prep management, collections/menus/print, gracefully
degrading AI features, bar mode, and tiered offline profiles. Technical approach: a
.NET 10 modular monolith (clean/hexagonal, module-owned PostgreSQL schemas, outbox-
dispatched domain events, every external integration behind a port/adapter) exposing a
contract-first `/api/v1` OpenAPI surface consumed by a single Flutter codebase
(Android/iOS/web) with a Drift-backed offline sync layer. Full decisions in
[research.md](research.md).

## Technical Context

**Language/Version**: Backend C# / .NET 10 (current LTS); Frontend Dart / Flutter (stable channel)

**Primary Dependencies**: ASP.NET Core Minimal APIs, EF Core (per-module DbContexts), OpenIddict + ASP.NET Core Identity, OpenTelemetry + Serilog, Reqnroll + Testcontainers (ATDD), openapi-generator (`dart-dio` client), Riverpod + go_router + Drift (client)

**Storage**: PostgreSQL 17 + PostGIS (module-owned schemas, forward-only migrations); S3-compatible object storage for all binary media (MinIO locally); client-side SQLite via Drift for offline

**Testing**: Reqnroll acceptance (Gherkin, real PostgreSQL via Testcontainers), xUnit unit/integration, OpenAPI contract tests, `flutter_test` + `integration_test` — all four suites are CI merge gates

**Target Platform**: Android, iOS, and web as first-class citizens (single Flutter codebase); backend as OCI containers, locally via Docker Compose, cloud-agnostic (Azure expected later, only behind seams)

**Project Type**: Mobile/web app + API (modular-monolith web service backend, cross-platform client)

**Performance Goals**: 95% of searches < 1 s (SC-002); SC-012 ratified thresholds — 10,000 concurrent sessions sustained 30 min at ~80/15/5 read/search/write mix, p95 ≤ 300 ms reads / ≤ 500 ms search / ≤ 600 ms writes, error rate < 0.1%, no degradation trend (AI endpoints excluded, measured separately)

**Constraints**: Offline-capable per user-configured profile with synced-content search/makeability (FR-052/FR-053a); merge-or-prompt conflict resolution for user-authored content; AI features individually toggleable with deterministic fallback (SC-007); stateless service processes; no vendor SDK in domain/application code

**Scale/Scope**: 16 user stories, 79 functional requirements (numbered + lettered), 19 backend modules (18 module-owned schemas — Search owns no schema, its indexes live in owning-module schemas — plus outbox/sync tables), launch content = canonical repertoire + ~300-term glossary (SC-013)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Verified against `.specify/memory/constitution.md` (v1.4.0). **Initial check: PASS. Post-design re-check: PASS** (no violations; no Complexity Tracking entries needed — the web-only staff surface is an exception the constitution's platform-parity rule permits when justified and documented, which spec FR-066 does).

- [x] **I. Test-First (ATDD)**: PASS — spec provides Given/When/Then acceptance scenarios per story; Reqnroll + Testcontainers acceptance suite is the primary gate; CI requires acceptance, unit, integration, and contract suites green (research R4; quickstart test-gate order).
- [x] **II. Contract-First API**: PASS — hand-authored OpenAPI 3.1 under `/api/v1` reviewed before implementation; Dart SDK generated in CI, hand-editing prohibited; contract tests validate the running API; breaking changes → `/api/v2` (R5, contracts/api-v1-surface.md).
- [x] **III. Modular Monolith & Clean Architecture**: PASS — 19 modules (18 module-owned schemas) with Domain/Application/Infrastructure/Contracts projects, ID-only cross-module references, outbox-dispatched domain events, no cross-module transactions; every external integration behind a port/adapter with per-port contract tests (LLM/vision, object storage, email channel — push delivery deferred to Phase 2 per FR-040a — GeoIP, external identity providers); no vendor SDK in domain/application code (R2, R6, R10–R13).
- [x] **IV. Offline-First Client**: PASS — Drift local store, tiered per-device profiles + per-account pins, versioned sync protocol with change-log pull and merge-or-prompt conflict flow, migratable local schema (R9).
- [x] **V. AI Abstraction**: PASS — feature-level AI ports over swappable provider adapters; versioned prompt registry (prompt ↔ model ↔ provider ↔ eval results); per-feature toggles, deterministic discovery fallback, `aiGenerated` labeling in contracts; AI module loosest-coupled as first extraction candidate (R10).
- [x] **VI. Tiers & Roles (three axes)**: PASS — capability/entitlement map in configuration with Guest pseudo-tier floor; (user, role, scope) grants, platform scope in V1; stable tier identifiers with localizable display names; SC-011 verified by quickstart scenario 9 (R7).
- [x] **VII. i18n**: PASS — all client strings keyed via ARB from first commit; locale-aware formatting; single measurements conversion service owns unit preference (R14, R17).
- [x] **VIII. Long-Horizon Rule**: PASS — identity as isolated consumer-scale module (R6); immutable rating events with recomputable projections (R15); search behind `ISearchPort` with PostgreSQL FTS adapter (R8); PostGIS enabled in base migration with venue coordinates stored unused (R3, data-model venues).
- [x] **IX. Domain Language**: PASS — ubiquitous language follows professional craft-cocktail terminology; glossary module is the internal authority; taxonomy decisions documented in curator-managed reference data (data-model catalog/glossary).
- [x] **X. Multi-Sided Boundaries**: PASS — constituency concerns modularized; each shared concept (recipes→catalog, ingredients→ingredients, venues→venues) owned by exactly one module; V1 has no beverage-product or establishment-content surface, and venue identity is already separate from any future content module.
- [x] **XI. Communications**: PASS — thin notifications module (inbox default; email opt-in channel carrying identity transactional mail; push delivery deferred to Phase 2 per FR-040a, channel-preference model only in V1), typed events, auditable; nothing ad hoc per feature (R12, FR-040a).
- [x] **XII. Geolocation Privacy**: PASS — V1 uses only coarse IP-based jurisdiction lookup for the age gate through `IGeoIpPort`; no device location, no retention of raw coordinates, guest DOB checked-never-stored (R13).
- [x] **XIII. Regulated-Industry Posture**: PASS — jurisdiction-aware age-affirmation capability with per-surface strictness and strictest-rule default (FR-002a, incl. client gate tasks T144/T145); merchant-of-record hard boundary on shopping (FR-038); the four-part responsible-consumption package from source §20 (FR-067 persistent messaging, FR-068 quantified transparency, FR-069 support resources, FR-070 encyclopedia content — T150/T074/T136; ToS explicitly insufficient alone); anti-gamification guardrail (constitution v1.4.0) satisfied trivially in V1 — no engagement mechanics ship, and the notifications slice sends only prep/account alerts, never consumption prompts; governs Phase 2's engagement layer.
- [x] **XIV. Trust & Content Integrity**: PASS — moderation actions, publication records, and copy provenance are reusable community-module services; rating computation deterministic, versioned (projection_version), recomputable (SC-010); all administrative actions written to a single append-only audit log via an audit port (FR-065/SC-016); platform-scoped roles require mandatory MFA at token issuance and exist only via deployment bootstrap or audited explicit grant (FR-063/FR-064, research R18a).
- [x] **XV. Analytics & Ingestion**: N/A for V1 (no external operational data ingestion); adapter-layer posture preserved for Phase 2 POS work — nothing in V1 precludes it (FR-059/FR-060).
- [x] **Technology & Standards**: PASS — C#/.NET 10 LTS, PostgreSQL, Flutter, S3-compatible media behind abstraction, cloud-agnostic Docker Compose; OTel observability with correlation IDs, health endpoints, structured logging; WCAG 2.1 AA targets incl. bar mode; semver for API/apps/contracts; ADRs for significant decisions (R1, R3, R11, R16, R17); sensitive-PII classification honored for stored DOB — application-layer encryption, identity-module encapsulation with derived-predicate access, log/trace/analytics scrubbing, audited decrypts, zero retention of underage attempts (R6a, FR-002b/c, SC-017).

## Project Structure

### Documentation (this feature)

```text
specs/001-specpour-v1/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
│   └── api-v1-surface.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
backend/
├── src/
│   ├── Api/                          # ASP.NET Core host, module composition root,
│   │                                 # middleware (auth, rate limiting, otel), health
│   ├── BuildingBlocks/               # Outbox/domain-event dispatcher, module contract
│   │                                 # base types, problem+json, UUIDv7 — no domain logic
│   ├── Modules/
│   │   ├── Identity/                 # each module = Domain, Application,
│   │   ├── Authorization/            #   Infrastructure, Contracts projects;
│   │   ├── Catalog/                  #   module-owned schema; ports in Application,
│   │   ├── Ingredients/              #   adapters in Infrastructure
│   │   ├── Equipment/
│   │   ├── Glossary/
│   │   ├── Community/
│   │   ├── Inventory/
│   │   ├── Measurements/
│   │   ├── Shopping/
│   │   ├── Prep/
│   │   ├── Collections/
│   │   ├── TastingLog/
│   │   ├── Search/                   # ISearchPort + PostgreSQL FTS adapter
│   │   ├── Media/                    # IObjectStoragePort + S3-compatible adapter
│   │   ├── Ai/                       # feature ports, provider adapters, prompt registry
│   │   ├── Notifications/            # inbox + email channel adapter (thin slice;
│   │   │                             # push delivery deferred to Phase 2, FR-040a)
│   │   ├── Compliance/               # age-gate config, jurisdiction rules, IGeoIpPort
│   │   └── Venues/
│   └── Tools/
│       ├── MigrationRunner/          # forward-only, per-module schema migrations
│       └── Seeder/                   # curated launch content + convention tables
├── tests/
│   ├── Acceptance/                   # Reqnroll features per user story (US1–US16)
│   ├── Contract/                     # OpenAPI conformance vs running API + per-port suites
│   ├── Integration/                  # module + Testcontainers PostgreSQL
│   └── Unit/
└── contracts/
    └── openapi/                      # authored OpenAPI 3.1 (root + per-module paths)

frontend/
├── app/                              # Flutter application
│   ├── lib/
│   │   ├── features/                 # feature-first: discover, identity, library,
│   │   │                             # inventory, measure, community, glossary,
│   │   │                             # equipment, shopping, prep, collections, ai,
│   │   │                             # tasting_log, bar_mode, offline, compliance,
│   │   │                             # admin (web-only build target — FR-066, R18a)
│   │   ├── core/                     # routing, theming (WCAG AA + bar-mode theme),
│   │   │                             # l10n (ARB), entitlement-manifest gate
│   │   └── data/                     # repositories over api_client + Drift offline
│   │                                 # store, sync engine (change-log pull, push
│   │                                 # queue, merge-or-prompt)
│   ├── test/                         # unit + widget
│   └── integration_test/             # client acceptance flows
└── packages/
    └── api_client/                   # GENERATED dart-dio SDK — never hand-edited

docker-compose.yml                    # postgres+postgis, minio, otel-collector, api
```

**Structure Decision**: Web-service + cross-platform-client split (`backend/`,
`frontend/`). The backend is a single deployable modular monolith — one `Api` host
composing 19 modules, each holding its own Domain/Application/Infrastructure/Contracts
projects; 18 own a PostgreSQL schema (Search deliberately owns none — its indexes live
in owning-module schemas, per the T141 ADR) — matching constitution Principle III. The frontend is
one Flutter codebase for all three platforms with the generated `api_client` package
as its only API coupling. Authored OpenAPI lives in `backend/contracts/openapi/` as
the reviewed source of truth feeding both server contract tests and client generation.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations — table intentionally empty.

## Phase 0: Research

Complete — see [research.md](research.md) (R1–R18). No NEEDS CLARIFICATION remained:
the constitution fixes the stack, and three /speckit-clarify sessions resolved all
functional ambiguities in the spec.

## Phase 1: Design & Contracts

Complete — outputs:

- [data-model.md](data-model.md): 18 module schemas, entities with validation rules
  and lifecycle transitions, cross-module event flows, sync change log.
- [contracts/api-v1-surface.md](contracts/api-v1-surface.md): full `/api/v1` REST
  surface by module with auth levels and global conventions; authored OpenAPI
  documents land in `backend/contracts/openapi/` during implementation.
- [quickstart.md](quickstart.md): stack-up commands, CI test-gate order, twelve
  end-to-end validation scenarios tied to user stories and success criteria.
- Agent context: `CLAUDE.md` SPECKIT block updated to reference this plan.

## Phase 2: Task planning approach (executed by /speckit-tasks, not this command)

Tasks will be generated per user story (US1–US16, priority-ordered), each story
beginning with failing-first Reqnroll acceptance tests (mandatory per Principle I),
preceded by Setup and Foundational phases covering: solution scaffolding,
BuildingBlocks (outbox/events), identity + authorization + compliance foundations,
OpenAPI root + client generation pipeline, migration runner + PostGIS base migration,
seeder + convention tables, notifications thin slice, search port, media port, and the
Flutter app shell with offline sync engine.
