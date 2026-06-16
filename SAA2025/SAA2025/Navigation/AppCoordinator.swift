//
//  AppCoordinator.swift
//  SAA2025
//

import Foundation
import Combine

// MARK: - AppCoordinator

/// Shared cross-tab navigation coordinator. Owns the currently-selected
/// `MainTabView` tab and any pending hand-off state (e.g. the Award title the
/// Home carousel wants the Awards tab to open with).
///
/// Lives at the AppRoot level and is injected as an `EnvironmentObject` so
/// any screen can trigger a tab switch + cross-tab payload in one call.
@MainActor
final class AppCoordinator: ObservableObject {

    enum Tab: Int, Hashable {
        case home, awards, kudos, profile
    }

    @Published var selectedTab: Tab = .home

    /// Title of the award the Awards tab should open with, set by Home when
    /// the user taps a card. The Awards tab consumes this on appear and
    /// resets it back to `nil` so subsequent direct tab taps fall through to
    /// the default selection.
    @Published var pendingAwardTitle: String? = nil

    /// Switch to the Awards tab and request an optional award pre-selection.
    /// Passing `nil` (e.g. from the Hero "About Award" button) keeps the
    /// Awards tab's own default selection.
    func openAwardsTab(withTitle title: String? = nil) {
        pendingAwardTitle = title
        selectedTab = .awards
    }
}
