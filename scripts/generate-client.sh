#!/usr/bin/env bash
# Regenerates frontend/packages/api_client/ from the authored OpenAPI document.
# This is the ONLY sanctioned way to produce that package (Principle II:
# contract-first, hand-editing the generated client is prohibited). CI enforces
# that via scripts/check-client-drift.sh (see .github/workflows/ci.yml).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPEC="$ROOT/backend/contracts/openapi/openapi.yaml"
OUT_DIR="$ROOT/frontend/packages/api_client"
BUNDLE="$(mktemp -t specpour-openapi-bundle-XXXXXX.yaml)"
trap 'rm -f "$BUNDLE"' EXIT

echo "Generating Dart client: $SPEC -> $OUT_DIR"

# Bundle the multi-file OpenAPI document (root + per-module paths/*.yaml) into one
# self-contained file first. Feeding openapi-generator-cli the raw multi-file spec
# directly works, but its cross-file $ref resolution loses named-component identity
# for schemas defined inside a path file (e.g. authorization.yaml's
# EntitlementManifest), so it synthesizes ugly operation-derived Dart class names
# instead. Bundling with Redocly resolves every $ref into one document up front,
# preserving the authored schema names.
echo "Bundling multi-file OpenAPI document..."
npx --yes @redocly/cli bundle "$SPEC" -o "$BUNDLE"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

npx --yes @openapitools/openapi-generator-cli@2.39.1 generate \
  -i "$BUNDLE" \
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
