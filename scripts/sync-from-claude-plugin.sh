#!/usr/bin/env bash
set -euo pipefail

# Mirror skills/ from valara-claude-plugin (canonical) into this repo.
# Idempotent - safe to re-run after Claude plugin updates.
#
# Per docs/superpowers/plans/2026-05-26-mcp-to-plugins/00-master.md
# this repo is the MIRROR; valara-claude-plugin is the SOURCE OF TRUTH
# for SKILL.md content. Manifests + .mcp.json + .codex-plugin/ are
# unique to this repo (Codex schema differs from Claude) and are NOT
# synced.

CLAUDE_PLUGIN_DIR="${CLAUDE_PLUGIN_DIR:-/home/jakep/valara-claude-plugin}"

if [ ! -d "$CLAUDE_PLUGIN_DIR/skills" ]; then
  echo "FAIL: Claude plugin not found at $CLAUDE_PLUGIN_DIR/skills"
  echo "      Set CLAUDE_PLUGIN_DIR or clone valara-claude-plugin first."
  exit 1
fi

cd "$(dirname "$0")/.."

echo "Syncing skills/ from $CLAUDE_PLUGIN_DIR/skills/ ..."
rsync -av --delete "$CLAUDE_PLUGIN_DIR/skills/" "./skills/"

echo "Syncing README badges (Codex-specific install command stays local)..."
# README intentionally NOT synced - install commands differ.

echo "Done. Run 'git status' to see what changed."
