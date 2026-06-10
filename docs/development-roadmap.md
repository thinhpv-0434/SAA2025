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

## Phase 6 — Sun*Kudos screen
**Status: done**

- MoMorph design `fO0Kt19sZZ` implemented via `momorph-implement-design` skill
- Full scrollable layout: Hero, Send Kudos, filter pills (Menu pickers), Highlight carousel, Spotlight Board, Personal Stats, Secret Box CTA, Top-10 Recipients, All Kudos feed (3 cards + view-all)
- `KudosService` protocol expanded to 9 endpoints; `KudosFixtures.swift` added as single mock-truth source
- 5 new model files, 11 new component files, `KudosViewModel` (`@MainActor`, `LoadState<Void>`)
- 19 `kudos.*` VN localisation keys added
- Build verified clean (iPhone 16 simulator)

**Deferred follow-ups (backlog)**
- Wire `KudosViewModelTests.swift` into XCTest target
- SpotlightBoard live search (currently UI-only)
- Heart toggle persistence via real API
- Secret Box sheet content (currently "Coming soon" placeholder)
- Real kudos API calls (replace FakeKudosService)

## Phase 7 — XCTest unit test target
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
