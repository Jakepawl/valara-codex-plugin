#!/usr/bin/env bash
set -euo pipefail

# Same bash-4+ requirement as the Claude plugin's validate.sh; the
# called validate-wikilinks.sh uses BASH_REMATCH from [[ =~ ]].
if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  echo "FAIL: validate.sh requires bash 4 or newer." >&2
  exit 1
fi

cd "$(dirname "$0")/.."

FAIL=0

echo "=== 1. JSON manifests parse ==="
python3 -c "import json; json.load(open('.codex-plugin/plugin.json'))" && echo "OK .codex-plugin/plugin.json" || FAIL=1
python3 -c "import json; json.load(open('.agents/plugins/marketplace.json'))" && echo "OK .agents/plugins/marketplace.json" || FAIL=1
python3 -c "import json; json.load(open('.mcp.json'))" && echo "OK .mcp.json" || FAIL=1

echo ""
echo "=== 2. plugin.json manifest fields ==="
python3 - <<'PY'
import json
m = json.load(open('.codex-plugin/plugin.json'))
required = {"name", "version", "description", "author"}
missing = required - set(m.keys())
if missing:
    print(f"FAIL: .codex-plugin/plugin.json missing required fields: {missing}")
    exit(1)
if m["name"] != "valara":
    print(f"FAIL: .codex-plugin/plugin.json name must be 'valara', got {m['name']!r}")
    exit(1)
print("OK manifest fields")
PY

echo ""
echo "=== 3. SKILL.md line-limit (max 80 per Contract 10) ==="
while IFS= read -r f; do
  lines=$(wc -l < "$f")
  if [ "$lines" -gt 80 ]; then
    echo "FAIL: $f is $lines lines (max 80)"
    FAIL=1
  fi
done < <(find skills/ -name SKILL.md)
[ "$FAIL" -eq 0 ] && echo "OK all SKILL.md under 80 lines"

echo ""
echo "=== 4. Forbidden phrases (Contract 11) ==="
# Word-boundary anchors (\b...\b) prevent legitimate JSON field name
# "anti_patterns" (underscore-separated, used in SKILL.md prose to
# reference the AssistantHint schema) from tripping the gate against
# the hyphen-separated forbidden phrase "anti-pattern".
if grep -rIE '\banti-pattern\b|\bbrand voice\b|\bnever auto-publish\b|\btone_hint\b|\bpunchier\b|\bsalesy\b' skills/ 2>/dev/null; then
  echo "FAIL: found IP-protected phrase in public skills - move to server-side"
  FAIL=1
else
  echo "OK no forbidden phrases"
fi

echo ""
echo "=== 5. Em dash check (CLAUDE.md Rule 41) ==="
if grep -rIP '\x{2014}' skills/ 2>/dev/null; then
  echo "FAIL: em dash (U+2014) found - use hyphen-minus per Rule 41"
  FAIL=1
else
  echo "OK no em dashes"
fi

echo ""
echo "=== 6. Wikilink integrity ==="
bash scripts/validate-wikilinks.sh

echo ""
echo "=== 7. Skill mirror integrity ==="
# If valara-claude-plugin is present locally, verify byte-for-byte match.
CLAUDE_PLUGIN_DIR="${CLAUDE_PLUGIN_DIR:-/home/jakep/valara-claude-plugin}"
if [ -d "$CLAUDE_PLUGIN_DIR/skills" ]; then
  for f in skills/*/SKILL.md; do
    name=$(basename "$(dirname "$f")")
    if [ ! -f "$CLAUDE_PLUGIN_DIR/skills/$name/SKILL.md" ]; then
      echo "SKIP: $name has no canonical counterpart yet (Phase 1 still in flight)"
      continue
    fi
    if ! diff -q "$f" "$CLAUDE_PLUGIN_DIR/skills/$name/SKILL.md" >/dev/null 2>&1; then
      echo "FAIL: $f drifts from canonical $CLAUDE_PLUGIN_DIR/skills/$name/SKILL.md"
      FAIL=1
    fi
  done
  [ "$FAIL" -eq 0 ] && echo "OK skills are in sync with Claude plugin"
else
  echo "SKIP: $CLAUDE_PLUGIN_DIR not present (CI mode); skipping mirror check"
fi

echo ""
if [ "$FAIL" -ne 0 ]; then
  echo "=== VALIDATION FAILED ==="
  exit 1
fi
echo "=== VALIDATION PASSED ==="
