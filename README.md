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
