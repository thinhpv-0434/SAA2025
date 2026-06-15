//
//  KudosFixtures.swift
//  SAA2025
//

import Foundation

// MARK: - KudosFixtures

/// In-memory fixtures consumed by `FakeKudosService` and SwiftUI previews.
/// Single source of mock truth for the Sun*Kudos screen.
enum KudosFixtures {

    // MARK: Filter taxonomy

    static let hashtags: [Hashtag] = [
        Hashtag(id: "h-dedicated", name: "Dedicated"),
        Hashtag(id: "h-inspiring", name: "Inspiring"),
        Hashtag(id: "h-teamwork", name: "Teamwork"),
        Hashtag(id: "h-innovation", name: "Innovation"),
        Hashtag(id: "h-giveback", name: "GiveBack")
    ]

    static let departments: [Department] = [
        Department(id: "d-a", name: "Division A"),
        Department(id: "d-b", name: "Division B"),
        Department(id: "d-c", name: "Division C"),
        Department(id: "d-ops", name: "Operations")
    ]

    // MARK: Stats + spotlight

    static let stats = KudosStats(
        kudosReceived: 25,
        kudosSent: 25,
        heartsReceived: 25,
        secretBoxOpened: 25,
        secretBoxUnopened: 25
    )

    static let recipients: [GiftRecipient] = [
        GiftRecipient(id: UUID(), name: "Huỳnh Dương Xuân", department: "Division A", rewardDescription: "Nhận được 1 áo phỏng SAA"),
        GiftRecipient(id: UUID(), name: "Dương Xuân Huỳnh", department: "Division A", rewardDescription: "Nhận được 1 áo phỏng SAA"),
        GiftRecipient(id: UUID(), name: "Trần Minh Quân", department: "Division B", rewardDescription: "Nhận được 1 áo phỏng SAA")
    ]

    // MARK: Cards

    /// Five highlight cards with varying hashtag + department combinations to exercise filter AND-logic.
    static let cards: [KudosCardData] = buildCards()

    private static func buildCards() -> [KudosCardData] {
        let sender = KudosUser(
            id: UUID(),
            name: "Huỳnh Dương Xuân...",
            employeeCode: "CECV10",
            department: "Division A",
            badgeLabel: "Rising Hero",
            badgeTier: .one
        )
        let receiver = KudosUser(
            id: UUID(),
            name: "Dương Xuân Huỳnh...",
            employeeCode: "CECV10",
            department: "Division A",
            badgeLabel: "Legend Hero",
            badgeTier: .two
        )
        let category = "IDOL GIỚI TRẺ"
        let message = "Cảm ơn người em bình thường nhưng phi thường :D Cảm ơn sự chăm chỉ, cần mẫn của em đã tạo động lực rất..."

        // Each card varies hashtag mix + department to support filter tests.
        let tagSets: [[String]] = [
            ["#Dedicated", "#Inspiring", "#Teamwork"],
            ["#Inspiring", "#Innovation"],
            ["#Dedicated", "#Inspiring", "#GiveBack", "#Teamwork"],
            ["#Innovation", "#Dedicated"],
            ["#Teamwork", "#GiveBack"]
        ]
        let deptIds = ["d-a", "d-b", "d-a", "d-c", "d-a"]
        let hearts = [1000, 845, 720, 612, 540]

        return (0..<5).map { idx in
            KudosCardData(
                id: UUID(),
                sender: sender,
                receiver: receiver,
                timestamp: "10:00 - 10/30/2025",
                categoryTitle: category,
                message: message,
                hashtags: tagSets[idx],
                heartCount: hearts[idx],
                heartCountDisplay: formatThousands(hearts[idx]),
                isHighlight: idx == 1,
                isLiked: false,
                isOwn: false,
                departmentId: deptIds[idx],
                // Mark the first sent-kudo as spam to mirror the Figma "Đã gửi" state.
                isSpam: idx == 0
            )
        }
    }

    // MARK: Helpers

    private static let groupingFormatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.groupingSeparator = "."
        fmt.usesGroupingSeparator = true
        return fmt
    }()

    static func formatThousands(_ count: Int) -> String {
        groupingFormatter.string(from: NSNumber(value: count)) ?? "\(count)"
    }
}
