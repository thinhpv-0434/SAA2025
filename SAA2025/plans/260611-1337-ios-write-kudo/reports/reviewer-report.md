# Reviewer Report — Write Kudo

## Scores (out of 10)

| Dimension | Score | Note |
|---|---|---|
| 200-LOC | 10 | All files within limit. Max: WriteKudoViewModel 161, WriteKudoView 150. |
| MVVM | 8.5 | `@MainActor final class` + `ObservableObject` correct. `isSubmitting` is `private(set)`. However, form-binding fields (`recipient`, `title`, `message`, `hashtags`, `images`, `isAnonymous`, `showRecipientPicker`, `showHashtagPicker`, `showAwardsInfo`, `showCancelConfirm`, `showSuccessToast`, `submitError`) are fully `@Published var` with no `private(set)` — the Container mutates them directly (e.g. `viewModel.showRecipientPicker = true`). Accepted pattern in this codebase but diverges from the "views read, never write" standard from `code-standards.md`. |
| mm: markers | 7.5 | Coverage is good on form components. Three gaps: (1) `// mm:(nav)` on WriteKudoNavBar call in WriteKudoView — not a real node ID. (2) `// mm:(no node)` on mention hint — acceptable as noted. (3) Sheet components (`RecipientPickerSheet`, `HashtagPickerSheet`, `AwardsInfoSheet`, `WriteKudoSentToast`) carry zero mm: markers — they are not Figma-spec elements but the sheet roots themselves were in the design. |
| Naming | 10 | Flawless PascalCase types, camelCase props/funcs throughout. `WriteKudoFieldStyle` enum for shared style constants is well-named. |
| Security | 9.5 | `do/try/catch` wraps `submitKudo`. No `try!`, no force-unwraps. `loadOptions` uses `try?` (silent swallow) — intentional for non-critical prefetch, but errors are invisible; minor. |
| DRY | 8.5 | `WriteKudoFieldStyle` effectively centralises border/label/helper colors. Still: `#00101A` raw color literal appears 6 times across WriteKudo files (NavBar preview, ActionRow, etc.) outside the style enum — should be `WriteKudoFieldStyle.labelColor`. `#FFF8E1` raw literal appears 8 times in previews — understandable in previews, but noteworthy. |
| YAGNI/KISS | 9.5 | No over-engineering. `FlowLayoutWriteKudo` is its own type rather than reusing a shared `FlowLayout` — slight duplication risk if a second flow layout is ever needed, but not harmful at current scope. |
| Clarifications | 9 | All 10 decisions implemented. One gap: `WriteKudoNavBar` title is `"New Kudo"` (EN). Design spec and clarifications use VN copy throughout; other toolbar/nav elements are VN. This is inconsistent — could be an intentional design decision or a miss. |
| Architecture fit | 9.5 | Container + presentational split exactly mirrors `KudosOverviewView`/`KudosOverviewViewContainer`. Toast modifier pattern reuses `KudosCopiedToast` shape correctly. `@StateObject` init convention matches `KudosTabView`. NavigationDestination wiring in both `KudosTabView` and `HomeView` follows existing pattern. |
| Correctness | 8 | Two real bugs found (see Critical Findings). |
| **Average** | **8.95** | |

---

## Critical Findings

### 1. `ForEach(images, id: \.self)` with non-unique strings — SwiftUI identity collision (HIGH)

`WriteKudoImageSection` uses `ForEach(images, id: \.self)`. The cycling asset pool only has 3 names (`KudosBanner`, `TopTalentBadge`, `TopProjectBadge`), so a user adding more than 3 images will produce duplicate IDs. SwiftUI deduplicates diffed views by id, leading to: incorrect animations, stale view state, wrong thumbnail getting removed. Fix: use index-based identity or wrap image entries in a struct with a `UUID`.

```swift
// In ViewModel:
struct ImageEntry: Identifiable { let id = UUID(); let assetName: String }
@Published var images: [ImageEntry] = []
```

### 2. `showSuccessToast` set without `withAnimation` — transition may not fire

`WriteKudoSentToast` relies on `.transition(.move(edge: .bottom).combined(with: .opacity))` and `.animation(.easeOut(duration: 0.25), value: isVisible)`. The ViewModel sets `showSuccessToast = true` on the `@MainActor`, but without a surrounding `withAnimation {}` call. Unlike `KudosCopiedToastController` which explicitly wraps in `withAnimation`, the state change here may not trigger the transition on all iOS 16/17 targets (behavior depends on SwiftUI version). Fix: wrap the assignment in `withAnimation` inside the ViewModel or in the container's `handleSubmit`.

---

## Recommended (non-blocking) follow-ups

- **`WriteKudoTitleField.onAwardsInfoTap` is a dead parameter.** The field receives the callback but never uses it in its body — the link is rendered inside `WriteKudoFormatToolbar` (via `WriteKudoCommunityStandardsLink`) not here. Remove the parameter from `WriteKudoTitleField` to avoid confusion.
- **`loadOptions` silently discards errors.** `try?` on both `loadRecipients` and `loadHashtags` means an empty picker gives no feedback. For a v1 fake service this is fine, but add a `@Published var loadError` before wiring real endpoints.
- **`"New Kudo"` nav title is English.** All other VN-string fields are properly localised. Clarify intent — if the design uses VN, change to `"Kudo mới"`.
- **Raw `#00101A` / `#FFF8E1` literals in preview closures.** Not a runtime issue, but a refactor to `WriteKudoFieldStyle.labelColor` / a named constant would make future theme changes easier.

---

## Verdict

**APPROVE_WITH_CONCERNS**

The implementation is well-structured, clean, and spec-compliant. The two critical findings — `ForEach` identity collision with duplicate image asset names and missing `withAnimation` on the toast trigger — are real runtime bugs that will manifest during QA with the mock cycling assets. Both are small fixes. All other patterns (MVVM, error handling, architecture fit, LOC) are solid.

## Status
DONE
