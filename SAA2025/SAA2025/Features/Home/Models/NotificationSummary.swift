//
//  NotificationSummary.swift
//  SAA2025
//

import Foundation

// MARK: - NotificationSummary Model

/// Lightweight summary for the notification bell badge on the Home nav bar.
struct NotificationSummary: Hashable {
    let unreadCount: Int
}
