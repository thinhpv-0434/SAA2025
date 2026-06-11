# iOS Write Kudo Composer — Track A Failure + 2 Critical Pattern Bugs

**Date**: 2026-06-11 13:37 to 18:52  
**Severity**: High (production-facing UI logic bugs caught in review)  
**Component**: iOS App / Sun*Kudos / Write Kudo feature  
**Status**: Resolved + committed  

## What Happened

Executed a hybrid Takumi pipeline for Write Kudo composer screen (MoMorph `7fFAb-K35a`, 28 spec items). Spawned Track A background `implementer` subagent to code the UI from design — the agent extracted complete design tokens (cream card `#FFF8E1`, field borders, gold buttons, typography stack) but hit a permission wall on Write/Bash operations and never progressed to file generation. Orchestrator pivoted mid-session: abandoned the stalled subagent and implemented the full 14-file UI layer directly using the agent's extracted tokens. Track B (data model + integration) proceeded in parallel. Deliverable: 20 new Swift files + 3 modifications across `WriteKudo` feature. Build green. Reviewer found **2 critical runtime bugs** in the integration:

1. **Image deduplication collision**: `ForEach(images, id: \.self)` using cycling asset names (only 3 unique: KudosBanner, TopTalentBadge, TopProjectBadge) would crash or corrupt state when adding >3 images because SwiftUI deduplicates IDs.
2. **Toast animation dropped**: `showSuccessToast = true` lacked `withAnimation` wrapper, breaking the transition — state flip alone doesn't guarantee animation on iOS 16/17.

Both bugs fixed in this session before commit `ae6c6b8`. Build verified on iPhone 17 / iOS 26.1.

## The Brutal Truth

This session exposed a deep frustration with the MoMorph parallel-execution model: **the subagent design extraction was 80% complete and wasted.** The agent clearly had the design tokens parsed and was ready to code, but hit a sandboxing limitation (Write/Bash permission) that neither it nor the orchestrator could work around mid-execution. Rather than block for 30+ minutes trying to fix sandbox perms, I pivoted to orchestrator-direct implementation — this was the right call for timeline, but it highlights a gap in our subagent spawn protocol: **no graceful fallback when Track A hits infrastructure walls.**

The Reviewer's critical findings were genuinely painful because they represent *pattern mistakes* I should have caught:

1. **`ForEach(id: \.self)` with non-unique strings is a foot-gun.** I've been using this pattern safely with unique UUIDs elsewhere in the codebase, but the cycling mock asset pool lured me into thinking the string pool was sufficient. It's not. This is a *category of mistake* — using identity that won't scale — that needs explicit design checklist.

2. **Animation state responsibility is fragmented in our MVVM.** I set `showSuccessToast` in the ViewModel's `submitKudo()`, expecting SwiftUI to infer animation context. But the Reviewer was right: `@Published` state changes from a non-UI thread or without explicit `withAnimation` wrapper don't guarantee animation firing. The fix (move toast `@State` to the Container, wrap toggle in `withAnimation(.easeOut(...))`) is small but reveals that animation is a *View-layer concern*, not a ViewModel concern. Our MVVM architecture blurs this.

## Technical Details

### Track A Permission Wall

Background subagent logs indicated:
```
[momorph-implement-design] Extracted design tokens:
- WriteKudoCard: backgroundColor #FFF8E1, cornerRadius 10.72pt
- WriteKudoField: borderColor #998C5F, borderWidth 0.447px, cornerRadius 3.574pt
- WriteKudoActionRow: buttonColor #FFEA9E, gap 16pt
- WriteKudoNavBar: title "New Kudo" Helvetica Neue 17 semibold
- Field labels: Montserrat 14 medium #00101A
- Helper text: Montserrat 12 #999999

[WriteKudoView.swift] Writing file... Permission denied
[WriteKudoViewModel.swift] Writing file... Permission denied
```

Agent reported BLOCKED after 4 attempts. Subagent had done the hard part (design parsing) but couldn't execute I/O. Rather than wait for sandbox debugging, orchestrator took the tokens (captured in `clarifications.md` line 21) and implemented 14 UI files + 3 data/integration files directly.

### Reviewer's Critical Findings

**Bug #1 — Image identity collision**

```swift
// WRONG (WriteKudoImageSection):
ForEach(images, id: \.self) { assetName in
    // Remove on tap via images.remove(...)
}

// With cycling pool: ["KudosBanner", "TopTalentBadge", "TopProjectBadge", "KudosBanner", ...]
// Adding image #4 creates duplicate ID → SwiftUI diffing fails
```

**Fix applied:**
```swift
struct KudoImageAttachment: Identifiable {
    let id = UUID()
    let assetName: String
}

// Now images: [KudoImageAttachment]
// Remove by id: images.removeAll { $0.id == tapID }
```

**Bug #2 — Missing animation context**

```swift
// WRONG (WriteKudoViewModel.submitKudo):
DispatchQueue.main.async {
    self.showSuccessToast = true  // NO withAnimation wrapper
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        self.dismiss()
    }
}
```

The `WriteKudoSentToast` view applies `.transition(.move(edge: .bottom).combined(with: .opacity))`, but the state flip on `@MainActor` doesn't invoke the transition without explicit `withAnimation`.

**Fix applied:**
```swift
// Move showSuccessToast from ViewModel to WriteKudoContainer:
@State private var showSuccessToast = false

// In Container.handleSubmit():
withAnimation(.easeOut(duration: 0.25)) {
    viewModel.showSuccessToast = true
}
```

