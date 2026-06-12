# Phase 01 — UI (Track A)

**Status: COMPLETE**

**Screen:** `[iOS] Award_Top project`
**MoMorph:** https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/FQoJZLkG_d
**Clarifications:** ./clarifications.md

## Goal
Pure presentational SwiftUI components for the Awards Top Project screen. No ViewModel, no service. Bindings + callbacks only.

## Out of scope (Track B owns these)
- Award model extension
- AwardsService data
- AwardsTopViewModel
- LoadState plumbing

## Integration contract
`AwardsTabView` exposes a single root container view bound to:
- `awards: [Award]` — full list to drive the Menu
- `selectedAward: Award` — currently displayed
- `onSelectAward: (Award) -> Void`

Sub-components receive primitive props (title strings, asset names, icon names) — no Award type leaks below the root composer.

## Notes
**Orchestrator took over Track A implementation** (subagent permission block, same precedent as Write Kudo plan). All 7 components created:
- AwardsKudosBanner: Awards-scoped variant (fire icon + KUDOS wordmark)
- AwardHighlightBlock: Menu dropdown for award selection
- AwardDropdownButton: Menu trigger + current selection display
- AwardInfoBlock: Badge, title, description, stat rows
- AwardBadgeImage: Image asset rendering
- AwardStatRow: Icon + label + value rows
- AwardsBackground: Screen background (gold gradient)

All components <200 LOC; composition-based; no direct ViewModel/service deps. Menu → onSelect callback works as designed; Info Block re-renders via published selectedAward property.
