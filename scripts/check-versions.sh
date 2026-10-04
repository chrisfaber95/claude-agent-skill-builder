#!/usr/bin/env bash
# Fails when a plugin's files differ from the base ref but its plugin.json version does not.
# Installed plugins are cached by version, so an unbumped change never reaches users.
# Usage: scripts/check-versions.sh [base-ref]   (default: origin/main; compares the working tree)
set -euo pipefail

base="${1:-origin/main}"
cd "$(git rev-parse --show-toplevel)"
git rev-parse --verify --quiet "$base^{commit}" >/dev/null || { echo "unknown base ref: $base" >&2; exit 2; }

version_at() { git show "$1:$2" 2>/dev/null | sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1; }

fail=0
for dir in plugins/*/; do
  plugin="${dir%/}"
  manifest="$plugin/.claude-plugin/plugin.json"
  [ -f "$manifest" ] || continue
  if [ -z "$(git diff --name-only "$base" -- "$plugin" 2>/dev/null)" ] && [ -z "$(git ls-files --others --exclude-standard -- "$plugin")" ]; then
    continue
  fi
  old="$(version_at "$base" "$manifest")"
  new="$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$manifest" | head -1)"
  if [ -z "$old" ]; then
    echo "new     ${plugin#plugins/} ($new)"
  elif [ "$old" = "$new" ]; then
    echo "NO BUMP ${plugin#plugins/}: files changed since $base but version is still $new"
    fail=1
  else
    echo "ok      ${plugin#plugins/}: $old -> $new"
  fi
done
exit "$fail"
