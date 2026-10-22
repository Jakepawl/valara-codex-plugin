# Valara - Codex Plugin

Connect [OpenAI Codex](https://openai.com/codex/) to your [Valara](https://valara.si) real-estate dashboard.

## What you get

- Browse your tours, check schedule, triage notifications, draft listing copy - all from Codex chat
- OAuth 2.1 + PKCE with per-tool scope picking
- Sandbox / live mode toggle (sandbox is the default for first-time users)
- Per-user audit trail at https://valara.si

## Install in Codex

This repository is **private**. Before installing, make sure your GitHub CLI is authenticated and has access to `Jakepawl/valara-codex-plugin`:

```bash
gh auth status
gh auth refresh -s repo  # if you do not already have the 'repo' scope
```

Then install via Codex:

```bash
codex plugin marketplace add Jakepawl/valara-codex-plugin
codex plugin add valara@valara-marketplace
```

(Exact Codex CLI command names verified against `openai/plugins` upstream during plugin scaffolding - confirm with `codex plugin --help` if your Codex version is older.)

## What's inside

- 10 skills mirroring [`valara-claude-plugin`](https://github.com/Jakepawl/valara-claude-plugin) (the canonical source)
- `.mcp.json` pointing at the hosted Valara MCP server at https://valara.si
- Codex-specific `.codex-plugin/plugin.json` + `.agents/plugins/marketplace.json` manifests

The plugin is a thin wrapper. Rich agent guidance ships server-side via `_assistant_hint` on tool responses, so updates land via the Valara backend - no plugin re-install needed.

## Relationship to the Claude plugin

This repo's `skills/` directory is auto-synced from [`valara-claude-plugin`](https://github.com/Jakepawl/valara-claude-plugin/tree/main/skills) (the canonical source). Manifests + Codex CLI specifics are unique to this repo. See `scripts/sync-from-claude-plugin.sh`.

## License

MIT - see [LICENSE](./LICENSE).

## Maintainer

[Jacob Allen Media](https://valara.si) - support@jacoballenmedia.com
