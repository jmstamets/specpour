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

# --- T204: frontend coverage, ADVISORY ONLY ---------------------------------
# Why this exists: T070 (the whole inventory UI) shipped with zero widget tests
# and dropped frontend line coverage from ~80% to 72.86%. This gate ran plain
# `flutter test`, which was green, so the regression only surfaced on CI's
# coverage-report — one push-and-wait later, on an already-ready PR whose
# handoff it retroactively voided (T203). An advisory warning here would have
# flagged that one deafeningly (72.86% vs an 80.0 baseline).
#
# Why ADVISORY and never a hard fail (John's explicit ruling, 2026-07-19):
# local frontend coverage reads roughly 1.1 POINTS BELOW CI on identical code
# (T198: local 78.9 vs CI 80.0), because the two environments genuinely measure
# differently. A hard fail against the CI baseline would therefore false-fail
# legitimate near-boundary pushes — blocking real work over a measurement
# artifact. **The CI ratchet remains the sole enforcement point**; this is a
# fast local heads-up, deliberately non-blocking. It must NEVER exit non-zero:
# every failure path below degrades to a printed note and returns 0, because a
# broken advisory check blocking a push would be strictly worse than no check.
#
# Frontend only, on purpose: backend coverage collection is coverlet across 37
# assemblies (expensive), and the T198 CI-sourcing rule means the backend
# baseline must come from CI regardless — so there is nothing a local backend
# number could legitimately be compared against.
FRONTEND_COVERAGE_LOCAL_SKEW="1.5"   # points below the CI baseline before we shout; covers T198's measured ~1.1

frontend_coverage_advisory() {
  local lcov="$ROOT/frontend/app/coverage/lcov.info"
  local baseline pct work

  if [[ ! -s "$lcov" ]]; then
    echo "NOTE: no frontend lcov.info produced — skipping advisory coverage check (not a failure)." >&2
    return 0
  fi
  if ! command -v jq > /dev/null 2>&1 || [[ ! -f "$ROOT/coverage-baseline.json" ]]; then
    echo "NOTE: jq or coverage-baseline.json unavailable — skipping advisory coverage check (not a failure)." >&2
    return 0
  fi

  baseline="$(jq -r '.frontend.lineCoveragePercent' "$ROOT/coverage-baseline.json" 2>/dev/null || true)"
  if [[ -z "$baseline" || "$baseline" == "null" ]]; then
    echo "NOTE: could not read the frontend baseline — skipping advisory coverage check (not a failure)." >&2
    return 0
  fi

  # Prefer reportgenerator: it is the exact tool the CI ratchet uses, so the
  # number printed here is methodologically comparable to the one that will
  # actually gate. Fall back to summing lcov's own LF/LH records when it isn't
  # installed (it is a dotnet global tool, not guaranteed on every machine) —
  # verified to agree with reportgenerator on this repo's lcov.
  if command -v reportgenerator > /dev/null 2>&1; then
    work="$(mktemp -d)"
    if reportgenerator -reports:"$lcov" -targetdir:"$work" -reporttypes:TextSummary > /dev/null 2>&1 \
       && [[ -f "$work/Summary.txt" ]]; then
      pct="$(grep -oE '^  Line coverage: [0-9.]+' "$work/Summary.txt" | grep -oE '[0-9.]+$' || true)"
    fi
    rm -rf "$work"
  fi
  if [[ -z "${pct:-}" ]]; then
    pct="$(awk -F: '/^LF:/ {lf += $2} /^LH:/ {lh += $2} END { if (lf > 0) printf "%.1f", (lh * 100.0) / lf }' "$lcov" || true)"
  fi
  if [[ -z "$pct" ]]; then
    echo "NOTE: could not compute frontend coverage — skipping advisory check (not a failure)." >&2
    return 0
  fi

  local floor
  floor="$(awk -v b="$baseline" -v s="$FRONTEND_COVERAGE_LOCAL_SKEW" 'BEGIN { printf "%.1f", b - s }')"
  if [[ "$(awk -v p="$pct" -v f="$floor" 'BEGIN { print (p + 0.0 < f + 0.0) ? 1 : 0 }')" == "1" ]]; then
    echo "" >&2
    echo "  ############################################################" >&2
    echo "  # ADVISORY: frontend line coverage looks like a REGRESSION  #" >&2
    echo "  ############################################################" >&2
    echo "  Local:    ${pct}%" >&2
    echo "  CI base:  ${baseline}%  (local-adjusted floor ${floor}%, allowing ${FRONTEND_COVERAGE_LOCAL_SKEW}pt local-vs-CI skew)" >&2
    echo "" >&2
    echo "  CI's coverage-report job will very likely go RED on this push." >&2
    echo "  Most likely cause: a new screen/provider shipped without widget tests." >&2
    echo "  Note browser/integration tests do NOT carry coverage (see" >&2
    echo "  scripts/check-coverage-ratchet.sh) — only widget/unit tests do." >&2
    echo "" >&2
    echo "  NOT BLOCKING — the push proceeds. CI remains the enforcement point." >&2
    echo "" >&2
  else
    echo "     frontend coverage ${pct}% (CI baseline ${baseline}%, local floor ${floor}%) — advisory OK"
  fi
  return 0
}

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

echo "==> [2/4] Frontend: analyze, format check, unit/widget tests (+ advisory coverage)"
(cd frontend/app && flutter pub get && flutter analyze)
(cd frontend/app && dart format --output=none --set-exit-if-changed .)
# T204: --coverage instead of a plain run. Same tests, same wall-clock cost to
# a first approximation — the VM just also emits hit data — so this buys the
# advisory check below for essentially free.
(cd frontend/app && flutter test --coverage)
frontend_coverage_advisory

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

echo "All local CI-gate checks passed. (Not run here — CI-only:"
echo "  frontend integration_test on Android emulator, Trivy container scan,"
echo "  BACKEND coverage collection + the enforcing non-regression ratchet — see"
echo "  scripts/check-coverage-ratchet.sh to run it manually if needed."
echo "  T204: frontend coverage IS measured above, but only ADVISORY — a"
echo "  warning there means CI will likely go red; CI still enforces.)"
