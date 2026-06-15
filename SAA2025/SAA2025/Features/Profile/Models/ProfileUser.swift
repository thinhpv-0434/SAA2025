//
//  ProfileUser.swift
//  SAA2025
//

import Foundation
import SwiftUI

// MARK: - ProfileBadgeTier

/// Visual tier that colors the small pill rendered next to the employee
/// code. Mirrors `KudosBadgeTier` from the Kudos feature so two profile
/// screens can render any sunner from a single source of truth without
/// dragging the heart-count derivation along.
enum ProfileBadgeTier: Hashable {
    case rising
    case legend

    var pillColor: Color {
        switch self {
        case .rising: return Color(red: 0xE6 / 255.0, green: 0x7E / 255.0, blue: 0x2C / 255.0)
        case .legend: return Color(red: 0x8B / 255.0, green: 0x20 / 255.0, blue: 0x20 / 255.0)
        }
    }
}

// MARK: - ProfileUser

/// User shown on either profile screen — own (`ProfileTabView`) or someone
/// else's (`OtherProfileView`). Backed by fixture data until the real
/// directory endpoint is wired up.
struct ProfileUser: Hashable, Identifiable {
    var id: String { employeeCode }

    let displayName: String
    let employeeCode: String
    let badgeLabel: String
    let badgeTier: ProfileBadgeTier

    /// First+last initial extracted from `displayName`. Used as the avatar
    /// fallback when no real photo is available — the convention every chat
    /// app already trains users to recognise. For single-word names returns
    /// the first letter only.
    var initials: String {
        let parts = displayName
            .split(whereSeparator: { $0.isWhitespace })
            .map(String.init)
        guard let first = parts.first?.first else { return "?" }
        if parts.count == 1 {
            return String(first).uppercased()
        }
        let last = parts.last?.first ?? first
        return "\(first)\(last)".uppercased()
    }

    static let mock = ProfileUser(
        displayName: "Huỳnh Dương Xuân Nhật",
        employeeCode: "CEVC3",
        badgeLabel: "Legend Hero",
        badgeTier: .legend
    )

    /// Mock target user for the "view someone else's profile" screen.
    /// Mirrors the design: same display name as `.mock`, but a Rising-Hero
    /// pill so the orange/red distinction shows up against the Legend pill.
    static let mockOther = ProfileUser(
        displayName: "Huỳnh Dương Xuân Nhật",
        employeeCode: "CEVC3",
        badgeLabel: "Rising Hero",
        badgeTier: .rising
    )
}
