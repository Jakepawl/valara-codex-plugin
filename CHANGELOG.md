# Changelog

## [0.1.3] - 2026-10-22

### Changed
- Platform host moved from valara.cloud to valara.si: MCP server URL is now `https://valara.si/api/v1/mcp` (`.mcp.json` and the plugin manifest), and all links, homepage and onboarding text use valara.si. valara.cloud still answers, but a connector added here now authorizes against valara.si, so existing users are asked to sign in again after updating the plugin.

## [0.1.2] - 2026-07-06

### Fixed
- MCP server URL repointed from the legacy `https://valara.cloud/api/v1/mcp/api` transport (removed server-side 2026-06-23) to the canonical `https://valara.cloud/api/v1/mcp` in `.mcp.json`. Mirrors valara-claude-plugin 0.1.2.

## [0.1.0] - 2026-05-27 (unreleased)

### Added
- Initial plugin manifest + .agents/plugins/marketplace.json + .mcp.json pointing at https://valara.cloud
- 10 skill skeletons mirrored from valara-claude-plugin (canonical source)
- Sync script (scripts/sync-from-claude-plugin.sh)
- Local pre-push git hook (`.githooks/pre-push`) running line-limit + forbidden-phrase + manifest-validation + mirror-integrity gates
- `scripts/install-hooks.sh` (one-time setup pointing git at `.githooks/`)
- MIT license

### Architecture
- Thin-skeletons-public, rich-content-server-side per the IP-protection design (see valara-claude-plugin/README for the canonical explanation)
