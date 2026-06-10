# Code Review — iOS Sun*Kudos Screen
Date: 2026-06-10 | Reviewer: reviewer agent

---

## Scope

| | |
|---|---|
| Files | 19 (11 components + VM + TabView + 5 models + KudosService + KudosFixtures + Localizer + MainTabView) |
| LOC | ~1,693 across reviewed files |
| Focus | Code standards, architecture, correctness (TC_FUN_004–008, 025), security, MoMorph markers, YAGNI |

---

## Overall Assessment

Solid, well-structured implementation. MVVM pattern is consistent, protocol-first services are correct, no force-unwraps or secrets. Three medium-priority issues need attention before merge: a duplicate `NumberFormatter` (DRY violation), missing `LoadState` branch handling in the view (no loading/error UI shown), and `KudosViewModel.badgeLevel()` being dead code. One minor naming violation on nav-intent properties.

---

## Scores by Dimension

| Dimension | Score | Notes |
|---|---|---|
| Code Standards | 8/10 | One file over 200 LOC; nav-intent `@Published` missing `private(set)`; unused Combine import |
| Architecture | 8/10 | LoadState not rendered in view; duplicate formatter breaks DRY |
| Correctness (TC) | 9/10 | All 5 TCs pass logic check; one dead-code concern on `badgeLevel` |
| Security | 10/10 | No secrets, no force-unwraps, no try!, errors surface via LoadState |
| MoMorph markers | 9/10 | All major sections covered; two minor non-canonical marker formats |
| YAGNI/KISS/DRY | 7/10 | Duplicate NumberFormatter; `KudosBadge` struct defined but never used |

---

## Critical Issues

None.

---

## High Priority

### H1 — `KudosTabView` never renders `LoadState` branches (no loading / error UI)
**File:** `KudosTabView.swift` (entire `body`)

`KudosViewModel.state` is `@Published private(set) var state: LoadState<Void>` and is set to `.loading` / `.error(...)` in `load()` and `reloadFilteredSections()`. The view calls `.task { await viewModel.load() }` but never switches on `viewModel.state`. The screen renders its full content even while the initial load is in progress, and errors are silently swallowed from the user's perspective.

Every other ViewModel in the project (HomeViewModel) renders LoadState branches. This breaks the established pattern and violates the system-architecture contract.

**Fix:** wrap `body`'s inner content in a `switch viewModel.state` (or `if case .loaded` guard) that renders a `ProgressView` while `.loading` and a `.alert` or error banner when `.error`.

---

## Medium Priority

### M1 — Duplicate `NumberFormatter` (DRY violation)
**Files:** `KudosHighlight.swift:84–92` and `KudosFixtures.swift:104–113`

Two identical `static let` `NumberFormatter` instances exist: `KudosCardData.heartFormatter` (in model extension) and `KudosFixtures.groupingFormatter` (in fixtures). Both configure `.groupingSeparator = "."` and produce the same output. Only one should exist.

`KudosFixtures.formatThousands(_:)` is already public. Preferred fix: delete `KudosCardData.heartFormatter` / `formatHeartCount` and call `KudosFixtures.formatThousands(newCount)` inside `withLikeToggled()`. Alternatively, extract a shared `NumberFormatters.dotGrouped` constant in a new `Formatters.swift`.

### M2 — `KudosViewModel.badgeLevel(heartCount:)` is dead code (YAGNI)
**File:** `KudosViewModel.swift:174–180`

`static func badgeLevel(heartCount:) -> Int` returns an `Int` that is never called anywhere in the codebase. The threshold logic is also implemented — correctly — as `KudosBadgeTier.init(heartCount:)` in `KudosHighlight.swift:29–33`, and the `KudosBadge` struct (`KudosHighlight.swift:38–41`) is defined but never instantiated either.

Either: (a) delete `badgeLevel` and `KudosBadge` if they are not needed, or (b) wire `badgeLevel`/`KudosBadge` into `KudosCard`'s star display so the star count is driven by computed tier rather than a hardcoded `badgeLabel` string.

