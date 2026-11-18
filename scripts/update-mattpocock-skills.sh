#!/usr/bin/env bash
set -euo pipefail

# Re-clones https://github.com/mattpocock/skills and refreshes the project-local
# copies in .claude/skills/. Installs the skills listed in the upstream plugin
# manifest (.claude-plugin/plugin.json), i.e. the same set as the official plugin.
#
# The upstream `code-review` skill is renamed to `code-review-mp` (and references
# to it in the other skills rewritten) so it doesn't clash with Claude Code's
# built-in /code-review.
#
# Usage: scripts/update-mattpocock-skills.sh [git-ref]

REPO_URL="https://github.com/mattpocock/skills"
REF="${1:-main}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/.claude/skills"
MANIFEST="$DEST/.mattpocock-skills"

declare -A RENAMES=([code-review]=code-review-mp)

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --quiet --depth 1 --branch "$REF" "$REPO_URL" "$TMP/skills"
COMMIT="$(git -C "$TMP/skills" rev-parse HEAD)"

mapfile -t paths < <(python3 -I -c \
  'import json,sys; print("\n".join(json.load(open(sys.argv[1]))["skills"]))' \
  "$TMP/skills/.claude-plugin/plugin.json")

mkdir -p "$DEST"

# Remove skills installed by a previous run, so upstream deletions propagate.
if [ -f "$MANIFEST" ]; then
  grep -v '^#' "$MANIFEST" | while IFS= read -r name; do
    [ -n "$name" ] && rm -rf "${DEST:?}/$name"
  done
fi

names=()
for p in "${paths[@]}"; do
  src="$TMP/skills/${p#./}"
  name="$(basename "$src")"
  name="${RENAMES[$name]:-$name}"
  rm -rf "${DEST:?}/$name"
  cp -r "$src" "$DEST/$name"
  names+=("$name")
done

# Apply renames to skill names and cross-references.
for old in "${!RENAMES[@]}"; do
  new="${RENAMES[$old]}"
  for name in "${names[@]}"; do
    find "$DEST/$name" -type f -name '*.md' \
      -exec sed -i -E "s/(^|[^A-Za-z0-9_-])$old([^A-Za-z0-9_-]|$)/\1$new\2/g" {} +
  done
done

cp "$TMP/skills/LICENSE" "$DEST/LICENSE-mattpocock-skills"

{
  echo "# Installed by scripts/update-mattpocock-skills.sh from $REPO_URL @ $COMMIT"
  printf '%s\n' "${names[@]}"
} > "$MANIFEST"

echo "Installed ${#names[@]} skills from $REPO_URL @ $COMMIT into $DEST"
