# Quickstart Validation Guide: SpecPour V1

Purpose: runnable scenarios proving the feature works end-to-end. Implementation
details live in tasks.md; contracts in `contracts/api-v1-surface.md`; entities in
`data-model.md`.

## Prerequisites

- Docker + Docker Compose (local stack: API, PostgreSQL 17 + PostGIS, MinIO,
  otel-collector)
- .NET 10 SDK; Flutter stable SDK
- No cloud credentials required — the stack is fully local (constitution: cloud-agnostic)

## Stack up

```bash
docker compose up -d                    # postgres+postgis, minio, otel-collector
dotnet run --project backend/src/Tools/MigrationRunner   # forward-only migrations, all module schemas
dotnet run --project backend/src/Tools/Seeder            # curated seed: recipes, ingredients, glossary, equipment, conventions
dotnet run --project backend/src/Api                     # https://localhost:5001, /health/ready green
```

## Test gates (CI order — all must pass to merge; Principle I)

```bash
dotnet test backend/tests/Acceptance      # Reqnroll Given/When/Then vs real Postgres (Testcontainers)
dotnet test backend/tests/Contract        # running API validated against authored OpenAPI
dotnet test backend/tests/Integration
dotnet test backend/tests/Unit
flutter test                              # app/packages unit + widget
flutter test integration_test             # client acceptance flows
```

## End-to-end validation scenarios

1. **Guest discovery (US1)**: with the API running and no auth token, `GET
   /api/v1/search?q=mai+tai` returns the seeded Mai Tai; `GET /recipes/{id}` shows
   ingredient lines, derived ABV/standard drinks, and the egg-white allergen flag on a
   flip recipe. Attempting `POST /ratings` unauthenticated returns 401 with a
   sign-in prompt payload (intent preserved).
2. **Identity lifecycle (US2)**: register (DOB captured) → sign in on two simulated
   devices → both listed at `/me/sessions` → revoke one → recovery flow → `GET
   /me/export` returns complete personal data → `DELETE /me` anonymizes public
   attribution (verify a prior rating event is de-identified, not deleted).
3. **Author & publish cascade (US3/US6)**: create private "House Grenadine"
   (house-made) → use it in a private recipe → publish the recipe → cascade manifest
   lists the grenadine (and any private equipment) → consent → second account copies
   it (provenance recorded) and rates it → aggregate = latest-per-user mean → owner
   unpublishes → aggregate hidden publicly, copy unaffected.
4. **Inventory & makeability (US4)**: add "Beefeater" via manual entry → `GET
   /inventory/makeable` counts recipes calling for "London dry gin"/"gin" as
   satisfied; near-miss lists the one missing ingredient with substitutions and
   suitability notes; recognition failure path returns a pre-filled form payload.
5. **Scaling/batching/costing (US5)**: scale seeded Daiquiri to 20 pre-diluted →
   output separates batched portion from at-service lime, water matches the
   shake-method convention table exactly (SC-005); with bottle prices set, costing
   returns per-drink cost and suggested price for a target pour-cost %.
6. **Prep + notifications (US10, FR-040a)**: send a grenadine batch to a prep list →
   complete with made-on date → advance clock (test hook) past shelf life → inbox
   message appears, prep drops out of makeability.
7. **Offline (US15)**: on a device with `recipes-text` profile and a pinned
   collection, airplane-mode the client → pinned recipes open, local search and
   makeability work over synced content, AI/community surfaces show "unavailable
   offline" → edit the same recipe on two offline devices → reconnect → merge-or-
   prompt dialog (never silent loss).
8. **AI off (US12, SC-007)**: disable all AI toggles → chat/insights absent cleanly,
   discovery returns deterministic similarity results, bottle recognition falls back
   to manual form. No broken surface.
9. **Tier by configuration (SC-011)**: insert a new tier row + capability grants in
   the test environment; verify feature gating changes with zero code deployment.
10. **Age gate (FR-002a)**: set a surface's gate to `mandatory` in compliance config →
    guest visit presents DOB-entry gate (strictest rule when GeoIP is ambiguous);
    verify no DOB value appears in any request log or database (client-side affirmed
    flag only).
11. **DOB as sensitive PII (FR-002b/c, SC-017)**: register an of-age account → verify
    the DOB column is ciphertext in PostgreSQL, `/me/export` is the only response
    containing the raw value, staff account views show verified status only, and the
    decrypt during export appears in the audit log. Attempt an underage registration →
    rejected, and the database, logs, and traces contain no DOB or attempt record.
12. **Platform administration (US16, SC-016)**: seeded Super Admin signs in (MFA
    enforced) → grants Curator with approval step → curator edits a core recipe →
    Support suspends/reinstates a test account → verify every action appears in
    `/admin/audit-log` with actor/action/target/timestamp and before/after state;
    verify admin routes are absent from mobile builds and no signup path can yield a
    platform role.

## Expected outcomes

- All six test suites green; acceptance suite includes at least one failing-first
  commit per user story in history (red-green evidence).
- `/health/live` and `/health/ready` return 200; traces visible in the local
  otel-collector output with client→API correlation IDs.
- SC-010 job: recomputing rating projections from events matches displayed aggregates
  exactly.
