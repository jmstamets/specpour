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

# Loud, not silent: if $HOME/.dotnet isn't populated on some future machine/
# contributor, bare `dotnet` falls through to an ambient older SDK that can
# silently mis-parse this repo's .slnx (observed 2026-07-15: an ambient .NET 8
# SDK's `dotnet list package --vulnerable` printed a usage screen instead of an
# error on a .slnx it couldn't read, which a naive grep read as "no results").
dotnet_major="$(dotnet --version | cut -d. -f1)"
if [[ "$dotnet_major" -lt 10 ]]; then
  echo "ERROR: resolved dotnet is $(dotnet --version), but this repo needs .NET 10+." >&2
  echo "  (bare 'dotnet' is resolving to the wrong SDK — check PATH)" >&2
  exit 1
fi

echo "==> [1/4] Backend: build + all four test suites"
dotnet build backend/SpecPour.slnx -c Release
for suite in Acceptance Contract Integration Unit; do
  echo "----> $suite"
  dotnet test "backend/tests/$suite" -c Release --no-build 2>&1 | tee /tmp/specpour-test-output.log
  # Defense-in-depth (2026-07-16 fail-open audit): no --filter is used here,
  # so the confirmed "0 tests matched a filter -> exit 0" mode isn't
  # reachable today, but a genuinely empty test project is a separate,
  # unconfirmed code path in dotnet test. Require evidence that a nonzero
  # number of tests actually ran, not just "no failure."
  if ! grep -qE "Passed!.*Total: *[1-9]" /tmp/specpour-test-output.log; then
    echo "ERROR: no evidence that any tests actually ran in $suite — treating as inconclusive, not clean." >&2
    exit 1
  fi
done

echo "==> [2/4] Frontend: analyze, format check, unit/widget tests"
(cd frontend/app && flutter pub get && flutter analyze)
(cd frontend/app && dart format --output=none --set-exit-if-changed .)
(cd frontend/app && flutter test)

echo "==> [3/4] Generated Dart client must not have drifted from openapi.yaml"
scripts/check-client-drift.sh

echo "==> [4/4] NuGet vulnerable-package scan"
dotnet restore backend/SpecPour.slnx
dotnet list backend/SpecPour.slnx package --vulnerable --include-transitive 2>&1 \
    | tee /tmp/specpour-vulnerable.log
# Fail closed, not open: "The following sources were used" only appears when the
# advisory-feed query actually completed. Its absence means the scan was
# inconclusive (network/feed issue), not clean — a real MailKit/MimeKit CVE pair
# went undetected here for weeks because this check silently passed on an
# incomplete scan (2026-07-15, root-caused when real CI finally ran and caught it).
if ! grep -q "The following sources were used" /tmp/specpour-vulnerable.log; then
  echo "ERROR: NuGet vulnerability scan did not complete (no source query recorded) — treating as inconclusive, not clean. See /tmp/specpour-vulnerable.log." >&2
  exit 1
fi
if grep -q "has the following vulnerable packages" /tmp/specpour-vulnerable.log; then
  echo "ERROR: vulnerable NuGet packages found (see above)." >&2
  exit 1
fi

echo "All local CI-gate checks passed. (Not run here — CI-only until real CI exists:"
echo "  frontend integration_test on Android emulator, Trivy container scan.)"
