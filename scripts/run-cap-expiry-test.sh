#!/usr/bin/env bash
# T177 #101(c): runs web_cap_expiry_test.dart in real headless Chrome, same
# as run-web-integration-tests.sh, but with one extra step in the middle: the
# Dart test signs in (with a uniquely-tagged 'capexpiry-' email) and sleeps
# for a fixed window; THIS script polls Postgres directly for that run's
# freshly-created SessionDevice row and backdates its CreatedAt while the
# Dart side is sleeping, so the test's later cold-restart hits a session
# that's genuinely past the 90-day absolute cap. Test-script-side backdate
# only — zero application code, zero new API surface (John's ruling,
# 2026-07-17; see web_cap_expiry_test.dart's own doc comment for the full
# rationale, including why Option 2 — a live clock-control endpoint — was
# rejected permanently, and why this polls the DB rather than scraping a
# print()'d marker out of flutter drive's stdout — that channel doesn't work
# at all on the web-server target).
#
# Prereqs: same as run-web-integration-tests.sh (docker stack up + migrated,
# Chrome installed, Flutter SDK on PATH), plus the postgres service reachable
# via `docker compose exec`.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="$ROOT/frontend/app"
CACHE="${TMPDIR:-/tmp}/specpour-chromedriver"
CHROME_BIN="${CHROME_EXECUTABLE:-$(command -v google-chrome || true)}"

if [[ -z "$CHROME_BIN" ]]; then
  echo "ERROR: Google Chrome not found. Install it or set CHROME_EXECUTABLE." >&2
  exit 1
fi
export CHROME_EXECUTABLE="$CHROME_BIN"

CHROME_VER="$("$CHROME_BIN" --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
DRIVER="$CACHE/chromedriver-linux64/chromedriver"
if [[ ! -x "$DRIVER" || "$($DRIVER --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)" != "$CHROME_VER" ]]; then
  echo "Downloading chromedriver $CHROME_VER ..."
  mkdir -p "$CACHE"
  curl -sfL "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VER/linux64/chromedriver-linux64.zip" \
    -o "$CACHE/chromedriver.zip"
  unzip -oq "$CACHE/chromedriver.zip" -d "$CACHE"
fi

"$DRIVER" --port=4444 &
DRIVER_PID=$!
trap 'kill $DRIVER_PID 2>/dev/null || true' EXIT
sleep 3

cd "$APP"

# Must match web_cap_expiry_test.dart's own _testTag constant.
TEST_TAG="capexpiry"

psql_query() {
  docker compose -f "$ROOT/docker-compose.yml" exec -T postgres \
    psql -U specpour -d specpour -t -A -c "$1"
}

# Baseline: the newest matching SessionDevice that already exists, if any
# (e.g. a leftover from an earlier interrupted run) — the poll below only
# accepts a row STRICTLY newer than this, so a stale row can never be
# mistaken for the one this run is about to create.
BASELINE_CREATED_AT="$(psql_query \
  "SELECT COALESCE(MAX(sd.\"CreatedAt\")::text, '-infinity') FROM identity.\"SessionDevices\" sd JOIN identity.\"AspNetUsers\" u ON sd.\"UserId\" = u.\"Id\" WHERE u.\"Email\" LIKE '${TEST_TAG}-%';")"

DRIVE_PID=""
trap 'kill $DRIVER_PID 2>/dev/null || true; [[ -n "$DRIVE_PID" ]] && kill "$DRIVE_PID" 2>/dev/null || true' EXIT

flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/web_cap_expiry_test.dart \
  -d web-server --browser-name=chrome --headless &
DRIVE_PID=$!

# The Dart side's own initial connection wait alone has been observed to
# take 25s+, on top of the register UI flow before this run's session even
# exists — 60 one-second checks cut that too close and lost the race in
# practice.
SESSION_ID=""
for _ in $(seq 1 150); do
  SESSION_ID="$(psql_query \
    "SELECT sd.\"Id\" FROM identity.\"SessionDevices\" sd JOIN identity.\"AspNetUsers\" u ON sd.\"UserId\" = u.\"Id\" WHERE u.\"Email\" LIKE '${TEST_TAG}-%' AND sd.\"CreatedAt\" > '${BASELINE_CREATED_AT}' ORDER BY sd.\"CreatedAt\" DESC LIMIT 1;")"
  if [[ -n "$SESSION_ID" ]]; then
    break
  fi
  if ! kill -0 "$DRIVE_PID" 2>/dev/null; then
    break
  fi
  sleep 1
done

if [[ -z "$SESSION_ID" ]]; then
  echo "ERROR: never saw this run's SessionDevice row appear in Postgres." >&2
  wait "$DRIVE_PID" || true
  exit 1
fi

echo "Backdating SessionDevices.CreatedAt for $SESSION_ID to 91 days ago ..."
docker compose -f "$ROOT/docker-compose.yml" exec -T postgres \
  psql -U specpour -d specpour -c \
  "UPDATE identity.\"SessionDevices\" SET \"CreatedAt\" = now() - interval '91 days' WHERE \"Id\" = '$SESSION_ID';"

wait "$DRIVE_PID"
