# Code Review — [iOS] Login Screen
**Date:** 2026-06-08 | **Reviewer:** reviewer agent | **Build:** SUCCEEDED

---

## Scope
- Files: LoginView.swift, LoginViewModel.swift, LanguagePicker.swift, GoogleSignInButton.swift, HomeView.swift, AuthService.swift, TokenStore.swift, Localizer.swift, AppRoot.swift, SAA2025App.swift, ContentView.swift
- Total LOC reviewed: ~430
- Focus: MVVM quality, MoMorph marker coverage, clarification adherence, Swift idioms

---

## Per-File Score Table

| File | MM Markers /10 | MVVM Sep. /10 | Clarif. /10 | File Size /10 | Idioms /10 | YAGNI/DRY /10 | Naming /10 | Security /10 |
|---|---|---|---|---|---|---|---|---|
| LoginView.swift | 9 | 10 | 10 | 10 | 9 | 9 | 10 | 10 |
| LoginViewModel.swift | — | 9 | 10 | 10 | 9 | 10 | 10 | 10 |
| LanguagePicker.swift | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| GoogleSignInButton.swift | 9 | 10 | 10 | 10 | 10 | 9 | 10 | 10 |
| HomeView.swift | — | 8 | 10 | 10 | 10 | 10 | 10 | 10 |
| AuthService.swift | — | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| TokenStore.swift | — | 10 | 9 | 10 | 10 | 10 | 10 | 7 |
| Localizer.swift | — | 10 | 8 | 10 | 10 | 8 | 10 | 10 |
| AppRoot.swift | — | 9 | 10 | 10 | 9 | 10 | 10 | 10 |
| SAA2025App.swift | — | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| ContentView.swift | — | 10 | 10 | 10 | 10 | 10 | 10 | 10 |

**Overall score: 9.1/10**

---

## Overall Assessment

Solid, clean implementation. MVVM separation is respected throughout — ViewModel has zero SwiftUI imports, View has no business logic, services are protocol-first. All 11 MoMorph nodes required by the rubric are marked. Clarifications are faithfully followed. File sizes are well under 200 LOC. Two important issues (one async correctness defect, one production data-leak path) need addressing before production readiness; the rest are minor.

---

## Issues

### 🔴 Critical
None.

---

### 🟠 Important

**[I-1] LoginViewModel.swift:40-49 — `isLoading = false` runs even if Task is cancelled; not on `@MainActor` hop guaranteed**

`signIn()` is declared on `@MainActor`, but the inner `Task { }` closure is an unstructured task that escapes to a generic executor. The `isLoading = false` at line 48 is reached regardless of whether the Task was cancelled mid-flight (e.g., view dismissed). More critically, mutations to `@Published` properties from inside an unstructured `Task` body are NOT automatically on the `@MainActor` unless the enclosing class is `@MainActor` — which it is here, so mutations are safe. However, the lack of `defer { isLoading = false }` means a thrown-then-caught error path AND a success path both reach line 48 correctly, but a future refactor that adds an early `return` inside the `do` block will silently leave the spinner stuck.

```swift
// Suggested: make isLoading reset a defer so it's always released
func signIn() {
    guard !isLoading else { return }
    isLoading = true
    Task {
        defer { isLoading = false }
        do {
            let token = try await authService.signIn()
            tokenStore.save(token)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
```

**[I-2] TokenStore.swift:39 — `restore()` is `internal`, not `private`**

`restore()` is called only from `init()` but is declared with default (internal) visibility. Any module-level code can call `restore()` and silently reload a stale token over a freshly-cleared state. This is a trust-boundary violation in a security-relevant class.

```swift
// Line 39: change `func restore()` → `private func restore()`
```

**[I-3] TokenStore.swift — UserDefaults stores auth token without warning to calling code**

Clarifications permit UserDefaults for the stub, but the token value returned by `FakeAuthService` is `"fake-token-\(UUID().uuidString)"`. In a future iteration where `FakeAuthService` is replaced with a real OAuth token (before TokenStore is migrated to Keychain), the real token will silently land in UserDefaults, which is readable by any process with the same bundle group on a jailbroken device and is included in unencrypted iCloud backups. The existing `/// NOTE: UserDefaults is used as a stub. Migrate to Keychain for production.` comment is good, but the `save()` method should also emit a `#if DEBUG` assertion or runtime warning so the leak is obvious if someone swaps the service without migrating the store.

```swift
func save(_ token: String) {
    #if DEBUG
    print("[TokenStore] WARNING: saving token to UserDefaults — not production-safe")
    #endif
    self.token = token
    UserDefaults.standard.set(token, forKey: key)
}
```
*(The debug print is intentional here — flagging the insecure path, not leaking a real token in production.)*

