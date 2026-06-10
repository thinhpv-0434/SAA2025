# Plan — [iOS] Sun*Kudos Screen

**Screen:** `[iOS] Sun*Kudos` · screenId `fO0Kt19sZZ` · fileKey `9ypp4enmFmdK3YAFJLIu6C`
**Started:** 2026-06-10 11:29
**Discipline:** tkm:takumi (interactive)
**Two-track:** Track A (UI, background `implementer`) ∥ Track B (Track-B orchestrator)

## Context
- Specs analysis: [`reports/explore-260610-1129-kudos-specs.md`](../reports/explore-260610-1129-kudos-specs.md) — 51 unique components across A/B/C/D sections, 6 API endpoints, 5 DB tables
- Decisions: [`clarifications.md`](./clarifications.md)
- Existing Kudos feature: 3 stub files at `Features/Kudos/`, FakeKudosService loads single `KudosInfo` hero payload

## Goal
Build the full Sun*Kudos tab content: Hero + Send-Kudos pill + filter row + Highlight carousel (5 cards) + Spotlight Board (static) + Personal Stats + Secret Box CTA + Top-10 recipients + 3 All-Kudos cards + View-all link. ViewModel-backed local filtering + heart toggle. ViewModel unit tests.

## Phases

| # | Phase | Owner | Status |
|---|-------|-------|--------|
| 1 | UI implementation (12 components + view + minimal VM) | Track A (background) | Done — 16 files created; SF Symbol avatars + static Spotlight |
| 2 | Data models (KudosHighlight, KudosUser, KudosBadge, KudosStats, GiftRecipient, Hashtag, Department) | Track B | Done — Hashtag.swift + Department.swift added; full model suite |
| 3 | KudosService protocol expansion + FakeKudosService fixtures | Track B | Done — 6 endpoints + FakeKudosService + KudosFixtures.swift |
| 4 | KudosViewModel (LoadState, filter AND logic, carousel-reset, heart toggle, badge compute) | Track B | Done — LoadState, service injection, filter AND, heart toggle with isOwn guard, debounce |
| 5 | Integration: wire VM to UI components, replace mock with service-backed data, navigation stubs | Track B | Done — KudosTabView wired; LoadState overlay + alert; nav destinations stubbed |
| 6 | Tests: KudosViewModelTests (TC_FUN_004/005/006/007/008) | Track B | Done — 9 XCTests authored (not yet compiled; target wiring pending) |
| 7 | Build verify + reviewer + docs sync + commit | Delivery | Done — Build PASS; reviewer DONE_WITH_CONCERNS (H1/M1/M2 addressed) |

## Key dependencies
- Track A blocks Phase 5 (needs UI components to wire)
- Phase 2 → 3 → 4 → 5 → 6 sequence within Track B (models → service → vm → integration → tests)
- Phase 2/3/4 do NOT block Track A — they run in parallel

## Out of scope (deferred)
- Real Spotlight network chart pan/zoom + live search
- x2 special-day Fire bonus logic
- Real navigation destinations (Send Kudos form, Kudos Detail, Sunner Profile screens) — push existing stubs
- Bottom sheets for hashtag/department selection — render as Menu picker for v1
- Pagination on All Kudos feed
- Anonymous kudos masking UX (deferred for separate session)

## Phase files
- [phase-01-ui-track-a.md](./phase-01-ui-track-a.md)
- [phase-02-models.md](./phase-02-models.md)
- [phase-03-service.md](./phase-03-service.md)
- [phase-04-viewmodel.md](./phase-04-viewmodel.md)
- [phase-05-integration.md](./phase-05-integration.md)
- [phase-06-tests.md](./phase-06-tests.md)
