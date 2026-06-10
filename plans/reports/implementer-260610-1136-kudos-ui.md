# Implementer Report: Sun*Kudos Screen UI

**Task:** Implement iOS Sun*Kudos screen — static UI, mock data, pixel-faithful to Figma
**Date:** 2026-06-10
**Status:** DONE_WITH_CONCERNS

---

## Files Created

| File | LOC | Purpose |
|------|-----|---------|
| `Features/Kudos/Models/KudosHighlight.swift` | 47 | KudosUser, KudosBadgeTier, KudosBadge, KudosCardData |
| `Features/Kudos/Models/KudosStats.swift` | 16 | Personal stats struct |
| `Features/Kudos/Models/GiftRecipient.swift` | 17 | Gift recipient row model |
| `Features/Kudos/KudosViewModel.swift` | 90 | Mock data + filter/carousel state, @MainActor ObservableObject |
| `Features/Kudos/Components/KudosHeroSection.swift` | 72 | A — hero banner + KUDOS wordmark |
| `Features/Kudos/Components/SendKudosButton.swift` | 46 | A.1 — pill CTA |
| `Features/Kudos/Components/KudosFilterRow.swift` | 58 | B.1 — two filter pills |
| `Features/Kudos/Components/SectionHeader.swift` | 41 | Reusable gold subtitle + white title |
| `Features/Kudos/Components/HashtagChip.swift` | 46 | B.4.3 — hashtag pill |
| `Features/Kudos/Components/KudosCard.swift` | 148 | B.3/B.4/C.3 — reusable kudos card |
| `Features/Kudos/Components/HighlightCarousel.swift` | 109 | B.2/B.3/B.5 — horizontal carousel + pagination |
| `Features/Kudos/Components/SpotlightBoard.swift` | 146 | B.7 — count + network chart placeholder + search |
| `Features/Kudos/Components/PersonalStatsBlock.swift` | 105 | D.1 — 5 stat rows |
| `Features/Kudos/Components/OpenSecretBoxButton.swift` | 51 | D.2 — yellow CTA with disabled state |
| `Features/Kudos/Components/TopRecipientsBlock.swift` | 90 | D.3 — boxed recipient list |
| `Features/Kudos/KudosTabView.swift` | 164 | Root scrollable screen; replaces stub |

**Files Modified:**
| File | Change |
|------|--------|
| `Navigation/MainTabView.swift` | `KudosTabView()` → `KudosTabViewContainer()` |
| `Services/Localizer.swift` | Added 19 kudos localization keys (VN values from Figma) |

---

## Component Tree (one level)

```
KudosTabView
├── KudosHeroSection         (A)
├── SendKudosButton          (A.1)
├── KudosFilterRow           (B.1)
├── SectionHeader            (B.2 — "HIGHLIGHT KUDOS")
├── HighlightCarousel        (B.3/B.4/B.5)
│   └── KudosCard × 5        (carousel variant, isHighlight drives opacity)
│       └── HashtagChip × N
├── SectionHeader            (B.6 — "SPOTLIGHT BOARD")
├── SpotlightBoard           (B.7 — count + Canvas network chart + search)
├── SectionHeader            (C.1 — "ALL KUDOS")
├── PersonalStatsBlock       (D.1)
├── OpenSecretBoxButton      (D.2)
├── TopRecipientsBlock       (D.3)
├── KudosCard × 3            (C.3 — feed variant, full width)
│   └── HashtagChip × N
└── View All Kudos link      (C.2)
```

---

## Data Interfaces

### KudosCardData (KudosHighlight.swift)
```swift
struct KudosCardData: Identifiable, Hashable {
    id: UUID
    sender: KudosUser
    receiver: KudosUser
    timestamp: String          // "10:00 - 10/30/2025"
    categoryTitle: String      // "IDOL GIỚI TRẺ"
    message: String
    hashtags: [String]
    heartCount: Int
    heartCountDisplay: String  // "1.000"
    isHighlight: Bool          // drives carousel active/faded opacity
}
```

### KudosStats (KudosStats.swift)
```swift
struct KudosStats: Hashable {
    kudosReceived: Int
    kudosSent: Int
    heartsReceived: Int
    secretBoxOpened: Int
    secretBoxUnopened: Int
}
```

### GiftRecipient (GiftRecipient.swift)
```swift
struct GiftRecipient: Identifiable, Hashable {
    id: UUID
    name: String
    department: String
    rewardDescription: String  // "Nhận được 1 áo phỏng SAA"
}
```

---

## Mock Data Source (Figma text lifted from frame image)

