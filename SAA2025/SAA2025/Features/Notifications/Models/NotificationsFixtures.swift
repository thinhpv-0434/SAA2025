//
//  NotificationsFixtures.swift
//  SAA2025
//

import Foundation

// MARK: - NotificationsFixtures

/// In-memory fixtures for the Notifications screen — mirror the 7 rows on
/// the Figma frame so visual review can land without a backend.
enum NotificationsFixtures {

    static let items: [NotificationItem] = [
        NotificationItem(
            id: UUID(),
            iconKind: .kudoReceived,
            message: "Sunner Huỳnh Dương Xuân Nhật vừa gửi đến bạn lời ghi nhận đầy yêu thương!",
            linkText: nil,
            timestamp: "15 phút trước",
            isUnread: true
        ),
        NotificationItem(
            id: UUID(),
            iconKind: .heartReceived,
            message: "Wow! Lời nhắn gửi của bạn cho Sunner <tên Sunner> vừa nhận thêm lượt tim!",
            linkText: nil,
            timestamp: "1 giờ trước",
            isUnread: false
        ),
        NotificationItem(
            id: UUID(),
            iconKind: .secretBox,
            message: "Chúc mừng! Bạn vừa nhận được lượt mở Secret Box mới! Click vào đây để mở ngay nhé!",
            linkText: nil,
            timestamp: "1 ngày trước",
            isUnread: false
        ),
        NotificationItem(
            id: UUID(),
            iconKind: .levelUp,
            message: "Bạn nhận được <X> lời nhắn gửi từ đồng nghiệp và thăng hạng <tên level>!\nTiếp tục lan tỏa năng lượng tích cực đến đồng nghiệp nhé!",
            linkText: nil,
            timestamp: "1 ngày trước",
            isUnread: false
        ),
        NotificationItem(
            id: UUID(),
            iconKind: .warning,
            message: "Tiếc quá! Bạn có một lời nhắn bị tạm ẩn vì \"vướng\" một số tiêu chuẩn! Hãy xem các tiêu chuẩn và gửi lại cho đồng đội nhé!",
            linkText: "Tiêu chuẩn cộng đồng",
            timestamp: "1 tháng trước",
            isUnread: false
        ),
        NotificationItem(
            id: UUID(),
            iconKind: .badgeComplete,
            message: "Chúc mừng bạn đã thu thập đủ 6 huy hiệu của SAA. Bạn đã nhận được phần quà từ BTC chính là <X>. BTC sẽ liên hệ để gửi quà đến bạn vào cuối sự kiện.",
            linkText: nil,
            timestamp: "1 tháng trước",
            isUnread: false
        ),
        NotificationItem(
            id: UUID(),
            iconKind: .flagged,
            message: "\"Có <x> lời nhắn cần bạn xem xét!\"\nMột lời nhắn vừa bị hệ thống gắn cờ nghi ngờ vi phạm tiêu chuẩn. Vui lòng kiểm tra và xác nhận trạng thái: Hợp lệ / Tạm ẩn / Reject.",
            linkText: nil,
            timestamp: "1 tháng trước",
            isUnread: false
        )
    ]
}
