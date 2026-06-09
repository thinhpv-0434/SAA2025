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
**Status: not started**

- Fetch next MoMorph screen for Home dashboard design
- Implement full Home screen via `momorph-implement-design` skill
- Replace `HomeView` stub

## Phase 6 — XCTest unit test target
**Status: not started**

- Add XCTest target to `SAA2025.xcodeproj`
- Implement 8 ViewModel unit test cases recommended by tester:
  - `signIn()` success path stores token
  - `signIn()` failure sets `showError = true`
  - Double-tap prevention (`isLoading` guard)
  - `TokenStore.save` persists value
  - `TokenStore.clear` removes value
  - `TokenStore.restore` reads persisted value on init
  - `Localizer.t` returns VN string for known key
  - `Localizer.t` returns key itself for unknown key (fallback)
- UI automation tests remain manual (20 test cases in `test-cases.csv`)
