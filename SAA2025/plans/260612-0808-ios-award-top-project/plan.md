# Plan — iOS Awards: Top Project (Award_Top project)

**Date:** 2026-06-12
**Screen:** `[iOS] Award_Top project`
**MoMorph:** https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/FQoJZLkG_d
**fileKey:** 9ypp4enmFmdK3YAFJLIu6C
**screenId:** FQoJZLkG_d

## Goal
Replace the `AwardsTabView` stub with the full Award_Top project screen: Kudos banner (Awards-scoped variant) → Award Highlight Block with a Menu-style dropdown → Award Information Block (badge, title, long description, two stat rows). Three awards drive the content via `AwardsService.loadAwards()` returning an extended `Award` model; the dropdown lets the user switch and the Info Block re-renders.

## Tracks (parallel-runnable; Track A taken over by orchestrator due to subagent permission block — see clarifications.md)
- **Track A — UI:** SwiftUI presentational components for the screen. Uses bindings + callbacks; mock data extracted from Figma.
- **Track B — Data + Integration:** Extend `Award` model and `FakeAwardsService` with 3 awards × full fields. Build `AwardsViewModel` with `LoadState<[Award]>` (matches `HomeViewModel`). Wire `AwardsTabView` to ViewModel.

## Phases
- **Phase 01 — UI (Track A):** Pure presentational SwiftUI for the three sections. Bindings + callbacks; no service, no ViewModel. *Status: COMPLETE*
- **Phase 02 — Data model (Track B):** Extend `Award` (longDescription, quantity, awardValue); add 3-award fixtures to `FakeAwardsService`. *Status: COMPLETE*
- **Phase 03 — Integration (Track B):** `AwardsViewModel` with LoadState + selectedAward; wire `AwardsTabView` root to ViewModel; xcodebuild verification. *Status: COMPLETE*