### M3 — Navigation-intent `@Published` properties lack `private(set)` (standards violation)
**File:** `KudosViewModel.swift:40–43`

```swift
@Published var navigateToSendKudos: Bool = false
@Published var navigateToKudosDetail: Bool = false
@Published var navigateToViewAll: Bool = false
@Published var navigateToOpenSecretBox: Bool = false
```

The view writes directly to these (`viewModel.navigateToSendKudos = true`), which bypasses the `@Published private(set)` rule in `code-standards.md`. The pattern seen in `HomeViewModel` is that mutations go through a VM method. Either expose setter methods (`func openSendKudos()`) and add `private(set)`, or document the exception inline.

---

## Low Priority

### L1 — Unused `import Combine` in KudosViewModel
**File:** `KudosViewModel.swift:7`

`Combine` is imported but zero Combine APIs (`AnyCancellable`, `sink`, `Publisher`) are used. The implementation is pure `async/await`. Remove the import to keep the dependency surface clean.

### L2 — `KudosCard.swift` is 228 LOC, exceeds 200-line limit
**File:** `KudosCard.swift` (228 lines)

28 lines over the 200-LOC standard. The `headerRow` + `userBlock` + `contentArea` + `hashtagRow` + `actionRow` structure is already well decomposed within the file. Splitting `headerRow` (lines 58–117) or `actionRow` (lines 159–207) into their own `KudosCardHeader.swift` / `KudosCardActionRow.swift` would bring the main file under limit.

### L3 — `badgePill` color is driven by `isSender` flag, not `KudosBadgeTier`
**File:** `KudosCard.swift:107–117`

`badgePill(label:isSender:)` colors "Rising Hero" with `badgeRising` when `isSender == true` and `badgeLegend` when `false`. This is coincidentally correct for the fixture data (sender has `.one`, receiver has `.two`) but will break if a receiver ever has a lower tier badge or a sender has a higher one. Should use `user.badgeTier` to select the color.

### L4 — Hardcoded `spotlightTotalCount` literal in `FakeKudosService`
**File:** `KudosService.swift:101`

`return 388` — move this into `KudosFixtures` (e.g., `KudosFixtures.spotlightCount = 388`) to keep all fixture data in the single source of truth file. Minor but inconsistent with the stated "single source of mock truth" goal.

### L5 — `SunBrandSShape` imported from `Features/Home/` in a Kudos component (cross-feature dependency)
**File:** `KudosHeroSection.swift:73`

`SunBrandSShape` is defined under `Features/Home/Components/`. `KudosHeroSection` directly references it. This creates an implicit cross-feature dependency. In the current single-module layout this compiles fine, but if features are ever modularised it will break. The shape should live in a shared `Components/` or `DesignSystem/` folder, or be duplicated.

---

## Edge Cases Found

### E1 — `openSecretBox()` debounce races with navigation flag
**File:** `KudosViewModel.swift:149–168`

When `openSecretBox()` succeeds it sets `navigateToOpenSecretBox = true`. If the user dismisses the sheet and immediately taps again within 600 ms, the debounce guard fires (`now - last < boxOpenDebounce → return`), so the service is not called, but the flag is already `false` (sheet was dismissed). Correct behaviour — no bug. However, if the sheet is dismissed and the box count update has not yet been reflected (race with `.task` reload), the count could transiently show `>0` while `secretBoxUnopened` was already decremented locally. This is consistent with the local-state approach agreed in clarifications; noting for awareness.

### E2 — `reloadFilteredSections()` errors set `state = .error(...)` but do not reload hashtags/departments/stats
**File:** `KudosViewModel.swift:117`

If `reloadFilteredSections` throws (e.g. network hiccup), `state = .error(error)` is set but `highlightCards` and `allKudosCards` retain their previous values. Combined with H1 (no error UI), the user sees stale filtered content with no indication of failure. Acceptable for local mock data, but will matter when real API calls are wired in.

