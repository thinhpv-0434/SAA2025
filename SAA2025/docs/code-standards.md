# Code Standards

## File Naming

- Swift files: **PascalCase** matching the primary type they declare (`LoginView.swift`, `TokenStore.swift`).
- Non-Swift assets and scripts: kebab-case.
- File size limit: **200 LOC**. Split into sub-files or extract components when approaching the limit.

## Swift Conventions

### Naming
- Types, structs, enums, protocols: `PascalCase`
- Properties, functions, local vars: `camelCase`
- Enum cases: `camelCase`

### ViewModels
- Declare `@MainActor final class` conforming to `ObservableObject`.
- Expose state as `@Published private(set)` — views read, never write directly.
- One ViewModel per screen; shared state lives in a `Service` or `Store`.

```swift
@MainActor
final class LoginViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published var showError: Bool = false
}
```

### `@StateObject` vs `@ObservedObject` vs `@EnvironmentObject`

| Wrapper | When to use |
|---------|-------------|
| `@StateObject` | View **owns** the object lifetime (root of the ownership chain) |
| `@ObservedObject` | View **receives** the object from a parent (does not own it) |
| `@EnvironmentObject` | Passed through the view hierarchy without threading through every init — use for cross-cutting stores (`TokenStore`) |

In this project `AppRoot` owns `TokenStore` via `@StateObject`; `HomeView` reads it via `@EnvironmentObject`.

### Protocol-First Services

Define a `protocol` before any concrete type:

```swift
protocol AuthService {
    func signIn() async throws -> String
}
```

Inject via default argument so tests can swap the stub without a DI container:

```swift
init(authService: AuthService = FakeAuthService(), tokenStore: TokenStore) { ... }
```

### Error Handling
- Use `do / try / catch` — no `try!`.
- Surface errors through `@Published var showError: Bool` + SwiftUI `.alert`.
- No force-unwraps (`!`) in production code paths.

### No Hardcoded Secrets
- Never commit API keys, OAuth client IDs, or tokens in source.
- Use `.xcconfig` / environment injection for any future real credentials.

## MoMorph Marker Comments

Every SwiftUI element that maps to a Figma/MoMorph node carries a marker comment directly above it:

```swift
// mm:{frameId}:{nodeId}
```

Example from `LoginView.swift`:
```swift
// mm:6885:8964 / mm:6885:8965
background

// mm:6885:8972
header
```

For instance-level nodes inside a reusable component use the instance path form:
```swift
// mm:I{frameId}:{instanceNodeId};{componentNodeId}
```

Rules:
- One comment per logical element — do not skip elements that have a direct Figma counterpart.
- Keep markers on the line immediately above the element, never inline.
- Do not invent node IDs; only add markers when the MoMorph node ID is known from the design fetch.

## Localization Keys

String keys follow dot-separated namespacing: `{screen}.{element}` or `{domain}.{key}`.

```swift
"login.tagline"   // Login screen tagline
"error.title"     // Shared error alert title
```

Add new keys to the VN dict in `Localizer.swift` and leave EN/JA as empty-string placeholders until translations are available.

## Async / Concurrency
- Use structured concurrency (`async/await`) — no `DispatchQueue.main.async` wrappers in new code.
- Wrap side effects that touch UI state in `Task { }` inside `@MainActor` context.
- Use `defer { isLoading = false }` to guarantee state reset even on thrown errors.

## MoMorph Asset Import Gotcha

When `mcp__momorph__get_media_files` returns URLs for both an INSTANCE node and its inner RECTANGLE child, the two assets are **not always equivalent**. The INSTANCE's exported asset may render only the inner image — wordmarks, text overlays, or Component-level decorations defined in the source Component (`componentId`) can be omitted.

**Rule:** after every MoMorph asset import, **visually diff** each imageset against the cropped region of the design preview (`get_frame_image`) at the INSTANCE's bbox. Mismatch → re-source by cropping the preview directly.

Example (Login screen): node `6885:8977` (`mms_2_mm_media_logo`) returned an asset showing only the red Sun* star. The Component definition rendered "Sun* Annual Awards 2025" as a composite. Fix: cropped (20, 52, 68, 96) from `preview.png` and replaced the imageset. See `plans/260608-1708-ios-login/` for the diagnosis.

Prevention checklist for next MoMorph import:
1. After running `asset_downloader.py`, open each `*.imageset/*.png` AND the corresponding cropped region of `preview.png` side by side.
2. Any imageset that loses fidelity vs the design crop → replace with the preview crop using the INSTANCE bbox from `query_section` / `overview.json`.
3. 1× preview crops are not Retina; flag as a follow-up if higher resolution is required for production.
