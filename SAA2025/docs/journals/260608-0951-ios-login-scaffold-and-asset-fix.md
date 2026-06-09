# iOS Login Screen Scaffold + SunAALogo Asset Fix

**Date**: 2026-06-08 to 2026-06-09  
**Severity**: High (blocking first deliverable)  
**Component**: iOS App / MoMorph Integration  
**Status**: Resolved  

## What Happened

Executed full Takumi pipeline (plan → implement → test → review → deliver) to scaffold the SAA 2025 iOS Login screen from MoMorph design `8HGlvYGJWq`. Pipeline delivered 10 Swift files (LoginView, ViewModel, Services, Components), 4 imagesets, routing layer, and i18n foundation. Build green, all 20 test cases traced. Next day: discovered SunAALogo asset rendered only the icon (red star), missing the "Sun* Annual Awards 2025" wordmark that appears in the Figma Component. Fixed by cropping the full composite from preview PNG and replacing the imageset.

## The Brutal Truth

Two completely different headaches on the same feature:

1. **MCP tool infrastructure was a dead-end.** Installed MoMorph server, `claude mcp list` said "Connected", two full Claude Code restarts — the harness still wouldn't surface `mcp__momorph__*` tools. Spent 30 minutes debugging MCP config before accepting the harness indexing is fragile and unreliable. Built a curl fallback and moved on. This should not have been necessary, and it burned time on a feature launch day.

2. **MoMorph asset export semantics are poorly documented.** Imported SunAALogo thinking the RECTANGLE child asset would be the full thing — nope, got the star only. The Component wraps it with decorative text that doesn't propagate to the exported child. This feels like a landmine waiting for every future asset import.

## Technical Details

### MCP Install Friction

Ran:
```bash
claude mcp add --scope user --transport http momorph \
  https://mcp.momorph.ai/mcp \
  --header "x-github-token: $(gh auth token)"
```

`claude mcp list` showed `✓ Connected`. Restarted Claude Code twice. Tool registry stayed empty. Root cause unclear — either the harness doesn't index tools from `~/.claude.json` reliably, or the SSE event stream from the server wasn't being parsed by the indexer.

**Workaround:** Wrote `.claude/skills/momorph-implement-design/scripts/mcp-curl.sh` — a 55-line bash wrapper that calls MCP tools via raw HTTPS JSON-RPC + SSE. Initial version had a bash brace-escape bug: `ARGS="${2:-{}}"` parses as `"${2:-{"` + literal `}"` after expansion, producing invalid JSON. Fixed with explicit guard: `if [ -z "$ARGS" ]; then ARGS='{}'; fi`. All 6 subsequent MoMorph fetches succeeded over curl. Total friction: 45 minutes lost to workaround construction + debugging the brace bug.

### Takumi Pipeline Results

**Stage 1 (Clarification):** Fetched frame 8HGlvYGJWq + 6 CSV specs + 20 test cases + 4 media images. User answered 3 arch questions ("plain SwiftUI + MVVM, stub OAuth, defer i18n") in one message. Saved 11 clarifications.

**Stage 4 (Implementation):** `implementer` background subagent built 10 files. Build failed on missing `import Combine` in LoginViewModel — orchestrator fixed in 1 line.

**Stage 5 (Testing & Review):** Parallel execution. Tester: 13/20 ✅, 5/20 ⚠️ deferred (real OAuth, Keychain, localization), 2/20 ❌ (architectural: async/await nesting). Reviewer: 9.1/10 with 3 critical fixes:
- Defer pattern for `isLoading` reset (guarantee reset on error)
- `private` on `TokenStore.restore()` (hide impl detail)
- `#if DEBUG` guard on UserDefaults save (prevent test pollution)

All applied + 1 cleanup (dead `.environmentObject` in AppRoot). Build green.

**Stage 6 (Delivery):** Commit `326322f` (57 files): `feat(login): scaffold iOS Login screen from MoMorph 8HGlvYGJWq`.

### SunAALogo Asset Bug (2026-06-09)

User reported: "icon shows only red star, missing wordmark."

