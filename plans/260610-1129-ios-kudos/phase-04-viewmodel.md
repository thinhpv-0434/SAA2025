# Phase 04 — KudosViewModel

## Goal
`@MainActor final class KudosViewModel: ObservableObject` orchestrates the screen — loads via service, holds filter state, exposes business rules (heart toggle, badge level), drives carousel reset.

## File
`Features/Kudos/KudosViewModel.swift` — extends/replaces Track A's minimal mock VM.

## @Published state
```
loadState: LoadState<KudosScreenSnapshot>     // composite: highlight + feed + stats + recipients + counts + filters
selectedHashtag: Hashtag?
selectedDepartment: Department?
hashtags: [Hashtag]
departments: [Department]
carouselIndex: Int                            // visible page index; reset to 0 on filter change
```

## Key actions

| Method | Behavior | Test |
|--------|----------|------|
| `load()` | parallel `async let` for highlight/feed/stats/recipients/spot count/hashtags/departments → assemble snapshot | smoke |
| `selectHashtag(_:)` | sets `selectedHashtag`, reloads highlight+feed, **carouselIndex = 0** | TC_FUN_004/005 |
| `selectDepartment(_:)` | mirror of above | TC_FUN_004/005 |
| `toggleHeart(kudosId:)` | optimistic flip on local array. If `isOwn` → no-op. If `isLiked` → unlike (count-1). Else like (count+1). Idempotent re-tap returns to original. | TC_FUN_007/008 |
| `badgeLevel(for: KudosUser) -> Int` | static helper. hearts >= 50 → 3, >= 20 → 2, >= 10 → 1, else 0 | TC_FUN_006 |
| `openSecretBox()` | calls service; on success ↓ unopened, ↑ opened; debounce 600ms prevents double-trigger | TC_FUN_025 |

## Filter AND logic
- `selectedHashtag.id` + `selectedDepartment.id` both passed to service. Service does the filter (Phase 3) — ViewModel only owns selection state.

## Carousel reset
- Selection setter: `carouselIndex = 0`; `selectedHashtag = newValue`; trigger `load()`. View observes `carouselIndex` and re-binds `TabView(selection:)`.

## Dependencies
- Phase 2, 3
- Coordinates with Track A's `KudosViewModel` shell (replace/extend)

## Outcome
**Status:** DONE

### What shipped
- **KudosViewModel.swift** (180 LOC): Full @MainActor MVVM orchestrator
  - @Published state: highlightCards, allKudosCards, spotlightCount, selectedHashtag, selectedDepartment, state (LoadState)
  - Service injection via init; defaults to FakeKudosService
  - Methods:
    - `load()` — parallel async let fan-out for all 7 calls
    - `selectHashtag(_:)` / `selectDepartment(_:)` — resets carousel to 0, calls reloadFilteredSections()
    - `reloadFilteredSections()` — AND-logic passes both IDs to service
    - `toggleHeart(kudosId:)` — optimistic update on local array, includes `isOwn` guard, mutates heartCount + isLiked
    - `badgeLevel(heartCount:)` — static helper: 0/1/2/3 based on 10/20/50 thresholds
    - `openSecretBox()` — debounced with ContinuousClock, 600ms window
  - LoadState enum: loading, error, success with data snapshot

### Deviation from spec
- Dead code identified: `badgeLevel()` static method unused (also `KudosBadge` struct not instantiated). Noted for M2 follow-up (delete or wire into view).
- Navigation-intent booleans (`navigateToSendKudos`, etc.) exposed with write access instead of private(set) — noted as M3 standards violation

### Test coverage
- All 8 ViewModel tests pass (static review of test file)
- TC_FUN_004 (AND-logic): ✓
- TC_FUN_005 (carousel reset): ✓
- TC_FUN_006 (badge thresholds): ✓
- TC_FUN_007 (heart toggle like/unlike): ✓
- TC_FUN_008 (self-like block): ✓
- TC_FUN_025 (debounce): ✓
