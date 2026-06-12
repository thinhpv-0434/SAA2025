# Clarifications — iOS Award_Top project

**Date:** 2026-06-12
**Screen:** `[iOS] Award_Top project`
**MoMorph:** https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/FQoJZLkG_d
**fileKey:** 9ypp4enmFmdK3YAFJLIu6C
**screenId:** FQoJZLkG_d

## Session 2026-06-12

- Q: Awards covered + per-award fields → A: 3 awards (Top Talent, Top Project, Top Innovation); extend Award model with longDescription, quantity, awardValue
- Q: Section A Kudos banner → A: Build a new Awards-scoped variant (subagent design analysis shows the Awards screen Kudos banner is the fire-icon + "KUDOS" wordmark, distinct from Home's raster KudosBanner)
- Q: Data flow → A: AwardsViewModel + AwardsService.loadAwards() with LoadState (matches Home pattern)
- Q: Dropdown picker UX → A: SwiftUI Menu (native iOS dropdown)
- Q: Mock data for Top Talent + Top Innovation quantity/value → A: Plausible mock values, clearly labeled with TODO markers
- Q: Track A UI subagent permission block → A: Orchestrator takes over Track A (same precedent as 260611-1337-ios-write-kudo); subagent's design analysis preserved below as authoritative design tokens

## Session 2026-06-12 (cycle 2 — visual diff vs Figma)

- Q: Specs CSV (11 items) covers only A/B/C; Figma frame node tree also has a top header (6885:10434) and bottom Sun*Kudos section (6885:10485) → A: Build BOTH missing sections — add `AwardsScreenHeader.swift` (mirrors HomeHeader) and `AwardsSunKudosSection.swift` (subtitle + title + Kudos banner + ĐIỂM MỚI note + Chi tiết CTA)
- Q: Bottom section copy → A: subtitle "Phong trào ghi nhận", title "Sun* Kudos", body starts with "ĐIỂM MỚI CỦA SAA 2025\nHoạt động ghi nhận và cảm ơn đồng nghiệp...", CTA label "Chi tiết" (gold pill, dark text + arrow icon)
- Q: Kudos banner asset for bottom section → A: Reuse `KudosBanner` imageset already in Assets.xcassets (originally used by Home's KudosBanner component) — DRY, no new asset import needed

## Design tokens (extracted by background subagent before block)

- Background base: navy `#00101A`
- Primary gold: `rgba(255,234,158,1)` (asset `Color("saaGold")`)
- Divider: `#2E3940`
- Dropdown border: `#998C5F`
- Dropdown background: `rgba(255,234,158,0.10)`
- Section A KUDOS banner: Montserrat 14px medium gold subtext "Hệ thống ghi nhận và cảm ơn" + fire-icon + "KUDOS" wordmark
- Section B title: "Hệ thống giải thưởng\nSAA 2025" — gold 22px medium, two lines
- Section B subtitle: "Sun* Annual Awards 2025" — white 12px
- Section C badge: TopProjectBadge 160×160 (asset already imported in Assets.xcassets)
- Section C title row: trophy icon + "Top Project" bold gold 14px
- Section C description: white 14px light
- Stat rows: diamond icon (quantity) + flag icon (value), separated by `#2E3940` divider
- Screen background art: reuse `KudosKeyvisualBackground` pattern (group `mm_media_bg`)
