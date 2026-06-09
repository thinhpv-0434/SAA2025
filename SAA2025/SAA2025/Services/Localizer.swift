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
        "error.message": "Vui lòng thử lại."
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
