# Changelog

## [0.1.0] - 2026-05-27 (unreleased)

### Added
- Initial plugin manifest + .agents/plugins/marketplace.json + .mcp.json pointing at https://valara.cloud
- 10 skill skeletons mirrored from valara-claude-plugin (canonical source)
- Sync script (scripts/sync-from-claude-plugin.sh)
- CI workflow with line-limit + forbidden-phrase + manifest-validation gates
- MIT license

### Architecture
- Thin-skeletons-public, rich-content-server-side per the IP-protection design (see valara-claude-plugin/README for the canonical explanation)
