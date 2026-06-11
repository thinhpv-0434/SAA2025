# Phase 02 — Data model + Service (Track B)

## Status: COMPLETE

`KudoDraft` + `KudoImageAttachment` structs created. `KudosService` extended with 2 methods. Fake fixtures integrated. All tests passed.

**Note:** Post-review, `KudoImageAttachment` struct added to fix image deduplication bug (images stored as `[KudoImageAttachment]` with UUID + assetName, not bare strings).

## MoMorph refs
- Screen: [iOS] Sun*Kudos_Viết Kudo_default — https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/7fFAb-K35a
- Clarifications: ./clarifications.md

## Goal
Data layer for the composer: draft model + fake service methods for recipient list and submit.

## Files
**Create**
- `Features/WriteKudo/Models/KudoDraft.swift` (~50 LOC)
- `Features/WriteKudo/Models/WriteKudoFixtures.swift` (~60 LOC)

**Modify**
- `Services/KudosService.swift` — extend protocol + FakeKudosService impl
- `Services/KudosFixtures.swift` — optional: expose `recipients` if not duplicated in WriteKudoFixtures

## Domain model
```swift
struct KudoImageAttachment: Hashable {
    let id: UUID
    let assetName: String
}

struct KudoDraft: Hashable {
    let recipient: KudosUser   // required
    let title: String          // required, 1..100
    let message: String        // required, 1..1000 (plain text v1)
    let hashtags: [String]     // 1..5
    let images: [KudoImageAttachment]  // 0..5 (mock asset names with UUID dedup)
    let isAnonymous: Bool
}
```

## Service extension
```swift
protocol KudosService {
    // ...existing methods...

    /// Returns the fake recipient roster, EXCLUDING the current user.
    func loadRecipients() async throws -> [KudosUser]

    /// Fake submit; succeeds after mockApiDelay.
    /// Returns true on success. Throws on simulated failure if injected.
    func submitKudo(_ draft: KudoDraft) async throws -> Bool
}
```

`FakeKudosService` impl: sleep `Config.mockApiDelay` → return `WriteKudoFixtures.recipients` / `true`.

## Fixtures
- `recipients`: 6–8 mock `KudosUser` records reusing existing department + avatar conventions. Current user excluded.
- `mockImageAssetCycle`: array of 3 existing imageset names (e.g. `KudosBanner` placeholder fallback if no dedicated assets) — Phase 03 will pop one per Add tap.

## Out of scope
- Real network
- Image upload to a backend
- Validation logic (lives in ViewModel — Phase 03)
- Anonymous treatment on detail/feed views

## Dependencies
- Pulls in `KudosUser` from existing `Features/Kudos/Models/` (already shared with detail & overview).
