# Development Roadmap

## Phase 1 — Login scaffold + AppRoot routing
**Status: done**

- SwiftUI MVVM Login screen from MoMorph design `8HGlvYGJWq`
- `AppRoot` router (Login ↔ Home based on token)
- `FakeAuthService` stub OAuth, `UserDefaults` TokenStore, VN-only Localizer
- `HomeView` placeholder
- 4 imagesets added to asset catalog
- 11 architecture/UX decisions documented

## Phase 2 — Real Google Sign-In SDK
**Status: not started**

- Add `GoogleSignIn-iOS` via Swift Package Manager
- Implement `GoogleAuthService: AuthService` — real OAuth flow
- Handle sign-in cancellation and network errors
- Enforce Sun* domain gate (`@sun-asterisk.com`) on returned email (TC_LOGIN_FUN_015)
- Swap `FakeAuthService` default arg in `LoginViewModel`

## Phase 3 — Keychain token storage
**Status: not started**

- Replace `UserDefaults` in `TokenStore` with Keychain via `Security` framework
- Update `TokenStore.save` / `restore` / `clear` to use `kSecClassGenericPassword`
- Verify token survives app reinstall edge case handling (decide: clear on reinstall or not)

## Phase 4 — i18n EN/JA translations + Localizer wiring
**Status: not started**

- Populate `Localizer.en` and `Localizer.ja` string dicts
- Wire `Localizer` into view hierarchy via `@EnvironmentObject`
- `LanguagePicker` selection triggers `Localizer.lang` update → views re-render
- Add `Localizable.strings` files as fallback for system locale

## Phase 5 — Home screen real content
**Status: done**

- MoMorph design `OuH1BUTYT0` implemented via `momorph-implement-design` skill
- `MainTabView` (4-tab + per-tab `NavigationStack`) replaces the `HomeView` stub
- Full Home screen: countdown, awards section, kudos section, FAB, 7 navigation destinations
- `AwardsService`, `KudosService`, `NotificationsService` — protocol + Fake implementations
- `LoadState<T>`, `ServiceError`, `Config` added as shared infrastructure
- 4 new imagesets (PNG crops); SVG→PDF toolchain established for future vector assets
- 11 destination stubs scaffolded (Awards, Kudos, Profile, Search, Notifications, AccessDenied, WriteKudo)
- Reviewer score: 8.4 → green after fixes

**Deferred follow-ups (backlog)**
- PDF re-extraction for 4 Home imagesets (`TopTalentBadge`, `TopProjectBadge`, `TopInnovationBadge`, `KudosBanner`)
- Re-extract Login plan assets (KeyvisualBG, SunAALogo, RootFurtherLogo, GoogleGLogo) as PDF
- Award Detail typed navigation — `AwardDetailView(award:)` parameter currently unused
- Pull-to-refresh on Home scroll view
- Tab badge animations
- Real awards / kudos / notifications API calls (replace Fake services)
- Build out WriteKudo form fields and submission
- Notifications panel with mark-as-read
- Search screen content

## Phase 7 — Sun*Kudos tab + All Kudos screen
**Status: done**

- **Critical path fix:** All 18 Sun*Kudos files created in commit `2f0a7db` were at outer paths (`Features/Kudos/`, `Services/`, `Navigation/`) outside `SAA2025/` — the folder Xcode's `PBXFileSystemSynchronizedRootGroup` tracks. Entire Kudos feature was dead code; Kudos tab rendered the "Coming soon" stub. All 18 files moved via `git mv` into inner `SAA2025/` paths this session.
- **KudosTabView** (full implementation, commit `2f0a7db`): carousel, hashtag/department filters, stats block, spotlight board, secret-box flow, send kudos navigation
- **KudosOverviewView** (All Kudos screen `j_a2GQWKDJ`): Container/presentational split; inline header with back-chevron + "All Kudos" title; reuses `SectionHeader` and `KudosCard(isCarouselVariant: false)`; paginated feed via `loadKudosFeed(page: 1, limit: 20)`; heart toggle with `isOwn` guard
- **KudosOverviewViewModel**: `@MainActor ObservableObject`; `toggleHeart` guards against own kudos
- Navigation wired: `KudosTabView` and `HomeView` both navigate to `KudosOverviewViewContainer`

**Known limitations / deferred**
- Alert-dismiss binding bug in `KudosTabView` (pre-existing from `2f0a7db`) — `onRetry()` fires on Cancel tap; deferred follow-up
- All service calls are still Fake implementations
- Pagination beyond page 1 not implemented in UI

## Phase 8 — Kudo Detail screen (View Kudo)
**Status: done**

- MoMorph design `T0TR16k0vH` implemented via `momorph-implement-design` skill
- `KudosDetailView` pushed via `.navigationDestination(item: $viewModel.selectedDetail)` — no boolean flag
- `KudoDetail` domain model: mapper from `KudosCardData`, `toggleLike()`, `isOwn` field
- 5 components: `KudoSenderReceiverHighlight`, `KudoMessageBody`, `KudoAttachedImagesGrid`, `KudoDetailActionBar`, `KudoDetailNavBar`
- `KudosViewModel` migrated: boolean nav flag replaced by `selectedDetail: KudoDetail?` + `openDetail(for:)`; `DispatchQueue` → structured `Task { }`; badge color resolved by tier
- `KudosFeedView.swift` deleted (stub no longer needed as nav target)
- Build verified clean: iPhone 17 / iOS 26.1

**Deferred follow-ups**
- Like/share API calls (currently UI-only)
- Real media loading for attached images grid

## Phase 6 — XCTest unit test target
**Status: not started**

- Add XCTest target to `SAA2025.xcodeproj`
- Implement ViewModel unit test cases (Login + Home):
  - `signIn()` success path stores token
  - `signIn()` failure sets `showError = true`
  - Double-tap prevention (`isLoading` guard)
  - `TokenStore.save` / `clear` / `restore`
  - `Localizer.t` returns VN string for known key; key itself for unknown
  - `HomeViewModel.load()` success — `awardsState` and `kudosState` become `.loaded`
  - `HomeViewModel.load()` unauthorized — `tokenStore.clear()` called
  - `HomeViewModel` countdown tick — `remaining` decrements correctly
  - 9 Home test cases flagged ⚠️ require error-injecting mock services
- UI automation tests remain manual (test cases in plan CSVs)
