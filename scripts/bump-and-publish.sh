#!/usr/bin/env bash
# Bump plugin versions, clear the local cache, and push so Claude Code
# picks up new/changed skills on next session start.
#
# Usage:
#   ./scripts/bump-and-publish.sh [patch|minor|major]  (default: patch)
#
# What it does:
#   1. Bumps the version in every plugin.json (semver component you choose)
#   2. Deletes the local plugin cache (~/.claude/plugins/cache/skills/)
#   3. Commits and pushes

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUMP="${1:-patch}"
CACHE_DIR="$HOME/.claude/plugins/cache/skills"

bump_version() {
  local ver="$1"
  local part="$2"
  IFS='.' read -r major minor patch <<< "$ver"
  case "$part" in
    major) echo "$((major + 1)).0.0" ;;
    minor) echo "$major.$((minor + 1)).0" ;;
    patch) echo "$major.$minor.$((patch + 1))" ;;
    *) echo >&2 "Unknown bump type: $part (use patch|minor|major)"; exit 1 ;;
  esac
}

echo "==> Bumping all plugin versions ($BUMP)"

find "$REPO_ROOT/plugins" -path '*/.claude-plugin/plugin.json' | while read -r pjson; do
  old_ver=$(grep -oP '"version"\s*:\s*"\K[^"]+' "$pjson")
  new_ver=$(bump_version "$old_ver" "$BUMP")
  sed -i "s/\"version\": \"$old_ver\"/\"version\": \"$new_ver\"/" "$pjson"
  plugin_name=$(grep -oP '"name"\s*:\s*"\K[^"]+' "$pjson")
  echo "    $plugin_name: $old_ver -> $new_ver"
done

echo "==> Clearing local plugin cache"
if [ -d "$CACHE_DIR" ]; then
  rm -rf "$CACHE_DIR"
  echo "    Deleted $CACHE_DIR"
else
  echo "    No cache to clear"
fi

echo "==> Committing and pushing"
cd "$REPO_ROOT"
git add -A plugins/
git commit -m "Bump plugin versions ($BUMP)"
git push

echo ""
echo "Done. Start a new Claude Code session to pick up the changes."