### E3 — Hashtag matching in `matchesFilters` is case-sensitive on the `#` prefix
**File:** `KudosService.swift:116`

```swift
card.hashtags.contains { $0.dropFirst().lowercased() == tag.name.lowercased() }
```

This assumes every hashtag string in `KudosCardData.hashtags` starts with `#`. If the API ever omits the `#` prefix, the filter will never match. Worth a comment or a guard against the assumption.

---

## Positive Observations

- `@MainActor final class KudosViewModel: ObservableObject` — correct annotation throughout.
- `@Published private(set)` on all data state properties — well-enforced except for nav-intent booleans.
- `async let` fan-out in `load()` correctly parallelises 7 service calls — good performance practice.
- `KudosFixtures` as single source of fixture truth — fixtures are not duplicated in the VM (only referenced via `KudosFixtures.cards`).
- `withLikeToggled()` math is correct: `nowLiked ? +1 : -1`, immutable struct copy pattern prevents accidental state mutation side-effects.
- `isOwn` guard (`guard !highlightCards[i].isOwn else { return }`) applied in both `highlightCards` and `allKudosCards` branches — TC_FUN_008 fully covered.
- `reloadFilteredSections` passes both `selectedHashtag?.id` and `selectedDepartment?.id` simultaneously, implementing AND logic correctly (TC_FUN_004) and resets `currentHighlightIndex = 0` before the reload (TC_FUN_005).
- `KudosBadgeTier.init(heartCount:)` threshold logic (10/20/50) matches TC_FUN_006 exactly.
- `ContinuousClock.now` used for debounce — monotonic, unaffected by system clock changes (TC_FUN_025).
- No hardcoded secrets, no force-unwraps, no `try!`. `ServiceError` propagation via `LoadState.error`.
- mm: marker comments present on all 11 required elements (hero, filter, carousel, cards, spotlight, stats, box, recipients, feed, viewAll links, section headers).
- All 19 `kudos.*` Localizer keys added with VN strings; EN/JA correctly left as empty placeholders per standards.
- `MainTabView` correctly uses `KudosTabViewContainer` (not raw `KudosTabView`) and the `HomeViewContainer` comment pattern is replicated.
- `KudosCard.228 LOC` is the only file over 200 lines; all others are comfortably under.

---

## Top 3 Follow-Up Actions (Priority Order)

1. **[H1] Render LoadState in KudosTabView** — add `.loading` skeleton/spinner and `.error` alert matching the HomeView pattern. Without this the screen shows blank content during the 1-second mock delay and swallows service errors silently.

2. **[M1] Consolidate duplicate NumberFormatter** — one formatter in `KudosFixtures.swift`, call `KudosFixtures.formatThousands()` from `withLikeToggled()`. Eliminates the only meaningful DRY violation.

3. **[M2] Resolve `badgeLevel` / `KudosBadge` dead code** — either delete both or wire badge tier into `KudosCard`'s star display. Leaving dead code referencing test-case logic (`TC_FUN_006`) is misleading.

---

## Security Confirmation

No hardcoded API keys, OAuth credentials, or tokens. No `try!`, no force-unwraps (`!`) in production code paths. No SQL, no string-concatenated queries, no user-visible stack traces. Auth routing (`ServiceError.unauthorized → tokenStore.clear()`) is in place per architecture contract. **No security issues found.**

---

**Status:** DONE_WITH_CONCERNS
**Summary:** Implementation is functionally correct and architecturally sound with all TCs satisfied. The primary concern is that `KudosTabView` never branches on `viewModel.state`, leaving the screen with no loading indicator and no user-visible error handling — this breaks the established pattern and will be a UX gap when real APIs replace the mock delay.
**Concerns:** H1 (no LoadState rendering in view) should be addressed before shipping to real API; M1–M2 are cleanup items suitable for the same or next sprint.
