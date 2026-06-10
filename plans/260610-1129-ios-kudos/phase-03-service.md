# Phase 03 — KudosService Expansion

## Goal
Expand `KudosService` protocol with all 6 endpoints from spec analysis. `FakeKudosService` returns in-memory fixtures with `Config.mockApiDelay`.

## Edits to `Services/KudosService.swift`

### Protocol (additive — keep existing `loadKudos() async throws -> KudosInfo` for Home screen)

```swift
protocol KudosService {
    func loadKudos() async throws -> KudosInfo                                          // existing — Home banner
    func loadHighlight(hashtagId: String?, departmentId: String?) async throws -> [KudosHighlight]
    func loadKudosFeed(page: Int, limit: Int, hashtagId: String?, departmentId: String?) async throws -> [KudosHighlight]
    func loadHashtags() async throws -> [Hashtag]
    func loadDepartments() async throws -> [Department]
    func loadKudosStats() async throws -> KudosStats
    func loadTopRecipients() async throws -> [GiftRecipient]
    func loadSpotlightCount() async throws -> Int                                       // B.7.1 "388 KUDOS"
    func openNextSecretBox() async throws -> Bool                                       // D.2 — returns success
}
```

### FakeKudosService fixtures
- 5 `KudosHighlight` cards with rotating hashtags + departments
- 5 hashtags: Dedicated, Inspring, Teamwork, Innovation, GiveBack
- 4 departments: Division A, Division B, Division C, Operations
- `KudosStats` mock: received 25, sent 25, hearts 25, fire true, box opened 25, unopened 25
- 10 `GiftRecipient` rows
- Spotlight count: 388
- All methods sleep `Config.mockApiDelay` before returning

## Filtering inside Fake (server-side simulation)
- `loadHighlight` + `loadKudosFeed` apply AND filter when both params non-nil; OR filter when one nil. Returns up to 5 (highlight) or `limit` (feed).
- This pre-filters at the "API" layer; ViewModel does NOT re-filter the same data (avoids double-filter bug).

## Dependencies
- Phase 2 (models)

## File size constraint
- `KudosService.swift` ≤ 200 LOC. If exceeded, split fixtures into `KudosFixtures.swift`.

## Outcome
**Status:** DONE

### What shipped
- **KudosService.swift** (protocol only, ~40 LOC): 7 async methods (loadKudos + 6 new)
- **FakeKudosService.swift** (implementation): Implements full KudosService protocol with mock delays
- **KudosFixtures.swift** (140 LOC): Fixture data including 5 KudosHighlight cards, hashtags, departments, stats, recipients, formatters
  - 5 hashtags: Dedicated, Inspiring, Teamwork, Innovation, GiveBack
  - 4 departments: Division A, Division B, Division C, Operations
  - 10 GiftRecipient rows
  - Spotlight count: 388
  - `formatThousands(_:)` helper (NumberFormatter with dot grouping)

### Deviation from spec
- Filter logic implemented in FakeKudosService (server-side sim) — ViewModel receives pre-filtered data, does not re-filter (eliminates double-filter risk)
- `Config.mockApiDelay` used on all methods

### Notes
- `KudosService.swift` stays under 200 LOC; fixtures split into KudosFixtures.swift per strategy
- Service injection via constructor dependency injection ready for Phase 4 ViewModel
