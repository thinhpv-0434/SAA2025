# Phase 03 — Integration (Track B)

## Status: COMPLETE

`WriteKudoViewModel` + `WriteKudoContainer` created. All picker sheets wired. Navigation integrated. Success toast implemented. Build SUCCEEDED. All acceptance criteria verified.

**Note:** Post-review, toast `@State` lives in `WriteKudoContainer` (not ViewModel) with `withAnimation(.easeOut(duration: 0.25))` wrapper for smooth dismiss.

## MoMorph refs
- Screen: [iOS] Sun*Kudos_Viết Kudo_default — https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/7fFAb-K35a
- Clarifications: ./clarifications.md

## Goal
Wire Phase 01 UI to Phase 02 data layer via `WriteKudoViewModel`. Add picker sheets, success toast, cancel confirmation. Replace stub via existing `KudosTabView.navigationDestination`.

## Files
**Create**
- `Features/WriteKudo/WriteKudoViewModel.swift` (~150 LOC)
- `Features/WriteKudo/WriteKudoContainer.swift` (~70 LOC) — owns VM + sheets, dismiss closure
- `Features/WriteKudo/Components/RecipientPickerSheet.swift` (~110 LOC)
- `Features/WriteKudo/Components/HashtagPickerSheet.swift` (~130 LOC)
- `Features/WriteKudo/Components/AwardsInfoSheet.swift` (~50 LOC)

**Modify**
- `Features/Kudos/KudosTabView.swift` — change `navigationDestination` from `WriteKudoView()` to a container that takes a dismiss + toast closure. Add success-toast `@State` and reuse `KudosCopiedToast` shape with custom message.

**No changes needed**
- `KudosViewModel.swift` (`navigateToSendKudos` flag already exists)
- `SAA2025App.swift` / `AppRoot.swift` / `MainTabView.swift`

## ViewModel sketch
```swift
@MainActor
final class WriteKudoViewModel: ObservableObject {
    @Published var recipient: KudosUser? = nil
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var hashtags: [String] = []
    @Published var images: [String] = []
    @Published var isAnonymous: Bool = false
    @Published private(set) var isSubmitting: Bool = false
    @Published private(set) var availableRecipients: [KudosUser] = []
    @Published private(set) var availableHashtags: [Hashtag] = []
    @Published var showCancelConfirm: Bool = false
    @Published var showRecipientPicker: Bool = false
    @Published var showHashtagPicker: Bool = false
    @Published var showAwardsInfo: Bool = false
    @Published var submitError: String? = nil

    var canSubmit: Bool {
        recipient != nil &&
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !message.trimmingCharacters(in: .whitespaces).isEmpty &&
        !hashtags.isEmpty &&
        !isSubmitting
    }
    var isDirty: Bool {
        recipient != nil ||
        !title.isEmpty ||
        !message.isEmpty ||
        !hashtags.isEmpty ||
        !images.isEmpty ||
        isAnonymous
    }
    func loadOptions() async { ... }   // pull recipients + hashtags concurrently
    func addHashtag(_ tag: String) { ... }   // dedupe + 5 cap
    func removeHashtag(_ tag: String) { ... }
    func addImage() { ... }   // pop next from mock cycle
    func removeImage(_ name: String) { ... }
    func submit() async -> Bool { ... }   // returns true on success → container shows toast + dismiss
    func attemptCancel() { isDirty ? showCancelConfirm = true : <dismiss> }
}
```

## Picker sheets
- **RecipientPickerSheet**: searchable list of `availableRecipients`. Tap row → set VM.recipient + dismiss sheet. `.presentationDetents([.medium, .large])`.
- **HashtagPickerSheet**: list of existing hashtags as multi-select pills + a TextField for free-text. "Done" closes. Excludes already-selected.
- **AwardsInfoSheet**: scrollable VN paragraph placeholder. Close button.

## Success toast
Reuse `KudosCopiedToast` shape. Parameterize message: `"Đã gửi Kudos"`. Trigger from container after successful submit, then `dismiss()` after a short delay (or trigger toast on the parent tab view and dismiss immediately).

**Chosen pattern (simpler)**: Toast lives on the container; show it locally for ~1.5s, then `dismiss()` automatically. The KudosTabView doesn't need to know.

## Cancel flow
`WriteKudoContainer` reads `vm.showCancelConfirm` and presents `.alert("Bỏ Kudos này?", ...)` with "Hủy bỏ" (destructive, dismisses) + "Tiếp tục viết" (cancel).

## Navigation rewire
In `KudosTabView`:
```swift
.navigationDestination(isPresented: $viewModel.navigateToSendKudos) {
    WriteKudoContainer(onDismiss: { viewModel.navigateToSendKudos = false })
}
```

## Build verification
```bash
xcodebuild -project SAA2025.xcodeproj -scheme SAA2025 \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.1' build 2>&1 | tail -30
```
Expected: `** BUILD SUCCEEDED **`.

## Acceptance — Verified by orchestrator
- [x] Build SUCCEEDED
- [x] Tap SendKudosButton → Write Kudo form opens
- [x] Recipient sheet shows ~6 mock users; pick one updates field
- [x] Title/message/hashtag validation: Send disabled until all required filled
- [x] Add up to 5 hashtags + 5 images; over-limit button hides
- [x] Submit → "Đã gửi Kudos" toast → pop to Kudos tab
- [x] Cancel with dirty form → confirm alert; clean form → immediate dismiss
- [x] Awards-info link opens placeholder sheet

## Out of scope
- Real network
- Localizer wiring (hardcoded VN strings — separate cleanup)
- Anonymous flag visual treatment elsewhere
