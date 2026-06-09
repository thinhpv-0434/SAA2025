# Project Changelog

## [0.1.0] — 2026-06-08

### [iOS] Login screen scaffolded from MoMorph design `8HGlvYGJWq`

**Features added**
- `LoginView` + `LoginViewModel` (SwiftUI MVVM) — full Login screen from Figma design
- `GoogleSignInButton` component — capsule button with in-button `ProgressView` while loading
- `LanguagePicker` component — SwiftUI `Menu` pill (VN / EN / JA); language switch UI-only, re-render deferred
- `HomeView` — stub screen (welcome text + logout button)
- `AppRoot` — routes between Login and Home based on `TokenStore.token` presence; animated transition

**Services added**
- `AuthService` protocol + `FakeAuthService` stub — 1 s async delay, returns `fake-token-<uuid>`
- `TokenStore` — `ObservableObject` persisting auth token to `UserDefaults` (stub; Keychain migration deferred)
- `Localizer` — `ObservableObject` with VN string dict; EN/JA dicts scaffolded as empty placeholders

**Assets added** (in `Assets.xcassets/`)
- `KeyvisualBG` — full-bleed login background
- `SunAALogo` — header logo (48×44 pt)
- `RootFurtherLogo` — hero logo (247×109 pt)
- `GoogleGLogo` — Google "G" icon inside sign-in button (20×20 pt)

**Scaffold changes**
- `SAA2025App.swift` updated — `body` now renders `AppRoot()` instead of `ContentView`
- `ContentView.swift` deleted — replaced by `AppRoot`
- `SAA2025.xcodeproj` updated — all new files registered under Xcode synced folder

**Process**
- 11 clarification decisions documented in `plans/260608-1708-ios-login/clarifications.md`
- Build verified clean (no compile errors)
- Reviewer score: 9.1 / 10
- Tester: 13 / 20 test cases automated; 7 deferred (UI tests, stub-dependent flows)

**Known limitations / deferred**
- Real Google Sign-In SDK not integrated — stub only
- Token stored in `UserDefaults`, not Keychain
- EN/JA translations empty; language switch does not re-render strings
- Sun* domain gating (`@sun-asterisk.com`) not enforced — stub always succeeds
- `HomeView` is a placeholder only

## [0.1.1] — 2026-06-09

### Fixed
- `SunAALogo` asset rendered only the red Sun* star — wordmark "Annual Awards 2025" was missing. MoMorph `get_media_files` returned the inner RECTANGLE child instead of the full Component composite. Replaced by cropping the INSTANCE bbox (20, 52, 68, 96) from `preview.png`. Build still ✅. Documented the gotcha + checklist in `docs/code-standards.md` to prevent recurrence on future MoMorph imports.
