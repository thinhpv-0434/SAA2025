//
//  NotificationItem.swift
//  SAA2025
//

import SwiftUI

// MARK: - NotificationIconKind

/// Coloured icon chip rendered on the left of each row. Each kind maps to
/// an SF Symbol + tint so the row composer never has to think about glyph
/// or color choice. Reflects the seven variants on the Figma frame.
enum NotificationIconKind: Hashable {
    case kudoReceived
    case heartReceived
    case secretBox
    case levelUp
    case warning
    case badgeComplete
    case flagged

    var systemName: String {
        switch self {
        case .kudoReceived:   return "envelope.fill"
        case .heartReceived:  return "heart.fill"
        case .secretBox:      return "gift.fill"
        case .levelUp:        return "star.fill"
        case .warning:        return "exclamationmark.triangle.fill"
        case .badgeComplete:  return "checklist"
        case .flagged:        return "flag.fill"
        }
    }

    var tint: Color {
        switch self {
        case .kudoReceived:   return Color(red: 0x5B / 255.0, green: 0x9B / 255.0, blue: 0xFF / 255.0)
        case .heartReceived:  return Color(red: 0xE6 / 255.0, green: 0x4A / 255.0, blue: 0x4A / 255.0)
        case .secretBox:      return Color(red: 0xE6 / 255.0, green: 0xB8 / 255.0, blue: 0x3A / 255.0)
        case .levelUp:        return Color(red: 0x4A / 255.0, green: 0xD8 / 255.0, blue: 0xD8 / 255.0)
        case .warning:        return Color(red: 0xE8 / 255.0, green: 0xC4 / 255.0, blue: 0x3A / 255.0)
        case .badgeComplete:  return Color(red: 0x5F / 255.0, green: 0xB8 / 255.0, blue: 0x55 / 255.0)
        case .flagged:        return Color(red: 0xE0 / 255.0, green: 0x4A / 255.0, blue: 0x9F / 255.0)
        }
    }
}

// MARK: - NotificationItem

/// One row in the notifications feed. Until the real backend lands the
/// list is populated from `NotificationsFixtures`.
struct NotificationItem: Identifiable, Hashable {
    let id: UUID
    let iconKind: NotificationIconKind
    let message: String
    /// Optional secondary line rendered as an underlined gold link
    /// ("Tiêu chuẩn cộng đồng" in the design).
    let linkText: String?
    /// Pre-formatted relative timestamp ("15 phút trước"). Until we wire a
    /// real Date here we keep it as a display string to match the design 1:1.
    let timestamp: String
    let isUnread: Bool
}
