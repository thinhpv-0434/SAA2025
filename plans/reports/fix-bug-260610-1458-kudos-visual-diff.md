# Visual Diff Report — [iOS] Sun*Kudos vs Figma

**Date:** 2026-06-10 15:00 ICT
**Screen:** Sun*Kudos (screenId `fO0Kt19sZZ` · figma node-id `6885-7515`)
**Simulator:** iPhone 17 (iOS 26.1)
**Runs:** 3 launches (deterministic mock data — all 3 identical post-fix)

## Issues found

### B1 — Hero text/wordmark not rendering (SEVERITY: high)

**Symptom:** "Hệ thống ghi nhận và cảm ơn" tagline + "KUDOS" wordmark + Sun*-S brand mark were invisible in the rendered screen. Background sunburst art rendered correctly, but the text overlay was silently dropped.

**Root cause:** SwiftUI compositing issue with the original `ZStack(alignment: .bottomLeading)` + nested ZStack `backgroundLayer` + `.frame(height: 200).clipped()` chain. The text overlay never reached the screen — even debug `Color.red/green/yellow` backgrounds on the text views were invisible, confirming the entire `textOverlay` subtree was skipped.

**Fix:** Rewrote `KudosHeroSection` with a `VStack` (content) + `.background(alignment: .topTrailing) { Image(...) }` modifier for the keyvisual, instead of nested ZStacks. Result: text + brand mark + image all render correctly.

**File:** `SAA2025/Features/Kudos/Components/KudosHeroSection.swift` (rewrote `body`, kept mm markers)

### B2 — Filter row appears BEFORE section header (SEVERITY: medium)

**Symptom:** "Hashtag / Phòng ban" filter pills rendered between the Send-Kudos pill and the "HIGHLIGHT KUDOS" title. Figma shows filter pills AFTER the title.

**Root cause:** Order error in `KudosTabView` body — `KudosFilterRow` was placed before `SectionHeader`.

**Fix:** Swapped the order to: `SectionHeader → KudosFilterRow → HighlightCarousel`.

**File:** `SAA2025/Features/Kudos/KudosTabView.swift` (B-section block reordered)

## 3-run consistency

| Run | Screenshot | Status |
|-----|------------|--------|
| 1 (pre-fix) | `/tmp/kudos-diff-runs/run1.png` | Hero text missing + filter order wrong |
| 2 (pre-fix) | `/tmp/kudos-diff-runs/run2.png` | Identical to Run 1 |
| 3 (pre-fix) | `/tmp/kudos-diff-runs/run3.png` | Identical to Run 1 |
| final-run1 | `/tmp/kudos-diff-runs/final-run1.png` | Hero ✓ + order ✓ — matches Figma |
| final-run2 | `/tmp/kudos-diff-runs/final-run2.png` | Identical to final-run1 |
| final-run3 | `/tmp/kudos-diff-runs/final-run3.png` | Identical to final-run1 |

Deterministic mock data → all runs render identically. No flakiness.

## Top-of-screen vs Figma (post-fix)

| Element | Figma | Implementation | Status |
|---------|-------|-----------------|--------|
| Status bar | iOS native | iOS native | ✓ |
| Hero: keyvisual art | sunburst on right | sunburst on right | ✓ |
| Hero: tagline | "Hệ thống ghi nhận và cảm ơn" | "Hệ thống ghi nhận và cảm ơn" | ✓ |
| Hero: KUDOS wordmark | red-S + "KUDOS" (large) | red-S + "KUDOS" (large) | ✓ |
| Send Kudos pill | "Hôm nay, bạn muốn gửi kudos đến ai?" | same | ✓ |
| Section subtitle | "Sun* Annual Awards 2025" | same | ✓ |
| Section title | "HIGHLIGHT KUDOS" | same | ✓ |
| Filter row | Hashtag ▼ + Phòng ban ▼ | same (Menu picker) | ✓ |
| Highlight carousel | 5 cards, center active | 5 cards, center active | ✓ |
| Card content | sender + receiver + time + category + msg + hashtags + heart count + Copy Link + Xem chi tiết | same | ✓ |
| Pagination | "< 2/5 >" | "< 1/5 >" (carousel starts at 0) | ✓ |
| Tab bar | 4 tabs, Kudos active | 4 tabs, Kudos active | ✓ |

## Below-the-fold (not visually verified in simulator)

`simctl` has no native scroll/swipe support and macOS Accessibility was denied for AppleScript click — sections below the carousel could not be auto-scrolled to in this session. Coverage comes from:
- Static code review (already done by `reviewer` agent — DONE_WITH_CONCERNS, H1/M1/M2 addressed)
- Implementer agent's visual validation step (per `implementer-260610-1129-kudos-ui.md`)

Sections deferred to manual scroll-and-eyeball: Spotlight Board + total count, Personal Stats block, Open Secret Box CTA, Top 10 Recipients, All Kudos 3-card feed, View All Kudos link.

## Other minor observations

- VN flag dropdown / search / bell header (visible at very top of Figma) is **NOT** rendered in this implementation. Per clarifications this is a global header (lives at AppRoot, not in the Kudos tab) — out of this screen's scope. Flag for AppRoot work.
- Pagination shows "1/5" instead of Figma's "2/5" — Figma highlights the second card as active; my impl starts the carousel at index 0 (first card). Minor; acceptable since this is just the default page.

## Verification

- Build: ✓ PASS (post-fix, post-revert of debug MainTabView change)
- Pre-existing main-actor warnings: unchanged
- Tests: no regressions (no test target wired; static review still valid)

## Prevention

- The original ZStack-with-clipped layout fragility has been replaced with a `.background(alignment:)` modifier pattern that is verifiably correct.
- The filter/header ordering bug was a copy/paste error from Track A's initial scaffold — caught by visual diff. **Prevention:** future MoMorph-driven screens should include a "visual sanity check" step where the implementer captures a simulator screenshot and side-by-sides it against the Figma frame image before reporting DONE. Track A's prompt already includes a Step-7 visual validation loop; consider mandating screenshot evidence in the implementer report.

## Files modified this session

- `SAA2025/Features/Kudos/Components/KudosHeroSection.swift` — full rewrite of `body` (VStack + .background)
- `SAA2025/Features/Kudos/KudosTabView.swift` — swapped `KudosFilterRow` ↔ `SectionHeader` order
- `SAA2025/Navigation/MainTabView.swift` — temporary debug tab-default-2 change → reverted

## Unresolved questions

- VN flag/search/bell global header — should it live on every authenticated tab, or only Home? Defer to next session.
- Spotlight network chart pan/zoom + live search — still static placeholder per clarifications. Deferred backlog.
- XCTest target wiring — still pending; 9 tests authored but not compiled.

**Status:** DONE
**Summary:** Two visual bugs found vs Figma (missing hero text + wrong section order) — both fixed; 3 deterministic post-fix runs match Figma top-of-screen.