---

### 🟡 Nice-to-have

**[N-1] LoginView.swift:24 — double `// mm:` on same line comment is ambiguous**

Line 24: `// mm:6885:8964 / mm:6885:8965` groups two node IDs on one comment. The `background` computed var then has its own `// mm:6885:8965` at line 61 (correct, for the Rectangle). Node `6885:8964` (the GROUP wrapper) has no dedicated SwiftUI element — the `ZStack` or the `Image` is both children — but the combined comment is non-standard and could confuse automated tooling that parses `mm:` markers. Suggest placing `// mm:6885:8964` above the `ZStack` in `body` and keeping `// mm:6885:8965` above the `Image` in `background`.

**[N-2] LoginView.swift — node `6885:8975` (StatusBar instance) has no `// mm:` marker**

The rubric lists `6885:8975` as a mappable node (it appears in `overview.json` as `iOS/Component/StatusBar`). There is no SwiftUI element mapping to it — the iOS status bar is rendered by the system and not addressable in SwiftUI — but the absence should be explicitly documented. A one-line comment in `header` noting "6885:8975 — system status bar, not addressable in SwiftUI" would satisfy traceability.

**[N-3] Localizer.swift — `Combine` import unused**

`Localizer.swift` imports `Combine` at line 9, but the class only uses `@Published` from Combine. `@Published` requires the `Combine` framework, so the import is technically needed, but `ObservableObject` conformance in SwiftUI does not require an explicit `Combine` import if `Foundation` is already present in recent toolchains. Low risk; compiler will catch any real issue. Harmless but worth noting for future readers.

**[N-4] Localizer.swift — `Localizer` instantiated nowhere**

`Localizer` is defined and fully implemented but never injected or used in any view. `LoginView` hardcodes VN strings directly rather than using `Localizer.t(_:)`. This is consistent with the clarification ("hardcode VN strings now"), but the Localizer class itself adds ~36 LOC of dead code for this iteration. Minor YAGNI violation — could be a stub file with just the `Lang` enum until the i18n follow-up lands.

**[N-5] AppRoot.swift:25 — `LoginView` receives `tokenStore` via init AND gets `.environmentObject(tokenStore)` injected**

`LoginView` takes `tokenStore` in its `init()` and uses it to create its `LoginViewModel`. It also receives `.environmentObject(tokenStore)` from `AppRoot`, but `LoginView`'s body never reads from `@EnvironmentObject` — it only uses the init-injected copy. The `.environmentObject(tokenStore)` on `LoginView` (line 25) is unused. It's harmless (it propagates down to children) but suggests the original design had `LoginView` reading `tokenStore` as an `EnvironmentObject`, then pivoted to init injection. The dead injection call should be removed for clarity.

```swift
// AppRoot.swift line 25: remove .environmentObject(tokenStore) from LoginView branch
LoginView(tokenStore: tokenStore)  // no .environmentObject needed here
```

**[N-6] GoogleSignInButton.swift:31 — button label text has trailing space in design data**

`overview.json` node `I6885:8969;28:1998` has text `"LOGIN With Google "` (trailing space). The implementation at line 31 uses `"LOGIN With Google"` (no trailing space). Cosmetically negligible, but the marker comment (`// mm:I6885:8969;28:1998`) claims fidelity to this node. Not a bug, but worth noting if pixel-perfect audit is required.

**[N-7] GoogleSignInButton.swift — magic color literal for cream background**

Line 50: `Color(red: 0.96, green: 0.93, blue: 0.84)` with comment `// cream/pale-yellow`. This should be a named color in Assets.xcassets or a `Color` extension constant so it can be referenced by name in future theming work. Low priority for a stub screen.

**[N-8] LoginViewModel.swift — `errorMessage` is published but never read by the View**

`errorMessage` at line 21 is `@Published private(set)` but `LoginView` only binds to `showError` for the `.alert`. The alert body uses a hardcoded `Text("Vui lòng thử lại.")` matching the clarification. The `errorMessage` property is dead state for this implementation. Either use it in the alert's message, or remove it.

---

## Edge Cases Found (from scouting phase)

