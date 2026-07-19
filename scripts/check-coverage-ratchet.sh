#!/usr/bin/env bash
# T190 (Phase 5 entry): merges collected coverage — backend Cobertura XML
# (coverlet, one file per `backend/tests/*` suite) and frontend LCov
# (`flutter test --coverage`) — into two overall line-coverage percentages via
# `reportgenerator`, then enforces a non-regression RATCHET against the stored
# baseline in coverage-baseline.json: today's number must be >= the baseline,
# never below it.
#
# Fail-closed per constitution Principle XVI / source Principle 18
# (Fail-Closed Verification): every failure mode here is a HARD non-zero exit,
# distinctly logged as either "inconclusive" (couldn't measure at all — the
# tool is missing, no coverage files were produced, or the merge yielded zero
# coverable lines) or "regressed" (a real, measured number below baseline).
# "0% because nothing could be measured" must never read as "0% which happens
# to be >= a 0% baseline" — this script never lets an empty/broken input look
# like a legitimate low score.
#
# Raising the baseline is a DELIBERATE MANUAL EDIT to coverage-baseline.json,
# in its own commit, when a contributor wants to lock in a real improvement —
# this script only ever enforces "not below stored baseline"; it never
# auto-writes a new (higher) number back to that file itself. That is a
# considered choice, not an oversight: an auto-raising ratchet run from CI
# would need write access back into the repo (a bot-commit loop / race with
# concurrent PRs), for a benefit (saving one manual line-edit) that doesn't
# justify the added attack surface on a solo-dev repo.
#
# BASELINE-SOURCING RULE (T198, established 2026-07-19): every number written
# into coverage-baseline.json MUST come from CI's OWN coverage artifact, never
# from a local `dotnet test`/`flutter test --coverage` run. To (re-)baseline:
# download the coverage-report run's `coverage-backend-*` and
# `coverage-frontend` artifacts (`gh run download <id>`), then run THIS script
# against them to read the exact numbers, and commit those. The environment
# that ENFORCES the baseline (CI) must be the environment that PRODUCES it —
# local and CI measurements genuinely differ. The incident that established
# this: T197 set 74.4% backend from a LOCAL measurement (3229/4339 covered);
# CI measured 3228/4339 (74.3%) on functionally-identical code — the SAME
# denominator, one fewer covered line (a background hosted-service timer path
# that fired locally but not in that CI run) — and the ratchet tripped on the
# very first CI run. A locally-set baseline sits at whatever point the local
# environment's nondeterminism happened to land, which is systematically not
# where CI lands.
#
# NO EPSILON / TOLERANCE (rejected deliberately, T198): the ratchet compares
# strictly (>=), with no fuzz band to absorb small drops. A 0.1% failure on a
# legitimate line is the ratchet working at full sensitivity. The sanctioned
# escape valve for a justified drop is a documented, reviewed baseline update
# in its own commit (deliberate and visible) — never a standing tolerance,
# which would let small regressions accumulate silently over time.
#
# NONDETERMINISTIC-COVERAGE FLAKE RULE (T200, pre-armed 2026-07-19): the T198
# incident's root cause — a single line whose coverage depends on wall-clock
# timing, not on what tests exist — is a LATENT FLAKE, not a one-off. It can
# recur between any two CI runs, not just local-vs-CI. When a ratchet failure
# is within ~1 line of baseline (a swing of a fraction of a percent on a
# denominator in the thousands), investigate it AS a suspected nondeterministic
# line FIRST, before assuming it's a real regression or reflexively
# re-baselining:
#   1. Compare the failing run's artifact against the run that last passed
#      (same production code, if any) — a same-denominator, few-line delta is
#      the signature (see T198's playbook: `gh run download`, merge with this
#      script, diff line-by-line).
#   2. If confirmed nondeterministic, the fix is making the line
#      DETERMINISTICALLY covered (a test that reliably exercises it) or
#      explicitly EXCLUDING it (`ExcludeByFile`/`Exclude` in
#      backend/coverlet.runsettings, with a comment explaining why) — never an
#      epsilon added to this ratchet (see above; still rejected).
#   3. Two candidate mechanisms identified but NOT confirmed as of T200 (two
#      fresh local runs failed to reproduce the T198 delta, both matching CI
#      exactly): `OutboxDispatcherBackgroundService` (5s poll loop, every
#      module's outbox — BuildingBlocks/Events/Outbox/) and
#      `AccountLifecycleBackgroundService` (same poll-loop shape, Identity-only
#      — Modules/Identity/Infrastructure/Lifecycle/). Both race their own
#      branch coverage (e.g. "did a poll cycle catch a pending row before the
#      test host shut down") against wall-clock time rather than against any
#      deterministic test trigger. Start here on the next occurrence rather
#      than re-deriving candidates from scratch.
#
# Usage:
#   scripts/check-coverage-ratchet.sh <backend-coverage-root> <frontend-lcov-file>
#
#   <backend-coverage-root>  a directory tree containing one or more
#                            coverage.cobertura.xml files anywhere under it
#                            (e.g. one per backend/tests/* suite — this script
#                            merges however many it finds).
#   <frontend-lcov-file>     the lcov.info file `flutter test --coverage`
#                            writes to frontend/app/coverage/lcov.info.
#
# Produces a Markdown summary on stdout (CI pipes this into
# $GITHUB_STEP_SUMMARY) and exits non-zero on any inconclusive or regressed
# measurement.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <backend-coverage-root> <frontend-lcov-file>" >&2
  exit 1
