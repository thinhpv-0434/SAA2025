# Phase 05 — Integration (UI ↔ ViewModel ↔ Service)

## Goal
Replace Track A's hardcoded mock arrays with `@StateObject` `KudosViewModel`-backed bindings. Wire all navigations to existing stubs per clarifications.

## Triggers
- Track A reports DONE (notification arrives async)
- Phase 4 KudosViewModel exists

## Steps

1. **Replace mock data wiring in `KudosTabView`**
   - Add `@StateObject var viewModel = KudosViewModel()`
   - `.task { await viewModel.load() }`
   - Switch on `viewModel.loadState` — show ProgressView when loading, error alert on error, content when loaded

2. **Component bindings**
   - `KudosHeroSection`: static (no data)
   - `SendKudosButton`: `NavigationLink(destination: WriteKudoView()) { ... }` (push existing stub)
   - `KudosFilterRow`: bind `selectedHashtag` / `selectedDepartment` two-way → `viewModel.selectHashtag(_:)` / `selectDepartment(_:)`. Use SwiftUI `Menu` (deferred bottom sheet)
   - `HighlightCarousel`: bind `viewModel.snapshot.highlights` + `selection: $viewModel.carouselIndex`
   - `KudosCard`: bind `data: KudosHighlight`, `onHeartTap: { viewModel.toggleHeart(kudosId:) }`, `onCopyLink:` show toast, `onDetailTap: NavigationLink` to KudosFeedView stub
   - `SpotlightBoard`: bind `count: viewModel.snapshot.spotlightCount`; search field disabled visual + no action
   - `PersonalStatsBlock`: bind `stats: viewModel.snapshot.stats`
   - `OpenSecretBoxButton`: `isEnabled = stats.boxUnopened > 0`; tap → `viewModel.openSecretBox()`; show "Coming soon" sheet
   - `TopRecipientsBlock`: bind `viewModel.snapshot.topRecipients`; row tap → ProfileTabView stub
   - All Kudos feed: render first 3 of `viewModel.snapshot.feed`
   - `View all Kudos` link: push KudosFeedView stub

3. **Navigation plumbing**
   - All NavigationLink destinations are existing stubs in `Features/{WriteKudo, Profile, Kudos}/`. No new screens.

## Coordination
- Track A's `KudosViewModel.swift` likely a thin mock-only shell — Phase 4 fully replaces it.
- Models from Track A overlap with Phase 2 — assume single source after Phase 2.

## Acceptance
- `xcodebuild` clean compile
- Manual smoke: tap Kudos tab → screen renders with mock data → filter changes refresh content → heart tap toggles color + count → Send Kudos pushes write stub

## Outcome
**Status:** DONE

### What shipped
- **KudosTabView.swift** (220 LOC): Primary view container
  - @StateObject var viewModel = KudosViewModel()
  - `.task { await viewModel.load() }` triggers load on appear
  - Switch on `viewModel.state` — ProgressView on loading, error alert on error, content on success
  - KudosHeroSection (static)
  - SendKudosButton → NavigationLink to WriteKudoView stub
  - KudosFilterRow with Menu picker (both hashtag + department)
  - HighlightCarousel with currentIndex binding + pagination text
  - KudosCard list (highlightCards) + all Kudos feed (allKudosCards)
  - SpotlightBoard with static content
  - PersonalStatsBlock with KudosStats binding
  - OpenSecretBoxButton (enabled if stats.boxUnopened > 0)
  - TopRecipientsBlock
  - Navigation destinations: WriteKudoView, KudosFeedView, ProfileTabView (all existing stubs)

### Deviation from spec
- **H1 issue (reviewer finding):** LoadState rendered correctly (ProgressView + error alert). Status: FIXED (contra reviewer initial concern).
- Menu picker used instead of bottom sheets (deferred for v1 per clarifications)

### Integration points verified
- ViewModel → Service: All 7 calls wired
- ViewModel → UI: All @Published properties bound
- Heart toggle: onHeartTap callback → viewModel.toggleHeart(kudosId:)
- Filter: Menu selections → viewModel.selectHashtag / selectDepartment
- Carousel: currentHighlightIndex binding + reset on filter change
- LoadState pattern matches HomeViewModel (ProgressView + error alert)

### Notes
- MainTabView updated to use KudosTabViewContainer
- All LocalizeKey.kudos.* keys integrated