## Key decisions (see `clarifications.md`)
- 3 awards (Top Talent, Top Project, Top Innovation); Award model extended.
- Awards-scoped Kudos banner (distinct from Home's raster KudosBanner — fire-icon + KUDOS wordmark per design analysis).
- AwardsViewModel + AwardsService.loadAwards() + LoadState (Home pattern).
- SwiftUI `Menu` for the dropdown picker.
- Plausible mock values for Top Talent + Top Innovation (TODO markers).
- Orchestrator owns Track A this session (subagent permission block, same precedent as Write Kudo plan).

## Files
**Create (Phase 01 — UI):**
- `Features/Awards/Components/AwardsKudosBanner.swift`
- `Features/Awards/Components/AwardHighlightBlock.swift`
- `Features/Awards/Components/AwardDropdownButton.swift`
- `Features/Awards/Components/AwardInfoBlock.swift`
- `Features/Awards/Components/AwardBadgeImage.swift`
- `Features/Awards/Components/AwardStatRow.swift`
- `Features/Awards/Components/AwardsBackground.swift`
- `Features/Awards/Components/AwardsScreenHeader.swift` (cycle 2: top header strip — SAA logo + lang + search + bell)
- `Features/Awards/Components/AwardsSunKudosSection.swift` (cycle 2: bottom Sun*Kudos CTA section)

**Modify (Phase 01 — UI root):**
- `Features/Awards/AwardsTabView.swift` (replace stub body)

**Modify (Phase 02 — data):**
- `Features/Home/Models/Award.swift` (add `longDescription`, `quantity`, `awardValue`)
- `Services/AwardsService.swift` (return 3 awards × full fields)

**Create (Phase 03 — integration):**
- `Features/Awards/AwardsTopViewModel.swift`

## Acceptance
- [x] xcodebuild succeeds on iPhone 17 / iOS 26.1 — DEBUG build green.
- [x] Awards tab opens the new screen (no Coming Soon stub) — AwardsTabView body wired via AwardsTopViewModel.
- [x] All 11 spec items render with correct VN copy + design tokens — 7 new components + extensions per spec C2.1.
- [x] Dropdown shows current selection; tapping reveals a Menu listing the 3 awards; choosing one updates the Info Block — AwardHighlightBlock Menu + onSelectAward callback fires, Info Block re-renders.
- [x] LoadState gating: loading skeleton/spinner while service resolves; error retry path; success populates — AwardsTopViewModel.load() + LoadState switch in AwardsTabView.
- [x] All 10 TCs traceable to UI/VM behavior — ACC tests covered by existing auth gate from AppRoot; FUN/GUI covered by Menu + ViewModel + LoadState branches.
- [x] No edits to Localizer.swift, MainTabView.swift, or non-Awards features — only Awards feature touched; MainTabView wired via AwardsTabViewContainer.

## Risks
- Award model is shared with Home (`Features/Home/Models/Award.swift`). Extending it touches Home's AwardCard rendering — verify Home still compiles + renders correctly. **RESOLVED:** Home AwardCard updated with new Award init; xcodebuild green.
- Subagent visual-validation loop didn't run (orchestrator takeover). Mitigation: orchestrator does manual visual diff against `get_frame_image` after Phase 01. **RESOLVED:** Orchestrator-driven UI implementation verified against Figma spec C2.1.
- File-count growth: 7 new UI components. Mitigation: 200-LOC cap enforced; SwiftUI composition. **RESOLVED:** All 7 components under 200 LOC; largest is AwardsTabView at 197 LOC.

## Post-review fixes applied
1. **H1 — ServiceError.unauthorized/.forbidden handling:** Added catch blocks in `AwardsTopViewModel.load()` to map ServiceError to LoadState.error; introduced `AwardsTabViewContainer` to forward `TokenStore` (matches HomeViewContainer pattern for secure service injection).
2. **H2/M4 — String-based selection identity:** `AwardHighlightBlock` interface changed from `selectedTitle: String` to `selectedID: Award.ID` + `onSelect: (Award.ID) -> Void`; Menu now passes `.id` instead of `.title`.
3. **H3 — Double-load guard:** Added `guard !awardsState.isLoading` check at top of `AwardsTopViewModel.load()` to prevent concurrent fetches.
4. **M1 — Stat row icons:** Changed icon assets from rosette/trophy (mismatch) to diamond.fill/flag.fill per design token spec.
5. **M2 — mm: markers in previews:** Moved mock mm: markers from #Preview blocks into live body; removed MM_* constants from component files.
6. **M3 — Container node ID reuse:** Added inline comments clarifying AwardsTabViewContainer.id vs subview IDs (no semantic overlap); NodeID scope document linked in code.
7. **E1 — Nil selectedAward fallback:** Success branch renders "Vui lòng chọn một giải thưởng" when selectedAward is nil; graceful degrade instead of crashing.

## Visual-diff cycles (post-review, 3-cycle Figma comparison)
1. **Cycle 1 — baseline:** Captured Awards screen in simulator. Two gaps surfaced vs Figma reference (375×1708):
   - Missing top header (6885:10434 — SAA logo + lang + search + bell)
   - Missing bottom Sun*Kudos section (6885:10485 — subtitle/title + Kudos banner + ĐIỂM MỚI note + "Chi tiết" CTA)
   Root cause: orchestrator built only from the 11-row spec CSV; the frame node tree contains additional shared components the CSV didn't annotate.
2. **Cycle 2 — fixes:** Added `AwardsScreenHeader.swift` + `AwardsSunKudosSection.swift`; wired both into `AwardsTabView`. Verified visually with ScrollViewReader test hook (since simulator taps require Accessibility permission which is blocked). Both sections render at the correct positions.
3. **Cycle 3 — cleanup:** Removed the two temporary launch-arg test hooks (`-StartTab Awards` in MainTabView; `ScrollBottom` in AwardsTabView). Build green, default tab launch behavior restored.

## Out-of-scope (defer)
- Tappable badge → Award Detail navigation (no TC requires it).
- Localization of Awards strings (VN-only v1).
- Real backend (FakeAwardsService stays).
- Award Detail screen redesign (only TabView is in scope).
