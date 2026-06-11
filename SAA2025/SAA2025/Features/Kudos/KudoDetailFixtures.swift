//
//  KudoDetailFixtures.swift
//  SAA2025
//
//  Mock data for KudosDetailView extracted verbatim from Figma design
//  (fileKey: 9ypp4enmFmdK3YAFJLIu6C, screenId: T0TR16k0vH)
//

import Foundation

// MARK: - KudoDetailFixtures

enum KudoDetailFixtures {

    // mm:I6885:10150;89:2600 — sender name
    static let senderUser = KudosUser(
        id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000001")!,
        name: "Huỳnh Dương Xuân...",
        employeeCode: "CEHN02",
        department: "CE",
        badgeLabel: "Rising Hero",
        badgeTier: .one
    )

    // mm:I6885:10153;89:2600 — receiver name
    static let receiverUser = KudosUser(
        id: UUID(uuidString: "A1B2C3D4-0002-0002-0002-000000000002")!,
        name: "Dương Xuân Huỳnh...",
        employeeCode: "CECV10",
        department: "CE",
        badgeLabel: "Legend Hero",
        badgeTier: .three
    )

    // mm:6885:10155 — postedAt | mm:6885:10156 — title | mm:6885:10161 — body
    static let sampleDetail = KudoDetail(
        id: UUID(uuidString: "D4E5F6A7-0003-0003-0003-000000000003")!,
        sender: senderUser,
        receiver: receiverUser,
        title: "NGƯỜI HÙNG CỦA LÒNG EM",
        postedAt: "10:00 - 10/30/2025",
        message: "Cảm ơn người em bình thường nhưng phi thường :D Cảm ơn sự chăm chỉ, cần mẫn của em đã tạo động lực rất nhiều cho team, để luôn nhắc mình luôn phải nỗ lực hơn nữa trong công việc. <3 và cuộc sống",
        attachedImages: Array(repeating: "photo.fill", count: 5),
        hashtags: ["#Dedicated", "#Inspiring", "#Dedicated", "#Inspiring", "#Dedicated"],
        heartCount: 10,
        isLiked: true,
        isOwn: false
    )
}
