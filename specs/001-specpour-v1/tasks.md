---

description: "Task list for SpecPour V1 implementation"
---

# Tasks: SpecPour V1

**Input**: Design documents from `/specs/001-specpour-v1/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/api-v1-surface.md, quickstart.md

**Tests**: MANDATORY per Constitution v1.3.0 Principle I (ATDD). Every user story begins
with Given/When/Then acceptance tests that MUST fail before implementation (red-green).
CI merge gates: acceptance + unit + integration + contract suites green.

**Organization**: Tasks are grouped by user story (US1–US16 from spec.md) so each story
is independently implementable and testable. Backend paths are `backend/…`, client paths
`frontend/…`, per plan.md's structure. Each module follows
`backend/src/Modules/<Module>/{Domain,Application,Infrastructure,Contracts}/`.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US16)

> **Note (post-analysis amendment)**: Tasks T144–T150 were added by the /speckit-analyze
> remediation pass. Task IDs are stable identifiers; **phase placement defines execution
> order**, so amended tasks execute within their listed phase, not by ID sequence.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Repo, solution, toolchain, and pipeline scaffolding

- [X] T001 Initialize git repository, .gitignore, .editorconfig, and root README.md at repo root
- [X] T002 Create .NET solution and project skeletons per plan structure in backend/src/{Api,BuildingBlocks,Modules/*,Tools/{MigrationRunner,Seeder}} and backend/tests/{Acceptance,Contract,Integration,Unit}
- [X] T003 [P] Create docker-compose.yml at repo root: postgres:17-postgis, minio, otel-collector, api service
- [X] T004 [P] Configure C# static analysis and formatting (Directory.Build.props, .editorconfig analyzers, treat-warnings-as-errors) in backend/
- [X] T005 [P] Scaffold Flutter app with feature-first layout in frontend/app/ (lib/{features,core,data}, test/, integration_test/) and enable ARB i18n workflow in frontend/app/lib/core/l10n/
- [X] T006 [P] Configure Dart analysis (analysis_options.yaml) and CI-enforced `dart format` in frontend/app/
- [X] T007 Author OpenAPI 3.1 root document with global conventions (problem+json, cursor pagination, security schemes, no-raw-DOB invariant note) in backend/contracts/openapi/openapi.yaml
- [X] T008 Create Dart client generation pipeline (openapi-generator dart-dio, CI script, hand-edit prohibition check) generating frontend/packages/api_client/ via scripts/generate-client.sh
- [X] T009 Create CI pipeline definition (build, analyzers, all four backend test suites, flutter test suites, client regen drift check, dependency & container scanning) in .github/workflows/ci.yml

**Checkpoint**: Solution builds, compose stack starts, empty test suites run in CI

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Cross-cutting infrastructure every story depends on — no story work before this completes

- [ ] T010 Implement BuildingBlocks: module composition interface (IModule), UUIDv7 generator, problem+json helpers, domain-event envelope in backend/src/BuildingBlocks/
- [ ] T011 Implement outbox-backed domain-event dispatcher (outbox table pattern, transactional write, background dispatcher) in backend/src/BuildingBlocks/Events/
- [ ] T012 Implement MigrationRunner tool (per-module forward-only EF Core migrations, ordered apply) in backend/src/Tools/MigrationRunner/
- [ ] T013 Create base migration: 18 module schemas (identity, authz, catalog, ingredients, equipment, glossary, community, inventory, measurements, shopping, prep, collections, tastinglog, media, notifications, compliance, venues, ai), PostGIS extension, outbox and sync_change tables in backend/src/Tools/MigrationRunner/Migrations/ — Search owns no schema: tsvector/trigram columns live in owning-module schemas, maintained via events (ADR per T141)
- [ ] T014 Compose Api host: module registration, middleware order (correlation ID, auth, anonymous rate limiter, problem+json), /health/live and /health/ready in backend/src/Api/Program.cs
- [ ] T015 [P] Wire OpenTelemetry (traces/metrics/logs) + Serilog structured logging with correlation-ID propagation and sensitive-field scrubbing policy (dateOfBirth-shaped fields) in backend/src/Api/Observability/
- [ ] T016 Implement identity module core: User entity with application-layer AES-GCM encrypted date_of_birth column (R6a), ASP.NET Core Identity stores, module schema DbContext in backend/src/Modules/Identity/
- [ ] T017 Implement OpenIddict token issuance (authorization code + refresh) and auth middleware integration in backend/src/Modules/Identity/Infrastructure/OpenIddict/
- [ ] T018 Implement authorization module: Tier + CapabilityGrant + PlatformRole + RoleGrant entities, capability policy layer, guest pseudo-tier floor, GET /api/v1/me/entitlements in backend/src/Modules/Authorization/
- [ ] T019 Implement append-only audit log (AuditLogEntry, single audit port IAuditWriter, no UPDATE/DELETE grants in migration) in backend/src/Modules/Authorization/Audit/
- [ ] T020 [P] Implement compliance module: SurfaceGateConfig + JurisdictionRule entities, IGeoIpPort + adapter, GET /api/v1/compliance/age-gate in backend/src/Modules/Compliance/
- [ ] T021 [P] Implement media module: IObjectStoragePort + S3-compatible adapter (MinIO), MediaAttachment entity, pre-signed upload flow in backend/src/Modules/Media/
- [ ] T022 [P] Implement search module: ISearchPort contract + PostgreSQL FTS adapter (tsvector maintenance, websearch_to_tsquery, trigram), port contract-test suite in backend/src/Modules/Search/
- [ ] T023 [P] Implement notifications thin slice: InboxMessage + ChannelPreference entities, typed notification events consumer, IEmailChannelAdapter port with per-port contract-test suite (real adapter lands in T146; push delivery deferred to Phase 2 per FR-040a), GET /api/v1/inbox in backend/src/Modules/Notifications/
- [ ] T024 [P] Implement measurements module: ConventionTable versioned reference data, canonical-ml conversion service (oz/ml/cl + dash/barspoon), method dilution constants in backend/src/Modules/Measurements/
- [ ] T025 Implement Seeder tool: convention tables, curated launch-content ingestion pipeline (recipes/ingredients/equipment/glossary from content files), first-Super-Admin bootstrap from environment config writing inaugural audit entry in backend/src/Tools/Seeder/
- [ ] T026 Set up Reqnroll + Testcontainers acceptance harness (composed host, real PostgreSQL, clock test hook) in backend/tests/Acceptance/Support/
- [ ] T027 [P] Set up OpenAPI contract-test harness validating running API against backend/contracts/openapi/ in backend/tests/Contract/Support/
- [ ] T028 Scaffold Flutter core: go_router navigation, Riverpod DI, WCAG AA theming + bar-mode theme tokens, entitlement-manifest gate, api_client wiring in frontend/app/lib/core/
- [ ] T029 Set up Drift local store skeleton (schema v1, migrator, FTS5 enablement) and repository layer pattern in frontend/app/lib/data/
- [ ] T144 [P] Flutter compliance/age-gate feature: DOB-entry UI (form entry, not checkbox); fetch jurisdiction threshold from /compliance/age-gate; strictest-rule fallback when the jurisdiction call fails or the device is offline; persist affirmed flag locally only, in frontend/app/lib/features/compliance/
- [ ] T145 [P] Failing-first age-gate integration tests: (1) intercept all network traffic during the gate flow and assert the DOB value appears in no request payload, (2) assert nothing DOB-derived exists outside local storage, (3) offline/lookup-failure → strictest-rule local default, in frontend/app/integration_test/age_gate_test.dart

**Checkpoint**: Foundation ready — user story phases can begin

---

## Phase 3: User Story 1 — Discover and Follow Curated Recipes (P1) 🎯 MVP

**Goal**: Guests and users search/browse curated content and view complete recipes with derived data

**Independent Test**: Seed content; search "Mai Tai" anonymously; verify all recipe fields, ABV/standard drinks, allergen roll-up, concept-page variant navigation, content faceted filters, guest gating prompts, responsible-consumption messaging. Note: US1 scenario 5's `rating` and `makeable-from-inventory` facets are staged — their acceptance tests are tagged to run at the US6 (T149) and US4 (T148) checkpoints where the backing projections exist

- [ ] T030 [P] [US1] Acceptance tests (failing first) for US1 scenarios 1–7 in backend/tests/Acceptance/Features/US01_DiscoverRecipes.feature
- [ ] T031 [P] [US1] Flutter integration test for guest browse/search/recipe view in frontend/app/integration_test/us01_discover_test.dart
- [ ] T032 [P] [US1] Catalog module: Recipe, RecipeIngredientLine, RecipeRelation, ConceptPage, ConceptVariantLink, Family/Category entities + migration in backend/src/Modules/Catalog/Domain/
- [ ] T033 [P] [US1] Ingredients module: Ingredient hierarchy, categories, allergen attributes, SubstitutionRule entities + migration in backend/src/Modules/Ingredients/Domain/
- [ ] T034 [P] [US1] Equipment module: Equipment entity + migration in backend/src/Modules/Equipment/Domain/
- [ ] T035 [P] [US1] Glossary module: GlossaryTerm (unique term, numbered definitions), Article, LinkOverride entities + migration in backend/src/Modules/Glossary/Domain/
- [ ] T036 [US1] Derived-data services: ABV + standard-drinks calculator (method dilution conventions) and allergen roll-up in backend/src/Modules/Catalog/Application/DerivedData/
- [ ] T037 [US1] Read endpoints + OpenAPI paths: GET /recipes (content facets: family, category, tags, flavor profile, glassware, ice, equipment, allergen-exclude, ABV range, source — rating facet lands in T149, makeable facet in T148), GET /recipes/{id}, GET /concepts, GET /concepts/{id}, GET /ingredients, GET /equipment, GET /glossary/* in backend/src/Modules/*/Endpoints/ and backend/contracts/openapi/paths/
- [ ] T038 [US1] Search endpoint GET /api/v1/search over ISearchPort with content-facet filtering composition (facet set completed by T148/T149) in backend/src/Modules/Search/Endpoints/
- [ ] T039 [US1] Glossary auto-linking service (first occurrence per page, longest-match, curator overrides honored, return navigation anchors) in backend/src/Modules/Glossary/Application/AutoLink/
- [ ] T040 [US1] Curated seed content pack: canonical repertoire subset for test/dev (incl. Mai Tai, Daiquiri concept + variants, egg-white flip) in backend/src/Tools/Seeder/Content/
- [ ] T041 [US1] Flutter discover feature: home/browse/search screens with facet UI in frontend/app/lib/features/discover/
- [ ] T042 [US1] Flutter recipe detail + concept page screens (all content fields, derived data, allergen prominence, glossary links with return navigation) in frontend/app/lib/features/discover/recipe_detail/
- [ ] T043 [US1] Guest gating UX: account-gated action prompt with post-signup intent completion hook; anonymous rate limiting verified in frontend/app/lib/core/guest_gate/
- [ ] T044 [US1] SEO HTML projection endpoints GET /pages/recipes/{slug} etc. for public content in backend/src/Api/Seo/
- [ ] T150 [US1] Responsible-consumption package (FR-067/FR-068/FR-069, US1 scenario 8): jurisdiction-configurable message text + placement served by the compliance module (GET /compliance/messaging, GET /compliance/support-resources); persistent messaging on recipe pages, batch/scaling outputs, and app footer/about; support-resource links reachable from the messaging and settings/about; per-serving ABV/standard-drinks display designated to Principle XIII; extend US1 acceptance feature + widget coverage, in backend/src/Modules/Compliance/Application/Messaging/ and frontend/app/lib/core/responsible_use/

**Checkpoint**: MVP — guest discovery fully functional and demoable

---

## Phase 4: User Story 2 — Create an Account and Manage Identity (P1)

**Goal**: Consumer-scale registration, sign-in, MFA, recovery, sessions, lifecycle, DOB-as-sensitive-PII

**Independent Test**: Register (of-age + underage paths), social sign-in, MFA, recovery, session revoke, export, delete; verify DOB ciphertext, predicate-only exposure, audited decrypt

- [ ] T045 [P] [US2] Acceptance tests (failing first) for US2 scenarios 1–8 in backend/tests/Acceptance/Features/US02_Identity.feature
- [ ] T146 [US2] Real email channel adapter behind IEmailChannelAdapter: dev SMTP mail-catcher (docker-compose service) for local/CI, production provider selected by configuration per the adapter rule, verified by the existing per-port contract tests, in backend/src/Modules/Notifications/Infrastructure/Email/ and docker-compose.yml
- [ ] T046 [P] [US2] Flutter integration test for register/sign-in/MFA/sessions/lifecycle in frontend/app/integration_test/us02_identity_test.dart
- [ ] T047 [US2] Registration with DOB capture, jurisdiction-aware underage rejection with zero persistence (FR-002c), client-side retry flagging contract in backend/src/Modules/Identity/Application/Registration/
- [ ] T048 [US2] Derived age predicates internal contract IsOfLegalDrinkingAge(userId, jurisdiction) + age-band projection; audited decrypt on every raw access in backend/src/Modules/Identity/Contracts/
- [ ] T049 [P] [US2] External OIDC social sign-in adapters (Google, Apple, Microsoft) behind IExternalIdentityProviderPort in backend/src/Modules/Identity/Infrastructure/ExternalProviders/
- [ ] T050 [P] [US2] TOTP MFA enrollment/disable + secure recovery flow (email via notifications module) in backend/src/Modules/Identity/Application/{Mfa,Recovery}/
- [ ] T051 [US2] Session/device management: SessionDevice entities, GET/DELETE /me/sessions, refresh-token family revocation in backend/src/Modules/Identity/Application/Sessions/
- [ ] T052 [US2] Account lifecycle: deactivate/reactivate with operator-configurable grace period (default 12 months), expiry warning notification event, scheduled deletion job in backend/src/Modules/Identity/Application/Lifecycle/
- [ ] T053 [US2] Data export (sole raw-DOB surface) and deletion with public-attribution anonymization + rating-event de-identification events in backend/src/Modules/Identity/Application/Export/
- [ ] T054 [US2] Identity endpoints + OpenAPI paths (/auth/*, /me/*) in backend/src/Modules/Identity/Endpoints/ and backend/contracts/openapi/paths/
- [ ] T055 [US2] Flutter identity feature: registration (with DOB + underage rejection UX), sign-in, MFA, recovery, session list, preferences, lifecycle screens in frontend/app/lib/features/identity/

**Checkpoint**: Both P1 stories complete — guest MVP plus full accounts

---

## Phase 5: User Story 3 — Author a Personal Library (P2)

**Goal**: Private recipes/ingredients incl. house-made; venues with bar libraries

**Independent Test**: Create private recipe + house-made ingredient, use in recipe, verify privacy; create venues and bar-library scoping with switcher

- [ ] T056 [P] [US3] Acceptance tests (failing first) for US3 scenarios 1–4 in backend/tests/Acceptance/Features/US03_AuthorLibrary.feature
- [ ] T057 [P] [US3] Flutter integration test for authoring flows in frontend/app/integration_test/us03_author_test.dart
- [ ] T058 [US3] Author CRUD services + endpoints for recipes (POST/PUT/DELETE /recipes) with library scoping (personal|bar) and privacy enforcement in backend/src/Modules/Catalog/Application/Authoring/
- [ ] T059 [US3] Author CRUD for private ingredients incl. house-made extension (defining recipe, yield, shelf life, storage; circular-reference rejection) in backend/src/Modules/Ingredients/Application/Authoring/
- [ ] T060 [P] [US3] Author CRUD for private equipment (same privacy model) in backend/src/Modules/Equipment/Application/Authoring/
- [ ] T061 [P] [US3] Venues module: Venue entity (PostGIS point, external refs), multi-venue ownership, CRUD /venues + OpenAPI paths in backend/src/Modules/Venues/
- [ ] T062 [US3] Media attachment upload flow for author content (pre-signed URLs, gallery ordering) in backend/src/Modules/Media/Application/Attach/
- [ ] T063 [US3] Flutter library feature: recipe editor (ingredient lines with hierarchy picker, roles, scaling rules), house-made ingredient editor, venue switcher + bar library in frontend/app/lib/features/library/

**Checkpoint**: Authoring loop complete and private

---

## Phase 6: User Story 4 — Track Inventory and "What Can I Make?" (P2)

**Goal**: Inventory at any hierarchy level via photo/barcode/manual; makeability + near-misses

**Independent Test**: All three entry paths; hierarchy satisfaction (Beefeater ⊨ London dry gin); near-miss with substitutions + suitability caveats

- [ ] T064 [P] [US4] Acceptance tests (failing first) for US4 scenarios 1–4 plus the empty-inventory edge case (zero-ingredient recipes only; near-miss thresholds don't list everything) in backend/tests/Acceptance/Features/US04_Inventory.feature
- [ ] T065 [P] [US4] Flutter integration test for inventory + makeability in frontend/app/integration_test/us04_inventory_test.dart
- [ ] T066 [US4] Inventory module: InventoryItem entity + CRUD endpoints /inventory/items with product/class level and optional quantity in backend/src/Modules/Inventory/
- [ ] T067 [US4] Makeability engine: hierarchy + curated/implied substitution resolution, near-miss detection with suitability-caveat surfacing, GET /inventory/makeable in backend/src/Modules/Inventory/Application/Makeability/
- [ ] T068 [P] [US4] AI module foundation: ILlmProviderAdapter/IVisionProviderAdapter ports, provider config, prompt registry persisted in the `ai` schema (version ↔ model ↔ provider ↔ eval results as relational data; prompt template text lives in the repo for code review), per-feature toggles + labeling in backend/src/Modules/Ai/
- [ ] T069 [US4] Bottle recognition: POST /inventory/recognize via ILabelRecognitionPort with pre-filled-manual-form degradation; on-device barcode scan path in backend/src/Modules/Inventory/Application/Recognition/ and frontend/app/lib/features/inventory/scan/
- [ ] T070 [US4] Flutter inventory feature: item list, add flows (photo/barcode/manual), makeable + near-miss views in frontend/app/lib/features/inventory/
- [ ] T147 [P] [US4] Recognition evaluation infrastructure (SC-008; constitutionally implied by prompt-version ↔ eval-results binding): curated labeled bottle-photo dataset including hard cases (glare, partial labels, non-English labels, craft bottles), accuracy harness runnable per prompt-version/provider pair, results recorded against the prompt registry, in backend/tests/Evaluation/Recognition/
- [ ] T148 [US4] Complete the makeable-from-inventory search facet and enable the deferred US1-scenario-5 acceptance assertions (tagged to this checkpoint) in backend/src/Modules/Search/Application/Facets/

**Checkpoint**: Daily-engagement killer feature live

---

## Phase 7: User Story 5 — Scale, Batch, and Cost Recipes (P2)

**Goal**: Unit conversion, per-line scaling rules, dilution-aware batching, pour costing

**Independent Test**: Scale citrus+egg recipe to 20 (batched vs at-service separation), dilution math matches convention table exactly, pour cost with house-made roll-up

- [ ] T071 [P] [US5] Acceptance tests (failing first) for US5 scenarios 1–4 incl. SC-005 exact-convention assertions in backend/tests/Acceptance/Features/US05_MeasureBatchCost.feature
- [ ] T072 [P] [US5] Flutter integration test for scaling/batching/costing in frontend/app/integration_test/us05_measure_test.dart
- [ ] T073 [US5] Scaling service honoring per-line rules (linear/stepwise/omit/add-fresh) with batched vs at-service separation, GET /recipes/{id}/scale in backend/src/Modules/Measurements/Application/Scaling/
- [ ] T074 [US5] Batch calculator (pre-diluted vs not, target dilution/ABV, keg/bottle/carbonation guidance, container yields, total standard drinks per batch and per container plus per-serving strength using jurisdiction-aware conventions — FR-034/FR-068), BatchResult persistence, POST /recipes/{id}/batch in backend/src/Modules/Measurements/Application/Batching/
- [ ] T075 [US5] Costing service: IngredientPrice storage, per-drink cost, breakdown, pour-cost %, suggested price, house-made recursive roll-up, GET /recipes/{id}/costing + PUT /me/ingredient-prices/{id} in backend/src/Modules/Measurements/Application/Costing/
- [ ] T076 [US5] Flutter measure feature: scale/batch/cost screens with unit-preference rendering in frontend/app/lib/features/measure/

**Checkpoint**: Professional measurement intelligence complete

---

## Phase 8: User Story 16 — Administer the Platform (Staff) (P2)

**Goal**: Role catalog as config, staff consoles, bootstrap/break-glass, mandatory MFA, audit everywhere

**Independent Test**: Bootstrap Super Admin, approval-gated Curator grant, exercise every console, verify audit entries + MFA enforcement + web-only routes

- [ ] T077 [P] [US16] Acceptance tests (failing first) for US16 scenarios 1–6 in backend/tests/Acceptance/Features/US16_PlatformAdmin.feature
- [ ] T078 [P] [US16] Flutter (web) integration test for admin consoles in frontend/app/integration_test/us16_admin_test.dart
- [ ] T079 [US16] Role catalog config endpoints GET/PUT /admin/roles + platform-scope grant flow with Super Admin approval step in backend/src/Modules/Authorization/Application/Admin/
- [ ] T080 [US16] Mandatory-MFA enforcement at token issuance for platform-role holders in backend/src/Modules/Identity/Application/StaffMfa/
- [ ] T081 [P] [US16] Curation console endpoints: /admin/{recipes,ingredients,equipment,glossary,concepts,taxonomy,substitutions,categories,link-overrides} in backend/src/Modules/*/Endpoints/Admin/
- [ ] T082 [P] [US16] Moderation queue: GET /moderation/queue, POST /moderation/actions (unpublish/flag) writing ModerationAction + audit in backend/src/Modules/Community/Application/Moderation/
- [ ] T083 [US16] Account administration: search, suspend/reinstate, fulfill-export/deletion, trigger-reset endpoints (audited; staff see verified age status, never DOB) in backend/src/Modules/Identity/Application/Admin/
- [ ] T084 [US16] Audit-log review endpoint GET /admin/audit-log with filters in backend/src/Modules/Authorization/Endpoints/Admin/
- [ ] T085 [US16] Break-glass runbook (deployment-level re-seed with dual control) in docs/runbooks/break-glass.md
- [ ] T086 [US16] Flutter admin feature area (web-only routes excluded from mobile builds): tier config, role grants, curation, moderation, accounts, audit views in frontend/app/lib/features/admin/

**Checkpoint**: Operator side complete; content workstream unblocked

---

## Phase 9: User Story 6 — Publish, Copy, and Rate Community Recipes (P3)

**Goal**: Publish with consent cascade + copies-survive warning, uniform copy-with-provenance, latest-per-user ratings

**Independent Test**: Publish (cascade + warning), copy from second account with attribution, rate/re-rate, recompute projection equals display, owner + curator unpublish

- [ ] T087 [P] [US6] Acceptance tests (failing first) for US6 scenarios 1–5 + SC-010 recompute equality in backend/tests/Acceptance/Features/US06_Community.feature
- [ ] T088 [P] [US6] Flutter integration test for publish/copy/rate in frontend/app/integration_test/us06_community_test.dart
- [ ] T089 [US6] Publish flow: FR-008a consent-cascade manifest (private ingredients + equipment), FR-008b first-publish copies-survive warning ack, PublicationRecord, POST /recipes/{id}/publish|unpublish in backend/src/Modules/Community/Application/Publishing/
- [ ] T090 [US6] Copy-with-provenance (core + public sources, snapshot semantics, anonymization on source deletion), POST /recipes/{id}/copy in backend/src/Modules/Community/Application/Copying/
- [ ] T091 [US6] RatingEvent append-only store + latest-per-user RatingProjection via outbox, recompute job, POST /ratings + GET /ratings/mine in backend/src/Modules/Community/Application/Ratings/
- [ ] T092 [US6] Concept-page variant attachment (published-only, proposed→approved moderation state), POST /concepts/{id}/variants in backend/src/Modules/Catalog/Application/Variants/
- [ ] T093 [US6] Flutter community feature: publish flow with cascade/warning dialogs, public browse, copy, rate ("your rating" editable) in frontend/app/lib/features/community/
- [ ] T149 [US6] Complete the rating search facet over RatingProjection and enable the deferred US1-scenario-5 acceptance assertions (tagged to this checkpoint) in backend/src/Modules/Search/Application/Facets/

**Checkpoint**: Community loop live with rating integrity

---

## Phase 10: User Story 7 — Consult the Glossary and Encyclopedia (P3)

**Goal**: Reader-facing glossary/article experience with auto-links and cross-discovery

**Independent Test**: Multi-definition term renders once; first-occurrence auto-link + exact return; curator suppress/force; tag cross-discovery

- [ ] T094 [P] [US7] Acceptance tests (failing first) for US7 scenarios 1–4 in backend/tests/Acceptance/Features/US07_Glossary.feature
- [ ] T095 [P] [US7] Flutter integration test for glossary reading + return navigation in frontend/app/integration_test/us07_glossary_test.dart
- [ ] T096 [US7] Auto-link resolution endpoint GET /glossary/autolink with longest-match and override application in backend/src/Modules/Glossary/Endpoints/
- [ ] T097 [US7] Tag cross-discovery queries ("recipes using X") in backend/src/Modules/Glossary/Application/CrossDiscovery/
- [ ] T098 [US7] Flutter glossary feature: term/article readers, in-text link rendering with return-to-position, related-content rails in frontend/app/lib/features/glossary/

**Checkpoint**: Knowledge base fully navigable

---

## Phase 11: User Story 8 — Reference and Manage Equipment (P3)

**Goal**: Equipment reference with bidirectional recipe/article links + user additions

**Independent Test**: Curated entry displays all fields + links both directions; user-added entry stays private

- [ ] T099 [P] [US8] Acceptance tests (failing first) for US8 scenarios 1–2 in backend/tests/Acceptance/Features/US08_Equipment.feature
- [ ] T100 [US8] Bidirectional link queries (equipment ↔ requiring recipes ↔ articles) in backend/src/Modules/Equipment/Application/Links/
- [ ] T101 [US8] Flutter equipment feature: browse/detail with link navigation, user-entry editor in frontend/app/lib/features/equipment/

**Checkpoint**: Reference triad complete

---

## Phase 12: User Story 9 — Generate Shopping Intelligence (P3)

**Goal**: Lists from recipes/menu+guests/prep; leverage-ranked unlock analysis; export/share

**Independent Test**: Three source paths produce correct quantities; unlock ranking honors hierarchy+substitutions; export leaves the app

- [ ] T102 [P] [US9] Acceptance tests (failing first) for US9 scenarios 1–3 in backend/tests/Acceptance/Features/US09_Shopping.feature
- [ ] T103 [US9] Shopping module: ShoppingList entity and POST /shopping-lists with the recipe-sourced path fully working in this phase; menu- and prep-sourced generation are implemented against the Collections and Prep module contracts here but completed and verified at the Phase 14 and Phase 13 checkpoints respectively (where Menu/PrepList entities exist), in backend/src/Modules/Shopping/
- [ ] T104 [US9] Unlock analysis (recipes-unlocked-per-purchase ranking), GET /shopping/unlock-analysis in backend/src/Modules/Shopping/Application/Unlock/
- [ ] T105 [US9] Export/share (text + document formats via platform share sheet), POST /shopping-lists/{id}/export in backend/src/Modules/Shopping/Application/Export/ and frontend/app/lib/features/shopping/
- [ ] T106 [US9] Flutter shopping feature: list builder, unlock recommendations view in frontend/app/lib/features/shopping/

**Checkpoint**: Purchase loop closed (merchant-of-record boundary respected)

---

## Phase 13: User Story 10 — Manage Prep and Shelf Life (Pro) (P3)

**Goal**: Prep lists with yield math, made-on/shelf-life tracking, expiry notifications, makeability integration

**Independent Test**: Batch + house-made → prep list → complete → clock-advance → inbox warning, drops from makeability

- [ ] T107 [P] [US10] Acceptance tests (failing first) for US10 scenarios 1–3 in backend/tests/Acceptance/Features/US10_Prep.feature
- [ ] T108 [US10] Prep module: PrepList/PrepItem entities (state machine planned→completed→expired, composition/cost snapshot at completion), CRUD + complete endpoints in backend/src/Modules/Prep/
- [ ] T109 [US10] Expiry detection job → PrepExpired/PrepExpiring events → notifications inbox (+ email if opted in; push deferred to Phase 2 per FR-040a) and inventory availability removal in backend/src/Modules/Prep/Application/Expiry/
- [ ] T110 [US10] Flutter prep feature: prep lists, completion flow with made-on date, expiring view in frontend/app/lib/features/prep/

**Checkpoint**: Pro prep workflow live end-to-end

---

## Phase 14: User Story 11 — Collections, Menus, and Print/Export (P3)

**Goal**: Collections; costing-aware menus; artifact-appropriate print/export

**Independent Test**: Collection → priced menu; print/export each artifact type via native pipeline

- [ ] T111 [P] [US11] Acceptance tests (failing first) for US11 scenarios 1–2 in backend/tests/Acceptance/Features/US11_CollectionsMenus.feature
- [ ] T112 [US11] Collections module: Collection entity (+ per-account offline pin flag), Menu promotion with per-item price/description/order, CRUD endpoints in backend/src/Modules/Collections/
- [ ] T113 [US11] Print/export layout service: recipe card (single/batch), spec sheet, styled menu, prep list, shopping list document rendering, GET /print/{artifact}/{id} in backend/src/Modules/Collections/Application/Print/
- [ ] T114 [US11] Flutter collections feature: collection manager, menu editor with pour-cost guidance, native print/share integration in frontend/app/lib/features/collections/

**Checkpoint**: Organization + output workflows complete

---

## Phase 15: User Story 12 — AI-Assisted Features (P4)

**Goal**: Chat, insight blocks, authoring assist, discovery — all toggleable, labeled, gracefully degrading

**Independent Test**: Exercise all with AI on; disable globally/per-feature → zero broken surfaces, deterministic discovery fallback

- [ ] T115 [P] [US12] Acceptance tests (failing first) for US12 scenarios 1–4 + SC-007 all-off sweep in backend/tests/Acceptance/Features/US12_Ai.feature
- [ ] T116 [US12] Chat assistant grounded in platform content, POST /ai/chat with aiGenerated labeling in backend/src/Modules/Ai/Application/Chat/
- [ ] T117 [P] [US12] Contextual insight blocks (page-type adaptive incl. concept variant comparison), GET /ai/insights in backend/src/Modules/Ai/Application/Insights/
- [ ] T118 [P] [US12] Authoring assist with mandatory human-review-before-publish workflow, POST /ai/authoring-assist in backend/src/Modules/Ai/Application/AuthoringAssist/
- [ ] T119 [US12] Discovery: deterministic similarity scorer (flavor/family/shared-ingredient/tasting-log) as fallback + AI-enhanced path, GET /discovery/similar in backend/src/Modules/Ai/Application/Discovery/
- [ ] T120 [US12] Toggle plumbing: /me/ai-toggles + /admin/ai-toggles, outage degradation (circuit breaker → fallback/absence) in backend/src/Modules/Ai/Application/Toggles/
- [ ] T121 [US12] Flutter AI surfaces: chat UI, insight blocks, discovery rail, per-feature toggle settings, clean-absence rendering in frontend/app/lib/features/ai/

**Checkpoint**: AI enriches everything, breaks nothing

---

## Phase 16: User Story 13 — Personal Tasting Log (P4)

**Goal**: Private made-it history feeding discovery, independent of public ratings

**Independent Test**: Log entry privacy; public rating and log rating never interact

- [ ] T122 [P] [US13] Acceptance tests (failing first) for US13 scenarios 1–2 in backend/tests/Acceptance/Features/US13_TastingLog.feature
- [ ] T123 [US13] TastingLog module: TastingLogEntry CRUD endpoints /tasting-log/entries, discovery feed hook in backend/src/Modules/TastingLog/
- [ ] T124 [US13] Flutter tasting log feature: log entry UX from recipe page, history view in frontend/app/lib/features/tasting_log/

**Checkpoint**: Personal journal live

---

## Phase 17: User Story 14 — Bar Mode (P4)

**Goal**: Hands-free high-contrast step-through for recipes and prep lists

**Independent Test**: Step through via touch + voice; screen stays awake; works for prep lists

- [ ] T125 [P] [US14] Flutter integration test (failing first) for bar-mode operation in frontend/app/integration_test/us14_bar_mode_test.dart
- [ ] T126 [US14] Bar-mode UI: one-step-at-a-time view, bar-mode theme, oversized targets, wakelock in frontend/app/lib/features/bar_mode/
- [ ] T127 [US14] Voice advance ("next") via speech-to-text behind accessibility service seam in frontend/app/lib/features/bar_mode/voice/

**Checkpoint**: Wet-hands operation verified on devices

---

## Phase 18: User Story 15 — Configure Offline Access (P4)

**Goal**: Per-device profiles, per-account pins, synced-content intelligence, merge-or-prompt conflicts

**Independent Test**: Each profile tier offline; pinned collections; offline search/makeability; two-device conflict → merge-or-prompt

- [ ] T128 [P] [US15] Acceptance tests (failing first) for US15 scenarios 1–4 (sync API side) in backend/tests/Acceptance/Features/US15_OfflineSync.feature
- [ ] T129 [P] [US15] Flutter integration test for offline profiles + conflict flow in frontend/app/integration_test/us15_offline_test.dart
- [ ] T130 [US15] Sync protocol endpoints: POST /sync/handshake (versioned), GET /sync/changes (cursor, profile-tier + pin filtered), POST /sync/push with conflict responses in backend/src/Api/Sync/
- [ ] T131 [US15] SyncChange log population from ContentChanged events across modules in backend/src/BuildingBlocks/Sync/
- [ ] T132 [US15] Client sync engine: change-log pull, push queue, per-device profile tiers, per-account pinned collections, storage-usage reporting, budget-exceeded handling in frontend/app/lib/data/sync/
- [ ] T133 [US15] Merge-or-prompt conflict resolution UI for user-authored content in frontend/app/lib/features/offline/conflicts/
- [ ] T134 [US15] Offline intelligence: local FTS5 search + local makeability over synced data; online-only feature indicators in frontend/app/lib/data/offline_query/
- [ ] T135 [US15] Offline settings UX: profile picker with storage reporting, pin management in frontend/app/lib/features/offline/

**Checkpoint**: All 16 stories independently functional

---

## Phase 19: Polish & Cross-Cutting Concerns

- [ ] T136 [P] Full launch-content seeding: IBA repertoire + classics, standard equipment, ≥300-term glossary, and the FR-070 responsible-service/responsible-consumption encyclopedia articles (service limits, recognizing intoxication, host duties — auto-linked like all glossary content) (SC-013 content pipeline) in backend/src/Tools/Seeder/Content/
- [ ] T137 [P] Performance validation against SC-012's ratified thresholds (10k sessions × 30 min at 80/15/5 read/search/write mix; p95 ≤ 300/500/600 ms; error rate < 0.1%; no degradation trend; AI endpoints excluded, measured separately with degradation asserted) plus SC-002 search p95, in backend/tests/Performance/
- [ ] T138 [P] Accessibility audit against WCAG 2.1 AA incl. bar mode (automated + manual checklist) in docs/a11y-audit.md
- [ ] T139 [P] Security hardening pass: OWASP checklist, secrets scan, dependency/container scanning gates verified in .github/workflows/ci.yml
- [ ] T140 SC sweep with explicit verification methods in backend/tests/Acceptance/SuccessCriteria/: automated (SC-003–SC-007, SC-009–SC-011, SC-013, SC-015–SC-017 via acceptance/contract suite tags; SC-002's search-latency half via T137); client-verified (SC-002's 3-interaction depth via a navigation-depth assertion in the Flutter integration suite; SC-014 via T125's integration test plus an on-device wakelock/voice checklist); semi-automated (SC-008 dataset-driven via the T147 harness; SC-012 via the T137 load rig); manual protocol (SC-001 timed UX walkthrough, documented checklist)
- [ ] T141 [P] ADR backlog: record R1–R18a decisions as ADRs, including the ai/search persistence decision (ai schema owned by the AI module; search owns no schema — an interpretation of Principle III) in docs/adr/
- [ ] T142 [P] Documentation: OpenAPI review sign-off, module boundary map, quickstart.md validation run in docs/
- [ ] T143 Run all quickstart.md scenarios 1–12 end-to-end and record results in specs/001-specpour-v1/quickstart-results.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)** → **Foundational (Phase 2)** → all user stories
- **US1 (Phase 3)**: requires only Foundational — MVP
- **US2 (Phase 4)**: requires Foundational (identity core exists there; US2 completes it)
- **US3 (Phase 5)**: requires US2 (accounts) + US1 entities (catalog/ingredients)
- **US4 (Phase 6)**: requires US1 (ingredient hierarchy) + US2 (accounts); T068 (AI foundation) also serves US12
- **US5 (Phase 7)**: requires US1 (recipes) + US2; house-made costing depends on US3
- **US16 (Phase 8)**: requires US2 + Foundational authorization; unblocks content workstream (T136)
- **US6 (Phase 9)**: requires US3 (authoring) + US1 (browse)
- **US7/US8 (Phases 10–11)**: require US1 entities only
- **US9 (Phase 12)**: requires US4 (inventory) + US5 (batch math); the menu-sourced path additionally requires US11 and the prep-sourced path requires US10 — acceptance tests for those two paths are tagged to run at the Phase 14 and Phase 13 checkpoints respectively (recipe-sourced path fully testable at Phase 12)
- **US10 (Phase 13)**: requires US3 (house-made) + US5 (batching) + US4 (inventory)
- **US11 (Phase 14)**: requires US5 (costing); print of prep/shopping artifacts depends on US9/US10
- **US12 (Phase 15)**: requires T068 + content stories for grounding
- **US13 (Phase 16)**: requires US1 + US2
- **US14 (Phase 17)**: requires US1 (recipes) — client-only
- **US15 (Phase 18)**: requires US1 content + US3 (user-authored edits for conflicts) + US11 (pins)
- **Polish (Phase 19)**: after desired stories complete

### Parallel Opportunities

- All [P] tasks within a phase (different files/modules)
- After Phase 2: US1 and US2 teams in parallel; then US3/US4/US5/US16 largely in parallel; US7/US8/US13/US14 are low-dependency fillers any time after their prerequisites
- Acceptance-test tasks ([P], first in every story) can be written while the previous story is finishing — criteria agreed before implementation per Principle I

## Parallel Example: User Story 1

```bash
# Failing-first tests together:
Task: T030 backend/tests/Acceptance/Features/US01_DiscoverRecipes.feature
Task: T031 frontend/app/integration_test/us01_discover_test.dart
# Then module domains in parallel:
Task: T032 Catalog domain    Task: T033 Ingredients domain
Task: T034 Equipment domain  Task: T035 Glossary domain
```

## Implementation Strategy

### MVP First

1. Phases 1–2 (Setup + Foundational)
2. Phase 3 (US1) → **STOP and VALIDATE**: guest discovery demo (quickstart scenario 1)
3. Phase 4 (US2) → accounts demo → this pair is the deployable MVP

### Incremental Delivery

Each subsequent phase is an independently testable increment ending in a checkpoint;
deliver in phase order, validating the story's Independent Test at each checkpoint.
Recommended release slices: [US1+US2] → [US3+US4+US5+US16] → [US6–US11] → [US12–US15].

## Notes

- Every story starts red: verify acceptance tests fail before implementing
- [P] = different files, no incomplete-task dependencies
- Commit after each task or logical group; no merge without all four suites green
- OpenAPI paths are authored/reviewed (T007 + per-story path tasks) before endpoint implementation — contract-first