**[E-1] Double-tap guard relies on `isLoading` but `Task` is unstructured**
If the user rapidly taps and the view is dismissed before the `Task` completes, `isLoading` will never be reset to `false` on the abandoned ViewModel. With `@StateObject`, the ViewModel is owned by the View and will be deallocated with it, so the abandoned Task writing to a deallocated object is a potential (though usually harmless in Swift's ARC) dangling-write. The `defer` fix from [I-1] mitigates this.

**[E-2] `TokenStore.restore()` called in `init()` synchronously on whatever thread `AppRoot` is initialised on**
`AppRoot` creates `TokenStore()` as a `@StateObject` on the main thread at first render. `UserDefaults.standard.string(forKey:)` is main-thread-safe, so no race here. But if `TokenStore` is ever moved to a background init context, this becomes a threading issue. Low risk given current architecture, flagged for awareness.

**[E-3] `Lang` enum is VN-only functional but has `en` and `ja` cases that select from empty dicts**
Selecting EN or JA in the `LanguagePicker` will silently fall back to the key string (e.g., `"login.tagline"`) as the displayed text in any view that uses `Localizer.t(_:)`. The current `LoginView` doesn't use `Localizer` at all, so this is inert. If any future view calls `Localizer.t(_:)` before i18n is wired, it will show raw key strings rather than a sensible fallback or error.

---

## Positive Observations

- `@MainActor` on `LoginViewModel` is correctly applied — avoids any UI-update-from-background-thread crash.
- `AuthService` is a protocol — swap to real SDK without touching ViewModel. Clean.
- `private(set)` on `isLoading` and `token` prevents View from mutating state it shouldn't touch.
- `guard !isLoading` double-tap prevention is the right pattern and is clearly commented.
- `ContentView.swift` correctly cleared to a no-op comment — no orphan code.
- All files are well under 200 LOC; no file-size violations.
- `FakeAuthService` has a clear replacement comment — no ambiguity about stub status.
- `TokenStore.save/clear` are symmetrical — no risk of stale key after logout.
- No force-unwraps anywhere in the codebase.
- No hardcoded secrets or API keys.

---

## MoMorph Marker Coverage Audit

From `overview.json`, mappable nodes for this screen:

| Node ID | Name in Figma | SwiftUI element | Marker present? |
|---|---|---|---|
| 6885:8963 | [iOS] Login (root frame) | `LoginView` struct | ✅ line 12 |
| 6885:8964 | bg (GROUP) | `background` computed var comment line 24 | ✅ (combined) |
| 6885:8965 | MM_MEDIA_Keyvisual BG | `Image("KeyvisualBG")` | ✅ line 61 |
| 6885:8972 | header (FRAME) | `header` computed var | ✅ lines 29, 69 |
| 6885:8975 | iOS/Component/StatusBar | system — no SwiftUI element | ⚠️ unmarked (see N-2) |
| 6885:8977 | mms_2_mm_media_logo | `Image("SunAALogo")` | ✅ line 71 |
| 6885:8976 | mms_2.1_language | `LanguagePicker` | ✅ lines 80, 12 |
| 6885:8967 | mms_3_Logo/RootFuther | `Image("RootFurtherLogo")` | ✅ lines 33, 87 |
| 6885:8968 | mms_4_content | tagline `Text` | ✅ lines 37, 100 |
| 6885:8969 | mms_5_Button | `GoogleSignInButton` | ✅ lines 41, 12 |
| 6885:8970 | footer (FRAME) | `footer` computed var | ✅ lines 44, 121 |
| 6885:8971 | mms_6_copyright Text | copyright `Text` | ✅ (within footer block) |

11/12 nodes marked. One (6885:8975, system status bar) is physically unaddressable in SwiftUI — not an implementation defect, but traceability gap.

---

## Recommended Actions (priority order)

1. **[I-2]** `TokenStore.restore()` → make `private`. One-character fix, closes a trust-boundary gap.
2. **[I-1]** Add `defer { isLoading = false }` inside the `Task` body to make spinner release unconditional.
3. **[I-3]** Add `#if DEBUG` warning log in `TokenStore.save()` — keeps the stub-to-production migration visible.
4. **[N-5]** Remove unused `.environmentObject(tokenStore)` on the `LoginView` branch in `AppRoot`.
5. **[N-8]** Either wire `errorMessage` into the `.alert` message body, or remove it.
6. **[N-2]** Add a comment in `header` noting that node `6885:8975` (StatusBar) is system-rendered and not addressable.
7. **[N-4]** Defer `Localizer` class creation to the i18n follow-up ticket; keep only the `Lang` enum for now.

---

## Unresolved Questions

1. `overview.json` rubric lists `6885:8964` as a separate mappable node from `6885:8965`. The combined comment `// mm:6885:8964 / mm:6885:8965` on line 24 of `LoginView.swift` is non-standard — confirm whether the MoMorph tooling that parses `mm:` markers handles the slash-separated multi-ID format, or if each ID must be on its own line.
2. `SAA2025App.swift` has no `@StateObject` or `@EnvironmentObject` injection for `Localizer` — if the i18n follow-up needs `Localizer` as a singleton, it will need to be injected at `App` level. Not an issue now, but worth flagging in the follow-up ticket.
