//
//  KudosStats.swift
//  SAA2025
//

import Foundation

// MARK: - KudosStats

/// Personal stats block for the authenticated user (Section D.1).
struct KudosStats: Hashable {
    let kudosReceived: Int
    let kudosSent: Int
    let heartsReceived: Int
    let secretBoxOpened: Int
    let secretBoxUnopened: Int
}
