#!/usr/bin/env bash
set -euo pipefail

# Validates wikilink integrity across skills/ and (if present) commands/.
# Expected wikilink form: [[skill-name]] resolves to skills/<skill-name>/SKILL.md
# OR commands/<skill-name>.md.
#
# Requires bash 4+ for BASH_REMATCH (used in [[ =~ ]]).

if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  echo "FAIL: validate-wikilinks.sh requires bash 4 or newer." >&2
  exit 1
fi

cd "$(dirname "$0")/.."

FAIL=0

# Collect all skill names + command names (the valid wikilink targets).
declare -A VALID_TARGETS=()
if [ -d skills ]; then
  while IFS= read -r dir; do
    name=$(basename "$dir")
    VALID_TARGETS[$name]=1
  done < <(find skills -mindepth 1 -maxdepth 1 -type d)
fi
if [ -d commands ]; then
  while IFS= read -r f; do
    name=$(basename "$f" .md)
    VALID_TARGETS[$name]=1
  done < <(find commands -maxdepth 1 -name '*.md' -type f)
fi

# Scan SKILL.md + commands/*.md for wikilinks like [[target]] and validate.
SCAN_FILES=()
if [ -d skills ]; then
  while IFS= read -r f; do SCAN_FILES+=("$f"); done < <(find skills -name SKILL.md)
fi
if [ -d commands ]; then
  while IFS= read -r f; do SCAN_FILES+=("$f"); done < <(find commands -maxdepth 1 -name '*.md' -type f)
fi

if [ "${#SCAN_FILES[@]}" -eq 0 ]; then
  echo "OK no files with wikilinks to validate"
  exit 0
fi

for f in "${SCAN_FILES[@]}"; do
  while IFS= read -r line; do
    while [[ "$line" =~ \[\[([a-z0-9-]+)\]\] ]]; do
      target="${BASH_REMATCH[1]}"
      if [ -z "${VALID_TARGETS[$target]:-}" ]; then
        echo "FAIL: $f references unknown wikilink target [[$target]]"
        FAIL=1
      fi
      # Strip the matched portion so the loop progresses.
      line="${line/\[\[${target}\]\]/}"
    done
  done < "$f"
done

if [ "$FAIL" -ne 0 ]; then
  exit 1
fi

echo "OK all wikilinks resolve"
