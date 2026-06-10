//
//  KudosInfo.swift
//  SAA2025
//

import Foundation

// MARK: - KudosInfo Model

/// Represents the Kudos feature banner data shown on the Home screen.
/// `isAvailable` drives the `Config.isKudosAvailable` feature flag.
struct KudosInfo: Hashable {
    let isAvailable: Bool
    let bannerImageName: String
    let descriptionText: String
    let badgeText: String
}
