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

## Asset Toolchain: SVG → PDF via librsvg

Vector assets from MoMorph are preferred in PDF format so Xcode can use `preserves-vector-representation: true` in the imageset. The toolchain is:

1. Fetch the SVG via MoMorph MCP: `mcp__momorph__get_media_file convertType:"svg"`
2. Convert to PDF using `rsvg-convert` (installed via `brew install librsvg`):

```bash
rsvg-convert -f pdf -o output.pdf input.svg
```

3. Place `output.pdf` into the imageset folder alongside `Contents.json`. Set `"universal"` scale and add `"preserves-vector-representation": true` to the image entry in `Contents.json`.

This workflow was established during the Home screen plan (`260609-1002-ios-home`). `rsvg-convert` version in use: 2.62.3.

**Fallback — PNG crop from preview.png**

When the SVG path is unavailable (e.g., MoMorph returns "Frame not found" for the media file), fall back to cropping the target element from the MoMorph frame preview image. This yields a 1× raster — flag as a follow-up for Retina re-extraction. See "MoMorph Asset Import Gotcha" below for the full checklist that applies equally to PNG crops.

The 4 Home screen imagesets (`TopTalentBadge`, `TopProjectBadge`, `TopInnovationBadge`, `KudosBanner`) were added using this PNG fallback — PDF re-extraction is a deferred follow-up.

## Shared Style-Token Enums

Use a caseless `enum` (no instances, no `static let` class) to group related visual constants that multiple sub-components share within a feature. This avoids repetition and prevents the same magic number appearing in N files.

```swift
// In WriteKudoCard.swift — shared by WriteKudoMessageEditor, WriteKudoTitleField, etc.
enum WriteKudoFieldStyle {
    static let borderColor: Color = Color(red: 0x99/255.0, green: 0x8C/255.0, blue: 0x5F/255.0)
    static let borderWidth: CGFloat = 0.447
    static let cornerRadius: CGFloat = 3.574
    static let labelColor: Color = ...
    static let helperColor: Color = ...
}
```

Keep the enum in the file closest to the primary consumer (e.g., the card/root view of a feature). Sub-components import it by name — no global Style file needed unless two features genuinely share the same tokens.

## Identity-Wrapping Models for Mock-Pool ForEach Safety

When a list item's natural identity key (e.g., an asset name string) is not unique — because a mock data pool is small and items cycle — wrap it in a dedicated model type that generates a `UUID` at creation time. This satisfies `Identifiable` without duplicate-id crashes in `ForEach`.

```swift
struct KudoImageAttachment: Identifiable, Hashable {
    let id: UUID           // stable, generated once at init
    let assetName: String  // may repeat across items

    init(assetName: String, id: UUID = UUID()) {
        self.id = id
        self.assetName = assetName
    }
}
```

Use the same pattern any time a `ForEach` item source has non-unique string/int keys and the duplication is intentional (e.g., mock data, repeated placeholder images).

## MoMorph Asset Import Gotcha

When `mcp__momorph__get_media_files` returns URLs for both an INSTANCE node and its inner RECTANGLE child, the two assets are **not always equivalent**. The INSTANCE's exported asset may render only the inner image — wordmarks, text overlays, or Component-level decorations defined in the source Component (`componentId`) can be omitted.

**Rule:** after every MoMorph asset import, **visually diff** each imageset against the cropped region of the design preview (`get_frame_image`) at the INSTANCE's bbox. Mismatch → re-source by cropping the preview directly.

Example (Login screen): node `6885:8977` (`mms_2_mm_media_logo`) returned an asset showing only the red Sun* star. The Component definition rendered "Sun* Annual Awards 2025" as a composite. Fix: cropped (20, 52, 68, 96) from `preview.png` and replaced the imageset. See `plans/260608-1708-ios-login/` for the diagnosis.

Prevention checklist for next MoMorph import:
1. After running `asset_downloader.py`, open each `*.imageset/*.png` AND the corresponding cropped region of `preview.png` side by side.
2. Any imageset that loses fidelity vs the design crop → replace with the preview crop using the INSTANCE bbox from `query_section` / `overview.json`.
3. 1× preview crops are not Retina; flag as a follow-up if higher resolution is required for production.
