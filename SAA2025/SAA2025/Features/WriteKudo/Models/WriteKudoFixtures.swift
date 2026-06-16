//
//  WriteKudoFixtures.swift
//  SAA2025
//
//  Mock data for the Write Kudo composer.
//

import Foundation

// MARK: - WriteKudoFixtures

enum WriteKudoFixtures {

    /// Fake teammate roster shown in the recipient picker.
    /// Current user (`currentUserId`) is excluded by `FakeKudosService.loadRecipients`.
    static let allUsers: [KudosUser] = [
        KudosUser(id: UUID(), name: "Huỳnh Dương Xuân", employeeCode: "CECV10", department: "Division A", badgeLabel: "Rising Hero", badgeTier: .one),
        KudosUser(id: UUID(), name: "Dương Xuân Huỳnh", employeeCode: "CECV11", department: "Division A", badgeLabel: "Legend Hero", badgeTier: .two),
        KudosUser(id: UUID(), name: "Trần Minh Quân", employeeCode: "CECV12", department: "Division B", badgeLabel: nil, badgeTier: .none),
        KudosUser(id: UUID(), name: "Lê Thị Hồng Nhung", employeeCode: "CECV13", department: "Division C", badgeLabel: "Rising Hero", badgeTier: .one),
        KudosUser(id: UUID(), name: "Phạm Văn Thịnh", employeeCode: "CECV01", department: "Operations", badgeLabel: nil, badgeTier: .none),  // current user — filtered out
        KudosUser(id: UUID(), name: "Nguyễn Văn An", employeeCode: "CECV14", department: "Operations", badgeLabel: nil, badgeTier: .none),
        KudosUser(id: UUID(), name: "Vũ Thị Lan", employeeCode: "CECV15", department: "Division A", badgeLabel: "Legend Hero", badgeTier: .two),
        KudosUser(id: UUID(), name: "Đỗ Quang Huy", employeeCode: "CECV16", department: "Division B", badgeLabel: nil, badgeTier: .none)
    ]

    /// Employee code of the "current user" — excluded from recipient list.
    static let currentUserCode: String = "CECV01"

    /// Mock image asset names that the "+ Image" button cycles through.
    /// Reuses existing assets in `Assets.xcassets` so previews render something visible.
    /// v1 mock — replace with PHPicker output when real upload lands.
    static let mockImageAssetCycle: [String] = ["AwardBadgeBG", "AwardBadgeBG", "AwardBadgeBG"]
}
