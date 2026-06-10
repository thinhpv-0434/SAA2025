# Phase 01 — UI Implementation (Track A)

## MoMorph refs
- [iOS] Sun*Kudos: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/fO0Kt19sZZ
- Clarifications: [./clarifications.md](./clarifications.md)

## Goal
Background `implementer` agent codes the Sun*Kudos screen pixel-perfect from Figma. Mock data extracted from the design. Static / presentational only — no service calls, no real navigation.

## Owner
Track A — runs in parallel with Track B, no blocking handoff.

## Out of scope
- Service integration (Phase 5)
- ViewModel business logic beyond mock-array filtering toggle (Phase 4)
- Bottom sheets (deferred for v1; use Menu picker)
- Real navigation (Phase 5 wires stubs)

## Integration contract (for Phase 5)
- Agent reports back via `plans/reports/implementer-260610-1129-kudos-ui.md` with: files created, component props/struct fields, mock data interfaces.
- Phase 5 replaces hardcoded mock with `KudosViewModel` @Published bindings.

## Outcome
**Status:** DONE (via Track A background implementer)

### What shipped
- 16 new files under `Features/Kudos/` (models, components, view, VM shell)
- Components: KudosHeroSection, SendKudosButton, KudosFilterRow, HighlightCarousel, KudosCard, SpotlightBoard, PersonalStatsBlock, OpenSecretBoxButton, TopRecipientsBlock, KudosCardData (mock)
- KudosViewModel shell scaffolded (minimal, replaced in Phase 4)
- MainTabView updated to include KudosTabViewContainer
- 19 Localizer keys added (VN translation + EN/JA placeholders)
- Mock data extracted from Figma design (SF Symbol avatars, static Spotlight chart)

### Deviation from spec
- None. Per clarifications, SF Symbols used for avatars (Figma design shows placeholder); Spotlight static image + search field (live pan/zoom deferred)

### Integration ready
- All components accept `data` bindings + closures. Phase 5 wired LoadState + service calls.
