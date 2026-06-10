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

## [0.2.0] — 2026-06-09

### [iOS] Home screen implemented from MoMorph design `OuH1BUTYT0`

**Navigation infrastructure**
- `MainTabView` — 4-tab root (`NavigationStack` per tab) replaces the `HomeView` stub in `AppRoot`'s authed branch
- Tabs: SAA 2025 / Awards / Kudos / Profile; tint color `saaGold` (#D9A656)
- `HomeViewContainer` — thin env-object bridge between `MainTabView` and `HomeViewModel`

**New shared infrastructure**
- `LoadState<T>` — generic async state enum: `idle / loading / loaded(T) / empty / error`
- `Config` — caseless enum for compile-time constants: `eventDate` (2026-12-26 UTC), `isKudosAvailable`, `mockApiDelay`
- `ServiceError` — shared error enum; `.unauthorized` clears token (back to Login), `.forbidden` routes to `AccessDeniedView`

**Services added**
- `AwardsService` protocol + `FakeAwardsService` — returns 3 hardcoded award records
- `KudosService` protocol + `FakeKudosService` — returns canonical Kudos hero content
- `NotificationsService` protocol + `FakeNotificationsService` — returns `unreadCount: 3`

**Home feature**
- `HomeView` + `HomeViewModel` (`@MainActor`) — full Home screen: header, hero, countdown, event info, awards section, kudos section, FAB
- 10 components: `HomeHeader`, `HeroSection`, `CountdownCard`, `EventInfoCard`, `ThemeNoteSection`, `AwardsSection`, `AwardCard`, `KudosSection`, `KudosBanner`, `FloatingActionButton`
- Live countdown timer (1 s tick via Combine) against `Config.eventDate`

**Destination stubs added (11)**
- Awards: `AwardsTabView`, `AwardsOverviewView`, `AwardDetailView`
- Kudos: `KudosTabView`, `KudosOverviewView`, `KudosFeedView`
- `WriteKudoView`, `ProfileTabView`, `SearchView`, `NotificationsView`, `AccessDeniedView`

**Assets added** (in `Assets.xcassets/`)
- `TopTalentBadge`, `TopProjectBadge`, `TopInnovationBadge` — award badge images (PNG crop from preview.png)
- `KudosBanner` — kudos hero image (PNG crop from preview.png)
- `saaGold.colorset` — #D9A656 tab bar tint

**Asset toolchain established**
- SVG→PDF workflow via `rsvg-convert` 2.62.3 (`librsvg` brew) with `preserves-vector-representation: true`
- Home screen assets used PNG fallback (MoMorph returned "Frame not found" mid-session) — PDF re-extraction deferred

**Process**
- Build verified clean (no compile errors)
- Tester: 20/32 ✅ · 9/32 ⚠️ (need error-injecting mocks) · 1/32 deferred (XCTest target not yet added) · 0/32 ❌
- Reviewer score: 8.4/10 initial; all 6 important + 1 nice-to-have fixes applied; final pre-commit build green

**Known limitations / deferred**
- All services are stubs — no real API calls
- Award Detail typed navigation deferred (current stub ignores `award:` parameter)
- XCTest target not yet added to project
- PDF re-extraction for 4 Home imagesets (TopTalent, TopProject, TopInnovation, KudosBanner)
- EN/JA translations still empty; VN strings hardcoded
- Pull-to-refresh not implemented
- Tab badge animations not implemented

## [0.1.1] — 2026-06-09

### Fixed
- `SunAALogo` asset rendered only the red Sun* star — wordmark "Annual Awards 2025" was missing. MoMorph `get_media_files` returned the inner RECTANGLE child instead of the full Component composite. Replaced by cropping the INSTANCE bbox (20, 52, 68, 96) from `preview.png`. Build still ✅. Documented the gotcha + checklist in `docs/code-standards.md` to prevent recurrence on future MoMorph imports.
