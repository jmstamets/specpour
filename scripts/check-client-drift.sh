#!/usr/bin/env bash
# CI merge gate (T008/T009): regenerates the Dart client and fails if the
# committed frontend/packages/api_client/ doesn't match — the hand-edit
# prohibition check for the generated client.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

"$ROOT/scripts/generate-client.sh"

if ! git diff --quiet -- frontend/packages/api_client; then
  echo "ERROR: frontend/packages/api_client is out of sync with backend/contracts/openapi/openapi.yaml." >&2
  echo "The generated client must never be hand-edited. Run scripts/generate-client.sh and commit the result." >&2
  git --no-pager diff --stat -- frontend/packages/api_client >&2
  exit 1
fi

echo "api_client is in sync with the OpenAPI spec."
