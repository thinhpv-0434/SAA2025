//
//  GiftRecipient.swift
//  SAA2025
//

import Foundation

// MARK: - GiftRecipient

/// A Sunner who received a physical or digital gift reward (Section D.3).
struct GiftRecipient: Identifiable, Hashable {
    let id: UUID
    let name: String
    let department: String
    let rewardDescription: String  // e.g. "Nhận được 1 áo phỏng SAA"
}
