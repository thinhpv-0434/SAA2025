//
//  Localizer.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import Foundation
import Combine

// MARK: - Lang

enum Lang: String, CaseIterable, Identifiable {
    case vn = "VN"
    case en = "EN"
    case ja = "JA"

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .vn: return "🇻🇳"
        case .en: return "🇬🇧"
        case .ja: return "🇯🇵"
        }
    }
}

// MARK: - Localizer

/// Localizer service — VN strings are populated; EN/JA are placeholder dicts.
/// Actual runtime re-rendering on language switch is deferred to a follow-up.
final class Localizer: ObservableObject {

    @Published var lang: Lang = .vn

    // MARK: - String Dictionaries

    private let vn: [String: String] = [
        "login.tagline": "Bắt đầu hành trình của bạn cùng SAA 2025.\nĐăng nhập để khám phá!",
        "login.button": "LOGIN With Google",
        "login.copyright": "Bản quyền thuộc về Sun* © 2025",
        "home.welcome": "Chào mừng đến SAA 2025",
        "home.logout": "Đăng xuất",
        "error.title": "Đăng nhập thất bại",
        "error.message": "Vui lòng thử lại.",

        // MARK: Kudos screen keys
        "kudos.tagline": "Hệ thống ghi nhận và cảm ơn",
        "kudos.send.placeholder": "Hôm nay, bạn muốn gửi kudos đến ai?",
        "kudos.filter.hashtag": "Hashtag",
        "kudos.filter.department": "Phòng ban",
        "kudos.section.highlight": "HIGHLIGHT KUDOS",
        "kudos.section.spotlight": "SPOTLIGHT BOARD",
        "kudos.section.allKudos": "ALL KUDOS",
        "kudos.section.topRecipients": "10 SUNNER NHẬN QUÀ MỚI NHẤT",
        "kudos.stats.received": "Số Kudos bạn nhận được:",
        "kudos.stats.sent": "Số Kudos bạn đã gửi:",
        "kudos.stats.hearts": "Số tim bạn nhận được:",
        "kudos.stats.boxOpened": "Số Secret Box bạn đã mở:",
        "kudos.stats.boxUnopened": "Số Secret Box chưa mở:",
        "kudos.btn.openBox": "Mở Secret Box",
        "kudos.btn.copyLink": "Copy Link",
        "kudos.btn.detail": "Xem chi tiết",
        "kudos.btn.viewAll": "View all Kudos",
        "kudos.search.placeholder": "Tìm kiếm"
    ]

    // Placeholder — translations deferred
    private let en: [String: String] = [:]
    private let ja: [String: String] = [:]

    // MARK: - Public API

    func t(_ key: String) -> String {
        switch lang {
        case .vn:
            return vn[key] ?? key
        case .en:
            return en[key] ?? key
        case .ja:
            return ja[key] ?? key
        }
    }
}
