# Phase 02 — Data Model (Track B)

**Status: COMPLETE**

**Screen:** `[iOS] Award_Top project`
**Clarifications:** ./clarifications.md

## Goal
Extend the shared `Award` model with the fields Top Project needs, and update `FakeAwardsService` to return 3 awards × full fields.

## Tasks
1. Edit `Features/Home/Models/Award.swift`:
   - Add `longDescription: String`
   - Add `quantity: String` (e.g. `"02 Tập thể"`, `"10 Cá nhân"`)
   - Add `awardValue: String` (e.g. `"15.000.000 VNĐ"`)
   - Keep existing fields (`id`, `title`, `shortDescription`, `imageName`) unchanged.
   - Update all callers (Home AwardCard, AwardDetailView, Home #Preview blocks) to use the new initializer.
2. Edit `Services/AwardsService.swift`:
   - Update the 3 returned `Award`s with the new fields.
   - Top Project: spec-sourced values (`02 Tập thể` / `15.000.000 VNĐ` / long description from spec C2.1.3).
   - Top Talent + Top Innovation: plausible mock values + TODO marker. Long description repurposed from existing `shortDescription` text expanded with mock copy.

## Files
- Modify: `Features/Home/Models/Award.swift`
- Modify: `Services/AwardsService.swift`
- Modify (compile only): `Features/Home/Components/AwardCard.swift` if any Award init in tests/previews breaks.

## Success criteria
- [x] xcodebuild still passes after model + service edits (no AwardsViewModel yet). — Verified.
- [x] Home screen `AwardsSection` still renders (regression check). — Home AwardCard updated with new Award init; visual verified.
- [x] 3 awards returned with all 7 fields populated. — Top Project (spec-sourced), Top Talent + Top Innovation (mock TODO values).

## Risks
- Award is shared with Home — extending it forces all callers to recompile. Use trailing default-value parameters where possible to keep call sites compatible if practical; otherwise update each call site. **RESOLVED:** New fields added with no breaking changes; Home AwardCard call sites updated.

## Notes
Award model extended with 3 new String properties: `longDescription`, `quantity` (e.g., "02 Tập thể"), `awardValue` (e.g., "15.000.000 VNĐ"). FakeAwardsService returns all 3 awards fully populated. Existing callers in Home remain compatible.
