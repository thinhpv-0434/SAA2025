# Phase 1 — Fetch MoMorph data + clarify

**Status:** ✅ done
**Priority:** P0 (blocking)

## Goal
Pull all MoMorph data for screen `8HGlvYGJWq` and resolve spec/test-case gaps with user.

## What happened
- MoMorph MCP tools unavailable in Claude Code session despite server connected → fallback to raw HTTPS JSON-RPC via `mcp-curl.sh`.
- Parallel-fetched via curl:
  - `get_frame` → screen meta (name: `[iOS] Login`)
  - `get_overview` → layout tree (3-level)
  - `download_specs` → 6 spec items, CSV
  - `download_test_cases` → 20 test cases, CSV
  - `list_media_nodes` → 5 media nodes with role hints
  - `get_media_files` → 6 signed S3 URLs (2 nodes had null URLs — VN flag, dropdown arrow)
  - `get_frame_image` → 375×812 preview PNG
- Asset downloader pulled the 6 PNG/SVG files (re-fetched URLs after S3 10-min expiry).
- Assets reorganized into iOS Asset Catalog imagesets: `KeyvisualBG`, `SunAALogo`, `RootFurtherLogo`, `GoogleGLogo`.
- 11 clarification questions resolved in `clarifications.md`.

## Outputs
- `data/frame.json`, `data/overview.json`, `data/specs.csv`, `data/test-cases.csv`
- `data/media-nodes.json`, `data/media-files.json`, `data/preview.png`, `data/assets.md`
- `clarifications.md`
- `SAA2025/Assets.xcassets/{KeyvisualBG,SunAALogo,RootFurtherLogo,GoogleGLogo}.imageset/`

## Key decisions (full set in clarifications.md)
- MVVM + SwiftUI, iOS 16+
- Stub OAuth + stub HomeView + Keychain deferred to UserDefaults
- Defer i18n (VN only)
- Missing flag/chevron → Unicode flag + SF Symbol

## Tooling note
`mcp-curl.sh` helper at `.claude/skills/momorph-implement-design/scripts/` wraps JSON-RPC calls. Kept for future MoMorph fetches if MCP layer remains broken.
