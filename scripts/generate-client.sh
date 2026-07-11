#!/usr/bin/env bash
# Regenerates frontend/packages/api_client/ from the authored OpenAPI document.
# This is the ONLY sanctioned way to produce that package (Principle II:
# contract-first, hand-editing the generated client is prohibited). CI enforces
# that via scripts/check-client-drift.sh (see .github/workflows/ci.yml).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPEC="$ROOT/backend/contracts/openapi/openapi.yaml"
OUT_DIR="$ROOT/frontend/packages/api_client"

echo "Generating Dart client: $SPEC -> $OUT_DIR"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

npx --yes @openapitools/openapi-generator-cli@2.39.1 generate \
  -i "$SPEC" \
  -g dart-dio \
  -o "$OUT_DIR" \
  --additional-properties="pubName=api_client,pubAuthor=SpecPour,nullableFields=true,hideGenerationTimestamp=true" \
  --skip-validate-spec

echo "Fetching pub dependencies and running build_runner (built_value serializers)..."
(
  cd "$OUT_DIR"
  dart pub get
  dart run build_runner build --delete-conflicting-outputs
)

cat > "$OUT_DIR/GENERATED.md" <<'EOF'
# GENERATED — do not hand-edit

This package is generated from `backend/contracts/openapi/openapi.yaml` by
`scripts/generate-client.sh`. Manual changes are overwritten on the next
regeneration and are caught by CI's drift check
(`scripts/check-client-drift.sh`), which fails the build on any diff.

To change this client: edit the OpenAPI document, then run
`scripts/generate-client.sh` and commit the regenerated output.
EOF

echo "Done."
