# SpecPour

SpecPour is a craft-cocktail platform: a curated recipe/ingredient/equipment/glossary
reference with consumer-scale identity, personal and venue bar libraries, community
publish/copy/rate, inventory-driven makeability, dilution-aware scaling/batching/costing,
shopping intelligence, prep management, collections/menus/print, gracefully degrading AI
features, bar mode, and tiered offline profiles.

## Architecture

- **Backend** (`backend/`): .NET 10 modular monolith (clean/hexagonal architecture),
  module-owned PostgreSQL schemas, outbox-dispatched domain events, every external
  integration behind a port/adapter. Exposes a contract-first `/api/v1` OpenAPI surface.
- **Frontend** (`frontend/app/`): single Flutter codebase (Android/iOS/web) consuming a
  generated Dart client (`frontend/packages/api_client/`), with a Drift-backed offline
  sync layer.

Full design detail lives in `specs/001-specpour-v1/` (plan.md, research.md,
data-model.md, contracts/api-v1-surface.md, quickstart.md). The project constitution is
at `.specify/memory/constitution.md`.

## Prerequisites

- .NET 10 SDK
- Flutter (stable channel)
- Docker + Docker Compose
- Java 17+ and Node.js (for OpenAPI client generation via `openapi-generator-cli`)

## Getting Started

```sh
# Start local infrastructure (Postgres+PostGIS, MinIO, otel-collector, API)
docker compose up -d

# Optional: load the curated catalog content (recipes/ingredients/equipment/
# glossary/concepts) so Discover etc. have real data to browse. Not started
# automatically by `up -d` (it's profile-gated — see docker-compose.yml's
# seeder service); idempotent, safe to re-run.
docker compose run --rm seeder

# Backend
cd backend
dotnet build

# Generated Dart API client (regenerate after any OpenAPI change; never hand-edit)
scripts/generate-client.sh

# Frontend
cd frontend/app
flutter pub get
flutter run
```

See `specs/001-specpour-v1/quickstart.md` for end-to-end validation scenarios.

## Local CI gate

Real CI is live (`.github/workflows/ci.yml`, GitHub Actions, required status
checks on `main` — see T168). Run `scripts/install-git-hooks.sh` once per
clone to also install a local pre-commit/pre-push hook
(`scripts/pre-push-checks.sh`) that runs the same checks locally, as an early
backstop before pushing: the four backend test suites, frontend analyze/
format/test, the generated-client drift check, and a NuGet vulnerable-package
scan. (Frontend `integration_test` on an Android emulator, the Trivy container
scan, and T190's coverage collection + non-regression ratchet aren't included
— impractical for a local hook — and stay CI-only; see
`scripts/check-coverage-ratchet.sh` to run the coverage ratchet manually if
ever needed.) Skip a one-off local run with `SKIP_LOCAL_CI_GATE=1 git commit ...`.
