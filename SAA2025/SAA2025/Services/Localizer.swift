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

/// App-wide string lookup. Selected language persists across launches via
/// UserDefaults. Views observe `lang` and re-render when the user picks
/// a different flag in the LanguagePicker.
final class Localizer: ObservableObject {

    private static let storageKey = "SAA2025.selectedLang"

    @Published var lang: Lang {
        didSet { UserDefaults.standard.set(lang.rawValue, forKey: Self.storageKey) }
    }

    init() {
        if let raw = UserDefaults.standard.string(forKey: Self.storageKey),
           let stored = Lang(rawValue: raw) {
            self.lang = stored
        } else {
            self.lang = .vn
        }
    }

    func t(_ key: String) -> String {
        let dict: [String: String]
        switch lang {
        case .vn: dict = StringsVN.table
        case .en: dict = StringsEN.table
        case .ja: dict = StringsJA.table
        }
        return dict[key] ?? StringsVN.table[key] ?? key
    }
}
