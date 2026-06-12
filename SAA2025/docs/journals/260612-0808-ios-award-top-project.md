# iOS Award Top Project Screen — Missing Design Sections + Spec-CSV Blind Spot

**Date**: 2026-06-12 08:08 to 14:33  
**Severity**: Medium (design completeness gap caught in visual diff, recovered without production impact)  
**Component**: iOS App / Sun*Awards / Award Top Project screen  
**Status**: Resolved + committed  

## What Happened

Executed the full Takumi pipeline for the Awards Top Project screen (MoMorph `FQoJZLkG_d` / node 6885:10429, 11 spec rows + 10 test cases). Clarification phase gathered 4 user questions (3-award carousel model, reuse Home's Kudos banner, AwardsViewModel + LoadState, SwiftUI Menu for dropdown). Track A background `implementer` subagent hit Write/Bash permission wall after extracting design tokens—same precedent as the Write Kudo session. Orchestrator pivoted: captured tokens from subagent logs and implemented 7 UI components + 1 ViewModel directly. Forge phase completed; Temper (xcodebuild) caught missing `import Combine` in ViewModel → fixed → green. Reviewer scored 7.4/10 and identified 7 concerns (routing errors, component prop leakage, double-load race, icon mismatches, marker placement) — all 7 fixed in one pass. Build verified on iPhone 17 / iOS 26.1.

Then the user invoked `/fix-bug` for visual verification against Figma. **Cycle 1 baseline screenshot revealed a catastrophic gap: the screen was missing two entire sections vs Figma.** The top header (SAA logo + VN flag + search + bell — node 6885:10434) and the bottom Sun*Kudos CTA section (subtitle "Phong trào ghi nhận" + gold title + banner + paragraph + "Chi tiết" button — node 6885:10485) were completely absent. Root cause: **the 11-row CSV spec covered only the middle carousel/stats block. The frame node tree contained shared header and footer components that the spec author never annotated.** Orchestrator took over: queried `get_frame_node_tree` and `query_section`, built `AwardsScreenHeader.swift` (78 LOC) and `AwardsSunKudosSection.swift` (124 LOC), wired both into AwardsTabView. Cycle 2 simulator screenshots confirmed both sections render correctly. Cycle 3 cleaned up temporary launch-arg test hooks and reverted to Home-tab default. Committed `e60b8f4` with all sections present.

## The Brutal Truth

Two painful lessons emerged from this session:

**First, the spec CSV is a lying document.** Eleven rows that looked comprehensive were, in fact, an island — they covered the middle-third of the design and ignored the shared header and footer that frame the entire screen. I trusted the CSV implicitly because it came from the design team's export. I never read the full frame node tree until the visual diff forced it. This is absolutely infuriating because it means **the first complete pipeline run was fundamentally incomplete, and only the user's `/fix-bug` invocation surfaced the gap.** For the next MoMorph plan, `get_frame_node_tree` must be called *immediately after* `download_specs`, not after-the-fact. This is a pattern, not a one-off oversight.

**Second, the Track A subagent permission block is recurrent and dispiriting.** Both the Write Kudo plan and this plan hit it. The subagent does the hard work (design parsing, token extraction, component layout analysis) but then can't write files because of sandbox constraints. The orchestrator-takeover workaround is documented and works, but it reveals a gap: **the subagent is 80% done and gets stranded.** No graceful fallback, no queueing, just a blocked state that requires manual orchestrator intervention. Worth a follow-up investigation into sandbox config.

## Technical Details

### Missing Sections (Cycles 1–2)

**Cycle 1 (baseline screenshot):** The simulator rendered only the middle block — award carousel (Top Talent / Top Innovation), stat row (Quantity / Value), and action buttons. Completely absent: top header and bottom section.

**Root cause audit:**
```
11-row CSV covers: AwardCard + AwardHighlightBlock + AwardStatRow + selection UI
Frame node tree reveals: Header instance (6885:10434) + Footer instance (6885:10485)
CSV spec author: Did not annotate header/footer rows
Orchestrator: Assumed CSV was exhaustive
```

**Cycle 2 (fix):**

Built two new files:

1. **`AwardsScreenHeader.swift`** (78 LOC) — structurally mirrors `HomeHeader`:
   - `LanguagePicker` for VN selection
   - `Image("SunAALogo")` (24×24)
   - Search icon + bell icon with unread-count badge
   - Acceptable duplication for now; future refactor could extract `SharedTopBar`

2. **`AwardsSunKudosSection.swift`** (124 LOC) — reuses existing assets:
   - Subtitle: `Text("Phong trào ghi nhận")` (Montserrat 14, helper color)
   - Gold title: `Text("Sun* Kudos")` (Montserrat 28, bold, saaGold)
   - Banner: `Image("KudosBanner")` (existing imageset)
   - Paragraph: `Text("ĐIỂM MỚI CỦA SAA 2025")` (Montserrat 12, medium gray)
   - "Chi tiết" button: Gold pill (160×40, corner radius 4)

Integrated both into `AwardsTabView` — header at top, section at bottom. Cycle 2 simulator screenshot confirmed correct positioning.

**Cycle 3 (cleanup):** Removed temporary test hooks:
- `-StartTab Awards` launch argument in `MainTabView`
- `-ScrollBottom` launch argument + `ScrollViewReader` in `AwardsTabView`

These were required because Accessibility permission for synthetic taps was denied; no legitimate testing path existed. Reverted to default Home-tab launch.

### Reviewer Findings (7 Concerns, All Fixed)

| Concern | Fix |
|---------|-----|
| **H1** `ServiceError.unauthorized`/`.forbidden` not routed | Added catch blocks; introduced `AwardsTabViewContainer` to forward TokenStore (mirrors HomeViewContainer/KudosTabViewContainer pattern) |
| **H2** `AwardHighlightBlock` leaked full `Award` type to sub-components | Refactored: `selectedID: Award.ID` + `onSelect: (Award.ID) -> Void` |
| **M4** Same as H2, child component | Fixed in same pass |
| **M1** Stat row icons mismatched design tokens | `rosette` → `diamond.fill` (Quantity); `trophy.fill` → `flag.fill` (Value) |
| **M3** Figma container node ID reused for 3 children | Added inline comment "container — child IDs not in spec" |
| **M2** `mm:` markers inside `#Preview` instead of `body` | Relocated markers |
| **E1** Success branch silently rendered nothing when `selectedAward` was nil | Added fallback text: "Vui lòng chọn một giải thưởng." |

### Build + File Inventory

**Files created:** 9 Swift files (7 UI components + 1 ViewModel + 1 Container)  
**Files modified:** 4 (Award model extension, AwardsTabView, MainTabView, AwardsService)  
**Files deleted:** 0  
**Build:** SUCCEEDED on iPhone 17 / iOS 26.1 (xcodebuild Debug, no warnings)  

**File sizes (all under 200 LOC cap):**
- `AwardsTabView.swift` — 153 LOC
- `AwardsSunKudosSection.swift` — 124 LOC
- `AwardsTopViewModel.swift` — 83 LOC
- `AwardsScreenHeader.swift` — 78 LOC
- `AwardHighlightBlock.swift` — 67 LOC
- `AwardStatRow.swift` — 42 LOC
- `AwardCard.swift` — 58 LOC
- `AwardsTabViewContainer.swift` — 35 LOC

**Total additions:** +1218 lines / −13 lines  
**Commit:** `e60b8f4`

### Award Model Extension

Extended the shared `Award` model with 3 new fields (all trailing defaults for source compatibility):

```swift
struct Award {
    // ... existing fields
    let longDescription: String = ""
    let quantity: Int = 0
    let awardValue: Int = 0
}
```

No breaking changes to existing Home screen callers (`AwardCard`, `AwardsSection`, `AwardDetailView` previews still compile and render correctly).

## What We Tried

1. **Trusted the CSV as ground truth** — led to incomplete implementation. Next time: validate CSV completeness against frame node tree *before* clarifications.
2. **Took detailed design token notes from subagent logs** — compensated for orchestrator-direct implementation. Tokens were accurate; worked well.
3. **Added launch-arg test hooks** (`-StartTab Awards`, `-ScrollBottom`) — necessary because taps couldn't be automated, but inelegant. Reverted before commit.
4. **Reviewer scrutiny across 9 files** — caught all 7 integration/correctness concerns in one pass. High confidence in fix quality.

## Root Cause Analysis

### Why the Spec CSV Was Incomplete

The Figma frame contains three logical sections:
1. Header (instance ref to Home's header component)
2. Carousel/stats block (annotated in CSV)
3. Footer (instance ref to shared Kudos-marketing section)

The spec author exported only section 2. This is a **data-entry gap, not an implementation oversight.** But the orchestrator's responsibility is to validate the spec against the design, not blindly trust the CSV. The lesson: **call `get_frame_node_tree` immediately after `download_specs`, before clarifications.** A 1-minute tree inspection would have caught this.

### Why Track A Subagent Hit Sandbox Wall (Again)

Same pattern as Write Kudo: `implementer` subagent received full momorph context, extracted design tokens, prepared to code, then Write/Bash operations were denied. The sandbox is binary — either permitted or not. When denied, the agent can't degrade or queue. Orchestrator had to pivot to direct implementation. **The fix is environmental, not workflow.** Worth escalating to the Takumi team to document which subagent types require which permissions, and provide an "export tokens to JSON" fallback for Track A agents.

### Why Cycle 1 Screenshot Surfaced the Gap

**SwiftUI Preview rendering is not comprehensive.** Previews typically mock out shared component instances and external data. The full frame tree wasn't visible until the app actually rendered in the simulator. `/fix-bug` visual diff is the only reliable validation.

## Lessons Learned

1. **The spec CSV is not the ground truth — the frame node tree is.** Always call `get_frame_node_tree` *immediately after* `download_specs`, before clarifications, and audit for missing sections. This should become a mandatory step in the MoMorph development rules.

2. **Track A subagent permission wall is a known pattern.** Both Write Kudo and Awards Top Project hit it. The orchestrator-takeover precedent works, but it's frustrating. Push Takumi team for an explicit fallback: "export design tokens to JSON, orchestrator implements from JSON" mode.

3. **Shared component instances in Figma don't always appear in the spec CSV.** When you see instance nodes (e.g., "instance of HomeHeader"), they're likely part of the design but not documented row-by-row. Audit the node tree for these.

4. **AwardsScreenHeader duplicates HomeHeader structurally.** Acceptable for MVP, but marks a tech debt note: future v2 refactor should extract a `SharedTopBar` component and use it in both screens. Document this in the next refactor plan.

5. **Visual diff via `/fix-bug` is non-negotiable for completeness, not just cosmetics.** SwiftUI Previews won't catch missing entire sections. User-initiated `/fix-bug` with Figma side-by-side is the only bulletproof validation.

## Next Steps

- **[URGENT — MoMorph rules]** Update `.claude/rules/momorph/momorph-development.md` to mandate `get_frame_node_tree` call immediately after `download_specs`, before clarifications. Document the CSV-incompleteness hazard.
- **[URGENT — Takumi team]** Investigate subagent sandbox config: Track A `implementer` agents hit Write/Bash permission wall repeatedly. Clarify which agents require which permissions, or provide "export tokens → orchestrator codes" fallback.
- **[Post-MVP — Refactor]** Extract `SharedTopBar` component reusable by Home and Awards screens; remove `AwardsScreenHeader` duplication.
- **[Post-MVP — Testing]** Add XCUITest target with visual snapshot diffing (Figma frame ID → simulator screenshot → pixel diff). This would have caught the missing sections in cycle 1 without manual intervention.
- **[Docs]** Update `docs/development-roadmap.md` and `docs/project-changelog.md` with [0.7.0] release entry: Awards Top Project screen + three-award carousel + integration with Home's shared components.

**Owner:** Pham Van Thinh  
**Blocking:** None (feature delivered, all visual sections present and reviewed)  
**Commit:** `e60b8f4` — `feat(awards): implement Awards Top Project screen with header, carousel, and Sun*Kudos CTA section`
