# iOS Home Screen Plan Session — 6 Phases Scoped

**Date:** 2026-06-09 10:18  
**Component:** [iOS] Home screen (MoMorph `OuH1BUTYT0`)  
**Status:** Planning completed, ready for takumi execution  

## Summary

Planned a complete iOS Home screen blueprint over one session. Fetched 15 spec items + 32 test cases in parallel via `mcp-curl.sh` fallback. User confirmed 4 architectural decisions (TabView root, Protocol-based services, forward-shifted event date, 11 stub destinations). Mid-plan constraint added: all Figma icons must export as PDF (vector format). Deliverable: 6-phase plan with Track A (UI, background agents) and Track B (mock service layer, integration) running concurrently. No code written; all 19 clarifications captured.

## Decisions Made

- **TabView + NavigationStack per tab:** Root architecture avoids tab switching state loss.
- **Protocol + FakeService layer:** Awards, Kudos, Notifications injected at runtime; swappable for real APIs.
- **Event date forward-shift to 26/12/2026:** Countdown logic testable without waiting for real dates.
- **11 stub destination views:** Profile, Leaderboard, Redeem, etc. — one-liners now, full plans per screen later.
- **SVG→PDF asset pipeline via librsvg:** `rsvg-convert` ensures high-res vector exports from Figma. One-time `brew install` in Phase 2.

## Insights

1. **Plan-mode MoMorph rule held.** Phase 4 (Home UI) stayed at 26 lines — only screen ref + integration contract. `momorph-implement-design` skill owns asset workflow at runtime.
2. **PDF asset constraint ripples backward.** Login plan's PNG extraction now needs retroactive PDF conversion. Captured as follow-up.
3. **LoadState<T> enum absorbs 4 test cases cleanly.** Single ViewModel case switch (`loading`, `empty`, `error`, `ready`) replaces multiple guard chains.
4. **Cross-plan continuity declared upfront.** Frontmatter `continues: 260608-1708-ios-login` makes supersession explicit vs. re-deriving at takumi-time.
5. **Constraint mid-plan forced early tooling decision.** PDF rule landed after Phase 1 scoping — flexed Phase 2 to precheck librsvg availability rather than deferring asset work.

## Follow-ups

- **Retroactive Login PDFs:** Re-extract Login assets (Phase 1) as PDFs; validate rsvg-convert consistency.
- **Librsvg one-time install:** Phase 2 precheck ensures `brew install librsvg` before first PDF export.
- **Per-destination plans:** Leaderboard, Profile, Redeem, WriteKudo, Search, Notifications — each becomes a separate MoMorph plan as designs land.