This shifts animation responsibility to the Container (the View layer owns animations), aligning with our architecture.

### Build + Integration

**Files created:** 20 Swift files (14 UI components, 2 data models, 4 integration/sheet helpers)  
**Files modified:** 3 (KudosService protocol, KudosTabView navigation, HomeView navigation)  
**Documentation:** 4 files updated in `./docs`  
**Build:** SUCCEEDED on iPhone 17 / iOS 26.1  
**Warnings:** 0 new (pre-existing baseline preserved)  

**Max file size:** WriteKudoViewModel 161 LOC (under 200-LOC cap)  
**Total feature lines:** 1679 across 20 files

## What We Tried

1. **Waited for Track A subagent** (~5 minutes) — logs showed it extracted tokens but couldn't write files. Checked sandbox rules; no obvious fix without escalating.
2. **Considered passing raw design tokens via prompt** — risk of transcription error on hex colors and dimensions. Decided the tokens in `clarifications.md` were precise enough.
3. **Attempted `try!` on image removal** (during Bug #1 debug) — correctly caught by Reviewer as unsafe; replaced with optional binding.
4. **Deferred `withAnimation` fix initially** — thought the Container's `@StateObject` wrapping would infer context automatically. Reviewer clarified this is not guaranteed on iOS 16/17; explicitly required.

## Root Cause Analysis

### Track A Failure

The subagent was correctly designed (background `implementer` via `momorph-implement-design` skill) and successfully parsed the Figma design. But **the harness's sandbox enforcement on Write/Bash operations is binary** — an agent either has permission or doesn't, with no partial execution or queuing mechanism. When the agent hit the wall, it had no way to either:
- Offload the I/O to the orchestrator mid-execution
- Queue work for retry
- Degrade to a report-only mode

This is an infrastructure gap in the Takumi parallel-execution model. **The fix:** Spawn protocol should clarify that Track A subagents must have Write+Bash enabled, or provide an explicit "report design tokens, orchestrator codes" fallback mode.

### Bug #1 — ForEach Identity Hazard

I conflated "mock cycling asset names" with "unique identifiers." The design has 3 asset images, so adding 1-3 images worked fine. But `id: \.self` on a string pool with only 3 unique values is a correctness hazard as soon as the cap is exceeded (which happens in normal QA: "add 5 images to test edge case"). The lesson: **cycling pools for mock data must always wrap in a struct with UUID identity**, even if the real product will have stable server-side IDs. The mock hazard is real.

### Bug #2 — Animation State Ownership

I treated `showSuccessToast` as a "view-agnostic boolean state" that could live in ViewModel. But animations require **View-layer context** — the SwiftUI runtime only fires transitions/animations if the state flip happens inside a `withAnimation {}` block in the View layer. `@MainActor` alone is not enough; `@Published` changes from the ViewModel don't carry animation intent. This is a subtle MVVM boundary: **animations belong to Views, not ViewModels**, even if the ViewModel owns the state binding.

## Lessons Learned

1. **Subagent design extraction is valuable but incomplete without execution fallback.** Next time: if Track A subagent stalls, have an explicit "export tokens to JSON + orchestrator codes" protocol rather than a 20-minute improvisation.

2. **`ForEach(id: \.self)` with mock cycling data is a pattern trap.** Always wrap mock entries in a struct with `id = UUID()`, even if the final product uses server IDs. The mock hazard is real and caught too late (in Reviewer, not in implementation).

3. **Animations are View-layer state transitions, not ViewModel operations.** `@Published var showToast` can live in ViewModel for logical flow, but the *triggering* of the animation must happen in the View (Container) via `withAnimation {}`. Refactor your MVVM mental model: ViewModel owns the boolean state, View owns the animation trigger.

4. **Clarification questions with "Recommended" consensus are powerful.** All 8 user answers mapped cleanly to implementation (plain TextEditor, sheet-based pickers, mock images, toast pattern). Recommended options reduced decision churn.

5. **Reviewer scrutiny scales with file count.** 20 files across a single feature made the Reviewer's job harder but also more thorough. The critical bugs only surfaced because the Reviewer traced through *all* integration points. Next time: explicitly request pattern-level review (ForEach identity, animation ownership) in reviewer scope.

## Next Steps

- **[2026-06-12]** Pipe hardcoded VN strings (`"Đã gửi Kudos"`, `"New Kudo"`, etc.) through `Localizer.swift` for consistency with the rest of the app.
- **[2026-06-12]** Audit all other `ForEach(_, id: \.self)` uses in codebase for cycling-pool hazards; refactor to UUID wrapping where applicable.
- **[MoMorph/Takumi team]** Document Track A fallback protocol: if subagent hits sandbox wall, provide explicit "extract tokens to JSON, orchestrator codes" mode.
- **[Post-MVP]** Real rich-text rendering on KudosDetailView (currently plain text); consider structured message model (attributedString) instead of flat String.
- **[Post-MVP]** Wire the Anonymous flag visual on KudosCard / KudosDetailView (separate plan; checkbox logic is already in place).

**Owner:** Pham Van Thinh  
**Blocking:** None (feature delivered, two critical bugs fixed before commit)  
**Commit:** `ae6c6b8` — `feat(kudos): implement Write Kudo composer with recipient/hashtag/image pickers`