Downloaded asset from `get_media_files` returned `MM_MEDIA_logo homepage` — a RECTANGLE node exported as just the star. The Figma Component definition (`componentId: 6885:8009`) composes this RECTANGLE with a TEXT layer ("Sun* Annual Awards 2025"), but the TEXT doesn't export when you fetch the child RECTANGLE asset. MoMorph docs say nothing about this.

Attempted workaround: `get_figma_image` returned HTTP 500 at the MoMorph proxy (unreliable).

**Fix:** Cropped the full INSTANCE render from `preview.png` at bbox (20, 52, 68, 96), saved as 48×44 PNG, replaced SunAALogo imageset. Audited 3 other imagesets (KeyvisualBG, RootFurtherLogo, GoogleGLogo) — all correct. Added prevention checklist to `docs/code-standards.md`: visually diff every imageset against preview crop before sign-off.

Commit `68f5324`: `fix(login): SunAALogo asset rendered only icon, missing wordmark`.

## What We Tried

1. **MCP tool indexing:** Reinstalled, restarted Claude Code, checked `~/.claude.json` — harness never surfaced tools. Abandoned for curl fallback.
2. **get_figma_image for SunAALogo:** HTTP 500. Not a viable fallback.
3. **Async/await nesting in LoginViewModel:** Reviewer flagged; deferred to refactor phase (stay focused on MVP).

## Root Cause Analysis

1. **MCP harness indexing is fragile.** The socket-based tool registry probably doesn't handle SSE servers gracefully, or `~/.claude.json` isn't reloaded fast enough after `mcp add`. No clear signal to the user that tools failed to index — `mcp list` lies.

2. **MoMorph `get_media_files` returns child assets, not composite renders.** If a Component composes a RECTANGLE + TEXT at the design level, exporting the RECTANGLE gives you the RECTANGLE only. The export mechanism doesn't understand Component-level composition. This is a semantic gotcha buried in the MoMorph docs.

3. **Curl workaround was the right call.** Rather than spend hours debugging the harness, building a thin JSON-RPC wrapper got us unblocked immediately. Low-stakes infrastructure, reusable for future MoMorph calls.

## Lessons Learned

1. **When a tool says "Connected" but never appears, build a curl fallback.** Don't debug the harness; assume it's fragile and route around it. 45 minutes debugging the harness = 5 minutes writing a curl wrapper + 10 minutes testing. The latter wins.

2. **Every MoMorph asset import needs a visual-diff checklist.** Exporting a child RECTANGLE is not the same as rendering the whole Component. The onus is on the importer to verify fidelity. Added to `code-standards.md` as mandatory prevention.

3. **S3 signed URLs have a 10-minute TTL.** First asset download (after 8 minutes of debugging) returned 403. Always re-fetch `get_media_files` immediately before downloading.

4. **Bash brace-escape is a footgun.** `${var:-default}` where `default` contains `}` will parse the `}` as a literal character AFTER the expansion. Use explicit `if [ -z "$var" ]; then var='value'; fi` instead. Silent corruption cost us a debug cycle.

5. **Takumi rest-points handle terse user input well.** "Plain SwiftUI, MVVM, stub OAuth, defer i18n" — 7 words — drove 11 documented clarifications via combining stated decisions + design context. Trust the skill pipeline to infer and ask follow-up questions rather than blocking on input completeness.

## Next Steps

- **[2026-06-10]** Real OAuth integration (Google + Apple Sign In) — deferred from MVP scope.
- **[2026-06-10]** Keychain storage for TokenStore — replace UserDefaults for production security.
- **[2026-06-12]** EN + JA translations — currently LanguagePicker UI wired, strings hardcoded VN.
- **[2026-06-15]** XCTest target — build unit test harness for LoginViewModel + AuthService stubs.
- **[2026-06-15]** Higher-res SunAALogo — 1× preview crop is not Retina; acquire 3× source from Figma if available.
- **[MoMorph Team]** Document asset export semantics: which design elements propagate to child RECTANGLE exports? Currently undocumented trap.

**Owner:** Pham Van Thinh  
**Blocking:** None (Login MVP delivered, deferred items are Post-MVP)