fi

BACKEND_ROOT="$1"
FRONTEND_LCOV="$2"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASELINE_FILE="$ROOT/coverage-baseline.json"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if ! command -v reportgenerator > /dev/null 2>&1; then
  echo "::error::reportgenerator not found on PATH — coverage cannot be measured, treating as inconclusive (not a pass)." >&2
  echo "Install: dotnet tool install -g dotnet-reportgenerator-globaltool" >&2
  exit 1
fi

if [[ ! -f "$BASELINE_FILE" ]]; then
  echo "::error::$BASELINE_FILE is missing — no baseline to ratchet against, treating as inconclusive." >&2
  exit 1
fi

# --- Backend: merge every coverage.cobertura.xml found under BACKEND_ROOT ---
mapfile -t backend_files < <(find "$BACKEND_ROOT" -name "coverage.cobertura.xml" -type f 2>/dev/null)
if [[ ${#backend_files[@]} -eq 0 ]]; then
  echo "::error::No coverage.cobertura.xml files found under $BACKEND_ROOT — backend coverage collection produced nothing, treating as inconclusive." >&2
  exit 1
fi
backend_reports="$(IFS=';'; echo "${backend_files[*]}")"

reportgenerator \
  -reports:"$backend_reports" \
  -targetdir:"$WORK/backend" \
  -reporttypes:"TextSummary" > "$WORK/backend-rg.log" 2>&1 || {
    echo "::error::reportgenerator failed merging backend coverage — see log:" >&2
    cat "$WORK/backend-rg.log" >&2
    exit 1
  }

backend_summary="$WORK/backend/Summary.txt"
if [[ ! -f "$backend_summary" ]]; then
  echo "::error::reportgenerator produced no backend Summary.txt — treating as inconclusive." >&2
  exit 1
fi

backend_coverable="$(grep -oE '^  Coverable lines: [0-9]+' "$backend_summary" | grep -oE '[0-9]+' || true)"
if [[ -z "$backend_coverable" || "$backend_coverable" -eq 0 ]]; then
  echo "::error::Backend merged coverage report has zero coverable lines — treating as inconclusive, not a genuine 0%." >&2
  exit 1
fi
backend_pct="$(grep -oE '^  Line coverage: [0-9.]+' "$backend_summary" | grep -oE '[0-9.]+$' || true)"
if [[ -z "$backend_pct" ]]; then
  echo "::error::Could not parse backend line-coverage percentage from reportgenerator output — treating as inconclusive." >&2
  exit 1
fi

# --- Frontend: single lcov.info from flutter test --coverage ---
if [[ ! -s "$FRONTEND_LCOV" ]]; then
  echo "::error::$FRONTEND_LCOV is missing or empty — frontend coverage collection produced nothing, treating as inconclusive." >&2
  exit 1
fi

reportgenerator \
  -reports:"$FRONTEND_LCOV" \
  -targetdir:"$WORK/frontend" \
  -reporttypes:"TextSummary" > "$WORK/frontend-rg.log" 2>&1 || {
    echo "::error::reportgenerator failed parsing frontend lcov.info — see log:" >&2
    cat "$WORK/frontend-rg.log" >&2
    exit 1
  }

frontend_summary="$WORK/frontend/Summary.txt"
if [[ ! -f "$frontend_summary" ]]; then
  echo "::error::reportgenerator produced no frontend Summary.txt — treating as inconclusive." >&2
  exit 1
fi

frontend_coverable="$(grep -oE '^  Coverable lines: [0-9]+' "$frontend_summary" | grep -oE '[0-9]+' || true)"
if [[ -z "$frontend_coverable" || "$frontend_coverable" -eq 0 ]]; then
  echo "::error::Frontend merged coverage report has zero coverable lines — treating as inconclusive, not a genuine 0%." >&2
  exit 1
fi
frontend_pct="$(grep -oE '^  Line coverage: [0-9.]+' "$frontend_summary" | grep -oE '[0-9.]+$' || true)"
if [[ -z "$frontend_pct" ]]; then
  echo "::error::Could not parse frontend line-coverage percentage from reportgenerator output — treating as inconclusive." >&2
  exit 1
fi

# --- Ratchet comparison against the stored baseline ---
baseline_backend="$(jq -r '.backend.lineCoveragePercent' "$BASELINE_FILE")"
baseline_frontend="$(jq -r '.frontend.lineCoveragePercent' "$BASELINE_FILE")"

backend_ok=$(awk -v now="$backend_pct" -v base="$baseline_backend" 'BEGIN { print (now + 0.0 >= base + 0.0) ? "1" : "0" }')
frontend_ok=$(awk -v now="$frontend_pct" -v base="$baseline_frontend" 'BEGIN { print (now + 0.0 >= base + 0.0) ? "1" : "0" }')

echo "## Coverage ratchet (T190)"
echo ""
echo "| | Baseline | Current | Result |"
echo "|---|---|---|---|"
if [[ "$backend_ok" == "1" ]]; then
  echo "| Backend (line) | ${baseline_backend}% | ${backend_pct}% | ✅ |"
else
  echo "| Backend (line) | ${baseline_backend}% | ${backend_pct}% | ❌ REGRESSED |"
fi
if [[ "$frontend_ok" == "1" ]]; then
  echo "| Frontend (line) | ${baseline_frontend}% | ${frontend_pct}% | ✅ |"
else
  echo "| Frontend (line) | ${baseline_frontend}% | ${frontend_pct}% | ❌ REGRESSED |"
fi
echo ""

failed=0
if [[ "$backend_ok" != "1" ]]; then
  echo "::error::Backend line coverage regressed: ${backend_pct}% < baseline ${baseline_backend}%." >&2
  failed=1
fi
if [[ "$frontend_ok" != "1" ]]; then
  echo "::error::Frontend line coverage regressed: ${frontend_pct}% < baseline ${baseline_frontend}%." >&2
  failed=1
fi

if [[ "$failed" -eq 1 ]]; then
  echo "To raise the baseline after a deliberate improvement, edit coverage-baseline.json in its own commit."
  exit 1
fi

echo "Coverage ratchet held (no regression)."
