#!/usr/bin/env bash
# Runs the Flutter web integration tests in a real (headless) Chrome via
# `flutter drive` + chromedriver, against the live docker backend. This is the
# "browser-context" tier that unit/widget tests can't cover: the ADR-0003
# cookie-then-PKCE flow has a web-only code path (following the /connect/authorize
# redirect and reading the code off the final URL — Dio can't do this on web) that
# only executes in an actual browser. Registration was "green in every suite but
# dead in a real browser" until this tier existed (walkthrough finding #1,
# 2026-07-15).
#
# Prereqs:
#   - docker stack up and migrations current:  docker compose up -d
#     (rebuild first if backend changed: docker compose build api migration-runner
#      && docker compose run --rm migration-runner)
#   - Google Chrome installed (google-chrome on PATH or CHROME_EXECUTABLE set)
#   - Flutter SDK on PATH
# A matching chromedriver is downloaded automatically if not already present.
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

# Fetch a chromedriver matching the installed Chrome (Chrome-for-Testing channel).
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
# Target may be overridden: run-web-integration-tests.sh <target>
TARGET="${1:-integration_test/web_registration_test.dart}"
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target="$TARGET" \
  -d web-server --browser-name=chrome --headless
