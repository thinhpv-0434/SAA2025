# Phase 01 — UI (Track A → orchestrator)

## Status: COMPLETE

All 12 component files created + integrated. Build SUCCEEDED on iPhone 17 / iOS 26.1. Tester report: DONE. Reviewer report: APPROVE_WITH_CONCERNS (all critical concerns resolved post-review).

## MoMorph refs
- Screen: [iOS] Sun*Kudos_Viết Kudo_default — https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/7fFAb-K35a
- Clarifications: ./clarifications.md

## Goal
Pixel-fidelity SwiftUI composer form. Pure presentational view layer (state + callbacks); no business logic.

## Design tokens (from Figma — sourced by Track A subagent)
- Card bg: `#FFF8E1`, corner radius `10.72pt`, padding 18pt top/bottom, 12pt left/right
- Field bg: white, border `#998C5F` 0.447px, corner radius `3.574pt`
- Send button: bg `#FFEA9E`, border `#998C5F`, 40pt height, 4pt radius
- Cancel button: bg `#FFEA9E` at 10% opacity + same border
- Action row gap: 16pt
- Nav title: white, system 17pt semibold, "New Kudo"
- Labels: 14pt medium, `#00101A`
- Helper text: 12pt regular, `#999999`
- Background: reuse `KudosKeyvisualBackground`

## Deliverables (files) — CREATED
| File | Approx LOC | Purpose |
|------|-----------|---------|
| `WriteKudoView.swift` | ~180 | Composes nav bar + card scroll + action row; wires bindings from parent |
| `Components/WriteKudoNavBar.swift` | ~50 | Back chevron + "New Kudo" title |
| `Components/WriteKudoCard.swift` | ~40 | Cream container wrapper |
| `Components/WriteKudoRecipientField.swift` | ~70 | B.1 + B.2 (label + tappable dropdown) |
| `Components/WriteKudoTitleField.swift` | ~90 | B.3 + B.4 + B.5 (label + text input + helper + standards link) |
| `Components/WriteKudoFormatToolbar.swift` | ~80 | C.1–C.6 toolbar (visual-only) |
| `Components/WriteKudoMessageEditor.swift` | ~80 | D + D.1 (TextEditor + hint label) |
| `Components/WriteKudoHashtagSection.swift` | ~80 | E.1 + E.2 (label + + button + chips) |
| `Components/WriteKudoImageSection.swift` | ~90 | F (label + thumbnail row + add button) |
| `Components/WriteKudoAnonymousToggle.swift` | ~50 | G (checkbox + label) |
| `Components/WriteKudoActionRow.swift` | ~70 | H + I (Hủy + Gửi đi buttons) |
| `Components/FlowLayoutWriteKudo.swift` | ~50 | Chip grid layout utility (for hashtag + image rows) |
| `Components/WriteKudoSentToast.swift` | ~60 | Success toast "Đã gửi Kudos" (reuse `KudosCopiedToast` shape) |

## Integration contract (consumed by Phase 03)
```swift
struct WriteKudoView: View {
    @Binding var recipient: KudosUser?
    @Binding var title: String
    @Binding var message: String
    @Binding var hashtags: [String]
    @Binding var images: [String]
    @Binding var isAnonymous: Bool
    let isSubmitting: Bool
    let canSubmit: Bool
    let onRecipientTap: () -> Void
    let onAwardsInfoTap: () -> Void
    let onAddHashtagTap: () -> Void
    let onRemoveHashtag: (String) -> Void
    let onAddImageTap: () -> Void
    let onRemoveImage: (String) -> Void
    let onCancel: () -> Void
    let onSubmit: () -> Void
    let onBack: () -> Void
}
```

## MoMorph node markers (mm: comments)
Frame root: `6885:9271`
- A=`6885:9292`, B.1=`6885:9294`, B.2=`6885:9297`, B.3=`6885:9299`, B.4=`6885:9302`, B.5=`6885:9303`
- C=`6885:9306`, C.1=`6885:9307`, C.2=`6885:9309`, C.3=`6885:9311`, C.4=`6885:9313`, C.5=`6885:9315`, C.6=`6885:9317`
- D=`6885:9322`, D.1=(no node), E=`6885:9324`, E.1=`6885:9325`, E.2=`6885:9328`
- F=`6885:9346`, F.1=`6885:9347`, F.5=`6885:9355`, G=`6885:9363`, H=`6891:16834`, I=`6891:16833`

## Out of scope
- Actual rich-text formatting (toolbar is visual-only)
- Real photo picker (mock asset insertion only)
- @mention autocomplete
- Localizer wiring (hardcoded VN strings)
- Any edits outside `SAA2025/Features/WriteKudo/**`
