#!/usr/bin/env bash
# T168: installs scripts/pre-push-checks.sh as both the pre-commit and
# pre-push hook (see that script's header for why both). Run once per clone
# — .git/hooks/ is never committed by git itself, so this has to be a
# separate opt-in step, same as any local-hooks setup.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOKS_DIR="$ROOT/.git/hooks"

for hook in pre-commit pre-push; do
  target="$HOOKS_DIR/$hook"
  cat > "$target" <<'HOOK'
#!/usr/bin/env bash
exec "$(git rev-parse --show-toplevel)/scripts/pre-push-checks.sh"
HOOK
  chmod +x "$target"
  echo "Installed $hook -> scripts/pre-push-checks.sh"
done

echo "Done. Skip a one-off check with SKIP_LOCAL_CI_GATE=1 git commit ..."
