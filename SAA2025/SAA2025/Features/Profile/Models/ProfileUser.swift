//
//  ProfileUser.swift
//  SAA2025
//

import Foundation

// MARK: - ProfileUser

/// Authenticated user shown at the top of the Profile tab.
/// Mirrors the small surface required by the design (avatar + display name +
/// employee code + earned badge). Backed by fixture data until the real
/// `/me` endpoint is wired up.
struct ProfileUser: Hashable {
    let displayName: String
    let employeeCode: String
    let badgeLabel: String
    let avatarSystemName: String

    static let mock = ProfileUser(
        displayName: "Huỳnh Dương Xuân Nhật",
        employeeCode: "CEVC3",
        badgeLabel: "Legend Hero",
        avatarSystemName: "person.crop.circle.fill"
    )
}
