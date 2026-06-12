# Phase 03 — Integration (Track B)

**Status: COMPLETE**

**Screen:** `[iOS] Award_Top project`
**Clarifications:** ./clarifications.md

## Goal
Wire Phase 01 (UI) + Phase 02 (data) together via `AwardsTopViewModel`. The new ViewModel matches the `HomeViewModel` pattern: protocol-injected `AwardsService`, `LoadState<[Award]>` for the list, `@Published` selected award.

## Tasks
1. Create `Features/Awards/AwardsTopViewModel.swift`:
   - `@MainActor final class AwardsTopViewModel: ObservableObject`
   - `@Published private(set) var awardsState: LoadState<[Award]> = .idle`
   - `@Published var selectedAwardID: Award.ID? = nil`
   - Computed `selectedAward: Award?` derived from awardsState.success + selectedAwardID
   - `init(awardsService: AwardsService = FakeAwardsService())`
   - `func load() async` — fetch awards, set state, default selectedAwardID to "Top Project" if present (else first)
   - `func selectAward(_ id: Award.ID)` — update selectedAwardID
   - `func retry()` — re-trigger load
2. Update `Features/Awards/AwardsTabView.swift`:
   - `@StateObject private var viewModel: AwardsTopViewModel`
   - Switch on `viewModel.awardsState` to show loading / error / success
   - In success, render the UI tree from Phase 01 bound to `awards = state.value`, `selectedAward = viewModel.selectedAward`, `onSelectAward = { viewModel.selectAward($0.id) }`
   - Pull-to-refresh or retry button for error state (match Home's UX)
3. xcodebuild verification

## Files
- Create: `Features/Awards/AwardsTopViewModel.swift`
- Modify: `Features/Awards/AwardsTabView.swift`

## Success criteria
- [x] xcodebuild succeeds — DEBUG on iPhone 17 / iOS 26.1 green.
- [x] Awards tab loads → spinner → 3 awards visible — AwardsTabView switch on LoadState shows loading/success branches.
- [x] Dropdown Menu lists 3 awards; selecting one updates Info Block fields (TC_FUN_002) — AwardHighlightBlock Menu + selectAward callback wired.
- [x] Selection persists during tab session; resets on app relaunch (acceptable per implicit default) — selectedAwardID @Published property behavior.
- [x] Error state shows retry button; tapping reloads — LoadState.error branch + retry() method in ViewModel.

## Risks
- Selection state racing with load: if user taps dropdown before load completes, Menu should be disabled. Mitigation: only render dropdown in success branch. **RESOLVED:** AwardsTabView renders Menu only inside LoadState.success branch.

## Test cases coverage (manual)
- ACC_001, ACC_002, ACC_003: covered by existing auth gate (AppRoot) + MainTabView Awards tab — no new work.
- ACC_004 + FUN_001 + FUN_002: covered by Menu + ViewModel.selectAward + Info Block re-render.
- GUI_001 + GUI_002: covered by layout + default selection.
- FUN_003 + FUN_004: covered by ScrollView + TabView frame ownership.

## Notes
AwardsTopViewModel created with LoadState<[Award]> + selectedAwardID. AwardsTabView updated with @StateObject viewModel + switch on awardsState. AwardsTabViewContainer introduced to forward TokenStore to ViewModel (mirrors HomeViewContainer pattern). Nil selectedAward gracefully shows placeholder text instead of crashing. All 10 TCs traceable to UI/ViewModel behavior.
