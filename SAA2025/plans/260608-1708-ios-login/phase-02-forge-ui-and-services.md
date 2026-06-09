# Phase 2 — Forge UI + Services

**Status:** ✅ done
**Priority:** P0
**Completed:** 2026-06-08 17:08 UTC

## Goal
Build SwiftUI LoginView + Services + stub HomeView + AppRoot from MoMorph design data and clarifications.

## What happened
Implementer subagent built all UI + services. Orchestrator applied 4 post-build fixes:
1. LoginViewModel: added `import Combine` (missing import)
2. TokenStore: `restore()` → `private` (trust-boundary fix)
3. LoginViewModel: `Task { defer { isLoading = false }; ... }` pattern (async correctness)
4. AppRoot: removed dead `.environmentObject(tokenStore)` on LoginView branch (cleanup)

## Track A — UI (subagent: `implementer`, background)
- `LoginView.swift` — ZStack root with Keyvisual bg + content VStack
- `LoginViewModel.swift` — @MainActor, isLoading/showError state, signIn() async
- `Components/LanguagePicker.swift` — SwiftUI Menu pill (VN/EN/JA), default VN
- `Components/GoogleSignInButton.swift` — cream pill, loading state swap

## Track B — Services + Routing (bundled into same implementer for KISS)
- `AuthService.swift` — protocol + `FakeAuthService` (1s delay → fake token)
- `TokenStore.swift` — ObservableObject backed by UserDefaults (`auth.token`)
- `Localizer.swift` — vn dict, en/ja placeholder dicts
- `AppRoot.swift` — router by token presence
- `SAA2025App.swift` — body → `AppRoot()`
- delete `ContentView.swift`

## Track C — HomeView stub
- `HomeView.swift` — Welcome text + Logout button (clears token)

## Visual coverage (mm:{nodeId} markers required)
| nodeId | element | maps to |
|--------|---------|---------|
| `6885:8963` | root frame 375×812 | LoginView root |
| `6885:8965` | Keyvisual BG | Image("KeyvisualBG") |
| `6885:8977` | Sun*AA logo | Image("SunAALogo") |
| `6885:8976` | Language picker | LanguagePicker |
| `6885:8967` | ROOT FURTHER logo | Image("RootFurtherLogo") |
| `6885:8968` | Description text | Text (VN hardcoded) |
| `6885:8969` | Google button | GoogleSignInButton |
| `6885:8971` | Copyright text | Text (VN hardcoded) |

## Verification
- `xcodebuild -project SAA2025.xcodeproj -scheme SAA2025 -destination 'generic/platform=iOS Simulator' build` succeeds
- Login flow: tap button → 1s loading → token saved → HomeView
- Logout: HomeView button → token cleared → LoginView
- Language picker opens Menu, lets selection (no visible re-render — i18n deferred)

## Out of scope (this phase)
- XCTest files (next phase)
- Real Google SDK
- Real Keychain
- EN/JA string translations

## Acceptance criteria
- All Swift files compile with no errors
- Each MoMorph-mapped SwiftUI element has `// mm:{nodeId}` comment
- File sizes < 200 LOC each
- No reference to ContentView remains
