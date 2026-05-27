#!/bin/bash
# One-time installer that points this repo's git hooks at the versioned
# .githooks/ directory.
#
# Run once per clone:
#   bash scripts/install-hooks.sh

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

git config core.hooksPath .githooks
chmod +x .githooks/* 2>/dev/null || true

echo "Git hooks now point at .githooks/"
echo "Pre-push will run scripts/validate.sh (including mirror-integrity vs valara-claude-plugin)."
echo ""
echo "Override CLAUDE_PLUGIN_DIR env var if your Claude plugin clone lives elsewhere"
echo "(defaults to /home/jakep/valara-claude-plugin)."
