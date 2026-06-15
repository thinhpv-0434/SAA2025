//
//  SunnerSearchResult.swift
//  SAA2025
//

import Foundation

// MARK: - SunnerSearchResult

/// Lightweight row payload for the global sunner search. The full
/// `ProfileUser` is constructed lazily when the user taps through to a
/// profile — keeps the search list cheap to load and easy to mock.
struct SunnerSearchResult: Identifiable, Hashable {
    let id: UUID
    let displayName: String
    let employeeCode: String
    let badgeTier: ProfileBadgeTier
}

// MARK: - SearchFixtures

/// Pool the FakeSearchService filters against. Names are seeded with the
/// "Dương" stem so the typing demo on the Figma frame ("Dương|") returns
/// two matches.
enum SearchFixtures {
    static let pool: [SunnerSearchResult] = [
        SunnerSearchResult(id: UUID(), displayName: "Dương Huỳnh Xuân Nhật", employeeCode: "CECV1", badgeTier: .rising),
        SunnerSearchResult(id: UUID(), displayName: "Dương Huỳnh Xuân Nhân", employeeCode: "CECV1", badgeTier: .rising),
        SunnerSearchResult(id: UUID(), displayName: "Huỳnh Dương Xuân Nhật", employeeCode: "CEVC3", badgeTier: .legend),
        SunnerSearchResult(id: UUID(), displayName: "Trần Minh Quân", employeeCode: "CEDV8", badgeTier: .rising),
        SunnerSearchResult(id: UUID(), displayName: "Lê Bảo Nam", employeeCode: "CECA2", badgeTier: .legend),
        SunnerSearchResult(id: UUID(), displayName: "Phạm Quỳnh Anh", employeeCode: "CECB6", badgeTier: .rising),
        SunnerSearchResult(id: UUID(), displayName: "Nguyễn Thảo Linh", employeeCode: "CEDB4", badgeTier: .legend)
    ]

    /// Recent-search seed used until persistence is wired up — the design
    /// shows two cards under the "Recent" header.
    static let recent: [SunnerSearchResult] = [
        pool[2],
        pool[2]
    ]
}
