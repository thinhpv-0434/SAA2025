# Clarifications — [iOS] Login (screen 8HGlvYGJWq)

## Session 2026-06-08

- Q: Architecture & project structure? → A: Plain SwiftUI with MVVM (Features/Login: View + ViewModel + Models, Services for auth, Resources for assets).
- Q: Google Sign-In approach + token storage? → A: Stub OAuth — fake success after short delay, no SDK integration yet. Keychain stub stores fake token.
- Q: Localization strategy (VN/EN/JA)? → A: Defer i18n — hardcode VN strings now, scaffold Localizable.strings placeholders for EN/JA later.
- Q: Home screen + auto-login (TC_LOGIN_FUN_007/012/013)? → A: Stub HomeView placeholder (inferred from stub-OAuth choice). AppRoot picks Login vs Home based on token store.
- Q: Open-dropdown UI for Language Selection (TC_LOGIN_FUN_002)? → A: Native SwiftUI `Menu` with VN/EN/JA items (deferred i18n means selecting does not re-render text yet).
- Q: Loading state on Google button (TC_LOGIN_FUN_006)? → A: In-button `ProgressView()` replacing icon, button disabled while loading.
- Q: Error message copy for OAuth failure (TC_LOGIN_FUN_010/015)? → A: Generic SwiftUI `.alert()` with title "Đăng nhập thất bại" and message "Vui lòng thử lại."
- Q: Missing media URLs (VN flag, dropdown arrow)? → A: Use SF Symbol `chevron.down` for dropdown; fetch VN flag via `get_figma_image` fallback in implementer.
- Q: Sun* domain gating (TC_LOGIN_FUN_015)? → A: Deferred (stub OAuth always succeeds). Note in plan as follow-up for real OAuth integration.
- Q: Min iOS version? → A: iOS 16 (broad enough for `NavigationStack`, `Menu`, modern SwiftUI).
- Q: Test framework? → A: XCTest for unit tests on ViewModel; UI test cases deferred (manual QA via 20 test cases CSV).
