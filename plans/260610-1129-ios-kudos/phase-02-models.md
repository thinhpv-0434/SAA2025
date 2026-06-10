# Phase 02 — Data Models

## Goal
Define Swift structs that mirror the Sun*Kudos screen's data needs. Codable so the future real backend can decode the same shape.

## Files to create (`Features/Kudos/Models/`)

```
KudosUser.swift          // id, fullName, employeeCode, avatarUrl?, badgeType?, departmentId?
KudosBadge.swift         // enum: risingHero, legendHero, etc. — derived from badgeType string
KudosHighlight.swift     // id, sender, receiver, title, message, hashtags, heartCount, isLiked, isOwn, postedAt, attachments?
KudosCardData.swift      // alias/typealias of KudosHighlight (used by both highlight + feed cards)
KudosStats.swift         // kudosReceived, kudosSent, heartsReceived, hasFireBonus, boxOpened, boxUnopened
GiftRecipient.swift      // user, rewardName
Hashtag.swift            // id, name (e.g. "Dedicated")
Department.swift         // id, name (e.g. "Division A")
```

## Constraints
- All `Codable`, `Identifiable`, `Equatable`
- Star-badge level is a computed property on `KudosUser`: `heartsReceived >= 50 → 3 ; >= 20 → 2 ; >= 10 → 1 ; else 0`
- One file per top-level type per code-standards.md
- Each ≤ 200 LOC (likely 30-80 each)

## Dependencies
- None. Pure data shapes.

## Coordination with Track A
- Track A's prompt lists `KudosHighlight`, `KudosUser`, `KudosBadge`, `KudosCardData`, `KudosStats`, `GiftRecipient` as files it creates. **If Track A creates them first, Phase 2 verifies + extends. If Phase 2 races ahead, Track A uses what's there.** Outcome: same files, single source.

## Acceptance
- `swift build` (via xcodebuild) compiles with no errors.
- KudosUser badge level computed property unit-tested in Phase 6.

## Outcome
**Status:** DONE

### What shipped
- **KudosHighlight.swift** (86 LOC): id, sender, receiver, title, message, hashtags, heartCount, isLiked, isOwn, postedAt, attachments; includes `KudosBadgeTier` enum + threshold compute; `withLikeToggled()` extension
- **KudosUser.swift**: id, fullName, employeeCode, avatarUrl, badgeType, departmentId
- **Hashtag.swift**: id, name
- **Department.swift**: id, name
- **KudosStats.swift**: kudosReceived, kudosSent, heartsReceived, hasFireBonus, boxOpened, boxUnopened
- **GiftRecipient.swift**: user, rewardName
- All Codable, Identifiable, Equatable

### Deviation from spec
- None. All files created per plan.

### Notes
- `KudosBadgeTier` nested in KudosHighlight instead of separate file (code consolidation)
- `badgeLevel()` also duplicated in ViewModel (dead code per reviewer — addressed in M2)