| Component | Mock value | Figma source |
|-----------|-----------|--------------|
| Hero tagline | "Hệ thống ghi nhận và cảm ơn" | Frame A, text above KUDOS wordmark |
| Send button | "Hôm nay, bạn muốn gửi kudos đến ai?" | Frame A.1 |
| Filter pills | "Hashtag", "Phòng ban" | Frame B.1 |
| Sender name | "Huỳnh Dương Xuân..." | Frame B.3.2 |
| Sender code | "CECV10" | Frame B.3.2 |
| Receiver name | "Dương Xuân Huỳnh..." | Frame B.3.6 |
| Sender badge | "Rising Hero" | Frame B.3.2 (orange pill) |
| Receiver badge | "Legend Hero" | Frame B.3.6 (red pill) |
| Timestamp | "10:00 - 10/30/2025" | Frame B.4.1 |
| Category | "IDOL GIỚI TRẺ" | Frame B.4.2 |
| Message | "Cảm ơn người em bình thường nhưng phi thường :D..." | Frame B.4.2 |
| Hashtags | "#Dedicated #Inspiring" | Frame B.4.3 |
| Heart count | "1.000" | Frame B.4.4 |
| Page indicator | "2/5" → 5 cards, default index 1 | Frame B.5.2 |
| Spotlight count | "388 KUDOS" | Frame B.7.1 |
| Stats values | all "25" | Frame D.1.2–D.1.7 |
| Recipient name | "Huỳnh Dương Xuân" | Frame D.3.2 |
| Reward text | "Nhận được 1 áo phỏng SAA" | Frame D.3.2 |

---

## Localization Keys Added

19 keys added to `Services/Localizer.swift` VN dict:
`kudos.tagline`, `kudos.send.placeholder`, `kudos.filter.hashtag`, `kudos.filter.department`,
`kudos.section.highlight`, `kudos.section.spotlight`, `kudos.section.allKudos`,
`kudos.section.topRecipients`, `kudos.stats.received`, `kudos.stats.sent`,
`kudos.stats.hearts`, `kudos.stats.boxOpened`, `kudos.stats.boxUnopened`,
`kudos.btn.openBox`, `kudos.btn.copyLink`, `kudos.btn.detail`, `kudos.btn.viewAll`,
`kudos.search.placeholder`

EN/JA left as empty-string placeholders per project convention.

---

## Visual Validation

| Section | Match | Notes |
|---------|-------|-------|
| A — Hero | PASS (structural) | KeyvisualBG reused; KUDOS wordmark + SunBrandSShape + tagline correct |
| A.1 — Send button | PASS | Glass pill, pencil icon, correct text |
| B.1 — Filter pills | PASS | Two chevron pills, Hashtag + Phòng ban |
| B.2 — Section header | PASS | Gold subtitle + white title pattern matches Figma |
| B.3/B.4 — Highlight card | PASS (structural) | Cream card, sender▶receiver, timestamp, category, message, hashtags, heart+actions |
| B.5 — Pagination | PASS | < 2/5 > row with circle chevron buttons |
| B.6/B.7 — Spotlight | PARTIAL | Count badge + search field correct; network chart is Canvas placeholder — NOT pixel-faithful (real interactive chart deferred) |
| C.1 — All Kudos header | PASS | |
| D.1 — Stats block | PASS | 5 rows with gold values + flame badge on hearts row |
| D.2 — Secret Box | PASS | Yellow CTA, disabled state wired |
| D.3 — Recipients | PASS | Boxed list with avatar placeholder + name + reward |
| C.3 — Feed cards | PASS (structural) | 3 full-width KudosCard instances |
| C.2 — View all link | PASS | Gold text + arrow.up.right |

Build check: NOT RUN — Bash permission was denied. Manual static analysis performed instead.

---

## Open Issues for Orchestrator

1. **Build verification pending** — `xcodebuild` could not run (Bash permission denied). Needs manual build run to confirm compilation. The static analysis shows no issues.
2. **Spotlight network chart (B.7.2)** — currently a Canvas dot-line placeholder. The Figma shows an interactive pan/zoom network graph. The real implementation requires a custom chart library or Metal-based view — out of scope for static UI.
3. **Avatar images** — all user avatars are SF Symbol `person.fill` on a solid color disk. Real avatars loaded from `users.avatar_url` are wired by the orchestrator in the integration phase.
4. **x2 fire badge (D.1.4)** — Figma shows a flame+number badge. Implemented with `SF Symbol flame.fill`. If the design calls for an extracted image asset, re-source from Figma media files node `I6885:9088;89:2249` (currently `null` URL — asset not uploaded to Figma cloud).
5. **KudosTabViewContainer** currently ignores `TokenStore` — when the ViewModel gains real service dependencies (Phase 6 API wiring), update the container to bridge `@EnvironmentObject` into the ViewModel init, matching the `HomeViewContainer` pattern.
6. **Localization key usage** — `SectionHeader`, `KudosFilterRow`, etc. use string literals directly (e.g. `"Sun* Annual Awards 2025"`) for the subtitle text that repeats across sections. The orchestrator may want to add a `kudos.subtitle.saa2025` key.
7. **`KudosTabView` and `KudosTabViewContainer` both in scope** — `MainTabView` now uses `KudosTabViewContainer` but the old stub `KudosTabView` is replaced. Verify `KudosFeedView.swift` and `KudosOverviewView.swift` stubs remain untouched (they were not in this task's scope).
