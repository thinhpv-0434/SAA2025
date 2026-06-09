# Plan — [iOS] Login Screen Implementation

## Overview
Implement the SAA 2025 iOS Login screen from MoMorph design `8HGlvYGJWq` ([iOS] Login) as the first feature in an empty SwiftUI scaffold. Stub Google OAuth + Home screen; defer i18n; lay down MVVM project structure.

**MoMorph refs**
- [iOS] Login: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/8HGlvYGJWq
- Clarifications: [clarifications.md](./clarifications.md)

## Decisions (from clarifications.md)
- Architecture: SwiftUI + MVVM
- OAuth: stubbed (FakeAuthService, 1s delay → success)
- Token: UserDefaults stub (defer Keychain)
- i18n: hardcode VN, scaffold Localizer with placeholder en/ja
- Home: stub `HomeView` (welcome + logout)
- Loading: in-button `ProgressView`
- Error: SwiftUI `.alert` ("Đăng nhập thất bại")
- Min iOS: 16
- Tests: XCTest on ViewModel (UI tests deferred to manual)

## Phases
| # | File | Status |
|---|------|--------|
| 1 | [phase-01-fetch-and-clarify.md](./phase-01-fetch-and-clarify.md) | ✅ done |
| 2 | [phase-02-forge-ui-and-services.md](./phase-02-forge-ui-and-services.md) | ✅ done |
| 3 | [phase-03-temper-and-inspect.md](./phase-03-temper-and-inspect.md) | ✅ done |
| 4 | [phase-04-deliver.md](./phase-04-deliver.md) | 🔨 in-progress |

## Files touched
- `SAA2025/Features/Login/` (new — View + ViewModel + 2 Components)
- `SAA2025/Features/Home/HomeView.swift` (new — stub)
- `SAA2025/Services/` (new — AuthService, TokenStore, Localizer)
- `SAA2025/AppRoot.swift` (new — login/home router)
- `SAA2025/SAA2025App.swift` (modified — body uses AppRoot)
- `SAA2025/ContentView.swift` (deleted — replaced by AppRoot)
- `SAA2025/Assets.xcassets/` (new imagesets — KeyvisualBG, SunAALogo, RootFurtherLogo, GoogleGLogo)

## Out of scope
- Real Google Sign-In SDK integration
- Keychain token storage
- Full localization (EN/JA strings)
- UI automation tests (manual QA from test-cases.csv)
- Home screen real content (only stub)

## Follow-ups (post-MVP, per tester + reviewer)
- **Automated Tests (XCTest)** — Add unit tests for LoginViewModel (8 test cases proposed in tester report: double-tap, error handling, loading state, token persistence, navigation, language picker)
- **Real OAuth** — Integrate GoogleSignIn-iOS SDK; swap FakeAuthService (TC_FUN_009/011, FUN_015 domain gate)
- **Token Expiry** — Add timestamp check + refresh token flow for TC_FUN_013 (currently deferred due to UserDefaults architectural limit)
- **Keychain Migration** — Move from UserDefaults to Keychain for token storage (security: current UserDefaults readable by any process on jailbroken device, included in unencrypted iCloud backups)
- **i18n Re-render** — Wire Localizer to LoginView; observe `@Published var lang` for runtime translation (TC_FUN_004)
- **Code Cleanup (Nice-to-have)** — StatusBar node comment (N-2), named cream color (N-7), remove unused errorMessage state (N-8), Localizer YAGNI defer (N-4)
- **HomeView Real Content** — Implement full home screen from next MoMorph screen
