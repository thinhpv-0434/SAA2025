//
//  Config.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import Foundation

// MARK: - Config

/// Central compile-time constants for SAA 2025.
/// Swap hardcoded values here once backend config endpoint is available.
enum Config {

    /// Target event date: 26 December 2026, 00:00 UTC.
    /// Used by the countdown timer on the Home screen.
    static let eventDate: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 12
        components.day = 26
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(identifier: "UTC")
        return Calendar.current.date(from: components) ?? Date(timeIntervalSince1970: 1798243200)
    }()

    /// Feature flag: show Kudos tab and FAB actions.
    /// Hardcoded true for MVP. Migrate to remote config or AppStorage when needed.
    static let isKudosAvailable: Bool = true

    /// Artificial delay injected by fake services in DEBUG builds.
    static let mockApiDelay: Duration = .seconds(1)
}
