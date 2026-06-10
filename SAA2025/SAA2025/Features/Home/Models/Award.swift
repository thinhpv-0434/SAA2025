//
//  Award.swift
//  SAA2025
//

import Foundation

// MARK: - Award Model

/// Represents an award category displayed on the Home screen awards carousel.
struct Award: Identifiable, Hashable {
    let id: UUID
    let title: String
    let shortDescription: String
    let imageName: String
}
