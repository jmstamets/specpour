#!/usr/bin/env bash
# T178 (FR-003a): runs web_export_download_test.dart, then verifies the real
# downloaded artifact on the host filesystem — the Dart test itself can't do
# this (dart:io isn't available in code compiled for the web target it runs
# against), so this script owns the host-side half, same split T177 #101(c)'s
# cap-expiry test uses for its own dart:io-unavailable reason.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOWNLOADS="${HOME}/Downloads"
mkdir -p "$DOWNLOADS"

before="$(find "$DOWNLOADS" -maxdepth 1 -iname 'specpour-data-export-*.json' 2>/dev/null | sort)"

"$ROOT/scripts/run-web-integration-tests.sh" integration_test/web_export_download_test.dart

after="$(find "$DOWNLOADS" -maxdepth 1 -iname 'specpour-data-export-*.json' 2>/dev/null | sort)"
new_file="$(comm -13 <(echo "$before") <(echo "$after") | head -1)"

if [[ -z "$new_file" ]]; then
  echo "ERROR: no new specpour-data-export-*.json appeared in $DOWNLOADS." >&2
  exit 1
fi

echo "Downloaded artifact: $new_file"
if ! python3 -c "
import json, sys
with open('$new_file') as f:
    data = json.load(f)
assert 'email' in data and data['email'], 'missing email field'
assert 'userId' in data and data['userId'], 'missing userId field'
assert 'sessions' in data, 'missing sessions field'
print('Artifact content OK:', {k: data[k] for k in ('userId', 'email')})
"; then
  echo "ERROR: downloaded artifact failed content validation." >&2
  exit 1
fi

rm -f "$new_file"
