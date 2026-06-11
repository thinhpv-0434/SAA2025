# Plan — iOS Sun*Kudos Write Kudo (composer screen)

**Date:** 2026-06-11
**Screen:** `[iOS] Sun*Kudos_Viết Kudo_default`
**MoMorph:** https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/7fFAb-K35a
**fileKey:** 9ypp4enmFmdK3YAFJLIu6C
**screenId:** 7fFAb-K35a

## Goal
Replace the `WriteKudoView` stub with the full Write Kudo composer form. Wire it to the existing `KudosTabView.navigateToSendKudos` navigation. v1 ships with: plain TextEditor + visual-only toolbar, sheet-based recipient picker, sheet+free-text hashtag picker, mock image insertion, success toast + dismiss on submit.

## Tracks (originally planned parallel — adjusted)
- **Track A — UI:** Originally background `implementer` subagent. Hit permission wall after design analysis. **Orchestrator took over** using the agent's extracted design tokens (see `clarifications.md` last note).
- **Track B — Data + Integration:** Orchestrator. Extends `KudosService`, adds `WriteKudoViewModel`, wires submit/success/cancel.

## Phases
- **Phase 01 — UI (Track A → orchestrator):** Build presentational SwiftUI components for Write Kudo form. Pure view layer with bindings + callbacks. Mock data inline. *Status: COMPLETE*
- **Phase 02 — Data model (Track B):** `KudoDraft` struct, `submitKudo` + `loadRecipients` on `KudosService`, fake fixtures. *Status: COMPLETE*
- **Phase 03 — Integration (Track B):** `WriteKudoViewModel`, navigation rewire (the stub already lives at the navigationDestination), success toast plumbing, cancel-confirm. xcodebuild verification. *Status: COMPLETE*

## Key decisions (see `clarifications.md`)
- Plain TextEditor + visual-only formatting toolbar (no rich text v1).
- Recipient picker = bottom .sheet from fake `[KudosUser]` list, excludes current user.
- Hashtag picker = bottom .sheet from `KudosFixtures.hashtags` + free-text fallback.
- Image upload = mock insertion (no PHPicker); cycles fixed asset names.
- Submit success = "Đã gửi Kudos" toast + pop to `KudosTabView`.
- @mention = static hint label; no autocomplete.
- Awards info link = bottom .sheet with placeholder VN paragraph.
- Cancel = confirm `.alert` only when form is dirty.
- Validation = submit-time; Send button disabled until required fields populated.

## Files
**Create (Phase 01 — UI):**
- `Features/WriteKudo/WriteKudoView.swift` (root, replaces stub) — composes sub-views, owns no state (pure presentational view).
- `Features/WriteKudo/Components/WriteKudoNavBar.swift`
- `Features/WriteKudo/Components/WriteKudoCard.swift` (cream card container — extracted for clarity)
- `Features/WriteKudo/Components/WriteKudoRecipientField.swift`
- `Features/WriteKudo/Components/WriteKudoTitleField.swift`
- `Features/WriteKudo/Components/WriteKudoFormatToolbar.swift`
- `Features/WriteKudo/Components/WriteKudoMessageEditor.swift`
- `Features/WriteKudo/Components/WriteKudoHashtagSection.swift`
- `Features/WriteKudo/Components/WriteKudoImageSection.swift`
- `Features/WriteKudo/Components/WriteKudoAnonymousToggle.swift`
- `Features/WriteKudo/Components/WriteKudoActionRow.swift`

**Create (Phase 02 — data):**
- `Features/WriteKudo/Models/KudoDraft.swift`
- `Features/WriteKudo/Models/WriteKudoFixtures.swift` (mock recipients + cycling image asset names)

**Create (Phase 03 — integration):**
- `Features/WriteKudo/WriteKudoViewModel.swift`
- `Features/WriteKudo/Components/RecipientPickerSheet.swift`
- `Features/WriteKudo/Components/HashtagPickerSheet.swift`
- `Features/WriteKudo/Components/AwardsInfoSheet.swift`
- `Features/WriteKudo/WriteKudoSuccessToast.swift` (or reuse `KudosCopiedToast` shape)

**Modify:**
- `Services/KudosService.swift` — extend protocol with `submitKudo(KudoDraft) async throws -> Bool` + `loadRecipients() async throws -> [KudosUser]`. Implement on `FakeKudosService`.
- `Services/KudosFixtures.swift` — add `recipients: [KudosUser]` list.
- `Features/Kudos/KudosTabView.swift` — pass success-toast trigger Binding into `WriteKudoView` via destination wrapper (or use `@EnvironmentObject` toast controller).

## Acceptance
- [x] Build succeeds on iPhone 17 / iOS 26.1
- [x] Tapping `SendKudosButton` on `KudosTabView` opens the new Write Kudo form
- [x] All 28 spec items render with correct VN copy and design tokens
- [x] Form is invalid until recipient + title + message + ≥1 hashtag present; Send button disabled accordingly
- [x] Submit shows toast "Đã gửi Kudos" and pops back to Kudos tab
- [x] Tapping Cancel with content shows confirmation alert; empty dismisses immediately
- [x] Awards-info link opens placeholder sheet
- [x] Recipient & hashtag sheets load fake fixtures
- [x] Image add appends from a cycling mock asset list (max 5, hides add button at 5)
- [x] Anonymous toggle stored on draft

## Risks
- Field validation logic crossing UI + ViewModel — keep validation derivation in ViewModel only; UI reads `canSubmit: Bool`.
- File-count growth — splitting into 14+ files. Mitigation: 200-LOC cap enforced; SwiftUI composition over inheritance.
- Track A subagent permission block — resolved by orchestrator takeover; design tokens preserved in clarifications.md.

## Post-review fixes (applied)
1. **Image deduplication bug:** `ForEach(images, id: \.self)` would break on duplicate cycled asset names. **Fix:** Introduced `KudoImageAttachment(id: UUID, assetName: String)` struct; images stored as `[KudoImageAttachment]`; remove-by-UUID semantics applied.
2. **Success toast animation missing:** `showSuccessToast` flip lacked `withAnimation` wrapper, causing jarring pop. **Fix:** Moved toast `@State` to `WriteKudoContainer` (not ViewModel); wrapped toggle in `withAnimation(.easeOut(duration: 0.25))`.
3. **Bonus cleanup:** Removed dead `onAwardsInfoTap` parameter from `WriteKudoTitleField` (was never called in navigation).

**Non-blocking notes (deferred):**
- Hex color literals in `#Preview` closures (matches design, acceptable v1)
- `try?` in `loadOptions()` without fallback (acceptable — fixtures always available)
- English "New Kudo" navbar title (matches design literally, correct per specs)

## Next steps after delivery
- Pipe hardcoded VN strings through `Localizer.swift` (consistent cleanup)
- Real rich-text rendering on the detail view side (currently plain text)
- Wire the Anonymous flag visual on `KudosDetailView` / `KudosCard` (separate plan)
