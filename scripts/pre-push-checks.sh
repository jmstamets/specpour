#!/usr/bin/env bash
# T168: the local CI-gate backstop. No remote is configured for this repo yet
# (as of 2026-07-14), so .github/workflows/ci.yml's gates have never actually
# run against this codebase — every guarantee it's supposed to enforce (four
# backend test suites, contract-drift, dependency scanning) has so far
# depended entirely on whoever's committing remembering to check by hand.
# This script closes that gap locally: it runs the same checks CI runs,
# minus the two jobs impractical for a local hook (frontend-integration-tests
# needs an Android emulator; container-scan needs a Trivy install) — those
# remain CI-only until real CI is provisioned, which is a separate decision
# (repo hosting) tracked by T168 itself, not something this script can do.
#
# Installed via scripts/install-git-hooks.sh as BOTH pre-commit and pre-push:
# with no remote configured, a pre-push-only hook would never fire on this
# repo's actual workflow (local commits straight to main, nothing pushed) —
# pre-commit is the real enforcement point today. Once a remote exists,
# pre-push stays wired for free with no extra setup.
set -euo pipefail

if [[ "${SKIP_LOCAL_CI_GATE:-}" == "1" ]]; then
  echo "SKIP_LOCAL_CI_GATE=1 set — skipping local CI-gate checks. Use sparingly." >&2
  exit 0
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# This sandbox's bare `dotnet`/`flutter`/`dart` resolve to the wrong thing
# (dotnet: an ambient .NET 8 SDK, not the .NET 10 SDK this repo needs;
# flutter/dart: not on PATH at all) — same trap documented for this repo's
# manual command history. Prepending here means the hook works regardless of
# the invoking shell's own profile.
export PATH="$HOME/.dotnet:$HOME/flutter-sdk/bin:$PATH"

echo "==> [1/4] Backend: build + all four test suites"
dotnet build backend/SpecPour.slnx -c Release
for suite in Acceptance Contract Integration Unit; do
  echo "----> $suite"
  dotnet test "backend/tests/$suite" -c Release --no-build
done

echo "==> [2/4] Frontend: analyze, format check, unit/widget tests"
(cd frontend/app && flutter pub get && flutter analyze)
(cd frontend/app && dart format --output=none --set-exit-if-changed .)
(cd frontend/app && flutter test)

echo "==> [3/4] Generated Dart client must not have drifted from openapi.yaml"
scripts/check-client-drift.sh

echo "==> [4/4] NuGet vulnerable-package scan"
dotnet restore backend/SpecPour.slnx
if dotnet list backend/SpecPour.slnx package --vulnerable --include-transitive 2>&1 \
    | tee /tmp/specpour-vulnerable.log | grep -q "has the following vulnerable packages"; then
  echo "ERROR: vulnerable NuGet packages found (see above)." >&2
  exit 1
fi

echo "All local CI-gate checks passed. (Not run here — CI-only until real CI exists:"
echo "  frontend integration_test on Android emulator, Trivy container scan.)"
