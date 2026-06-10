//
//  KudosHighlight.swift
//  SAA2025
//

import Foundation

// MARK: - KudosUser

struct KudosUser: Identifiable, Hashable {
    let id: UUID
    let name: String
    let employeeCode: String
    let department: String
    let badgeLabel: String?   // e.g. "Rising Hero", "Legend Hero"
    let badgeTier: KudosBadgeTier
}

// MARK: - KudosBadgeTier

enum KudosBadgeTier: Int, Hashable {
    case none = 0
    case one = 1
    case two = 2
    case three = 3

    /// Stars awarded: 10+ hearts → 1★, 20+ → 2★, 50+ → 3★
    init(heartCount: Int) {
        if heartCount >= 50 { self = .three }
        else if heartCount >= 20 { self = .two }
        else if heartCount >= 10 { self = .one }
        else { self = .none }
    }
}

// MARK: - KudosCardData

struct KudosCardData: Identifiable, Hashable {
    let id: UUID
    let sender: KudosUser
    let receiver: KudosUser
    let timestamp: String         // e.g. "10:00 - 10/30/2025"
    let categoryTitle: String     // e.g. "IDOL GIỚI TRẺ"
    let message: String
    let hashtags: [String]        // e.g. ["#Dedicated", "#Inspiring"]
    let heartCount: Int           // e.g. 1000
    let heartCountDisplay: String // e.g. "1.000"
    let isHighlight: Bool         // true = carousel center card variant
    let isLiked: Bool             // current user's like state (TC_FUN_007)
    let isOwn: Bool               // sender == current user → heart disabled (TC_FUN_008)
    let departmentId: String      // receiver department id (filter target)
}

extension KudosCardData {
    /// Convenience: derive a refreshed snapshot with toggled like state and adjusted count.
    /// Uses the shared `KudosFixtures.formatThousands` formatter (DRY).
    func withLikeToggled() -> KudosCardData {
        let nowLiked = !isLiked
        let delta = nowLiked ? 1 : -1
        let newCount = heartCount + delta
        return KudosCardData(
            id: id,
            sender: sender,
            receiver: receiver,
            timestamp: timestamp,
            categoryTitle: categoryTitle,
            message: message,
            hashtags: hashtags,
            heartCount: newCount,
            heartCountDisplay: KudosFixtures.formatThousands(newCount),
            isHighlight: isHighlight,
            isLiked: nowLiked,
            isOwn: isOwn,
            departmentId: departmentId
        )
    }
}
