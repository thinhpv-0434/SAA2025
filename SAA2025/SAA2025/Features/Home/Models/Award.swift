//
//  Award.swift
//  SAA2025
//

import Foundation

// MARK: - Award Model

/// Represents an award category. Used by both the Home awards carousel
/// (compact fields) and the Awards tab (full fields including longDescription,
/// quantity, awardValue). Extra fields default to empty so legacy call sites
/// remain source-compatible.
struct Award: Identifiable, Hashable {
    let id: UUID
    let title: String
    let shortDescription: String
    let imageName: String
    let longDescription: String
    let quantity: String
    let awardValue: String

    init(
        id: UUID,
        title: String,
        shortDescription: String,
        imageName: String,
        longDescription: String = "",
        quantity: String = "",
        awardValue: String = ""
    ) {
        self.id = id
        self.title = title
        self.shortDescription = shortDescription
        self.imageName = imageName
        self.longDescription = longDescription
        self.quantity = quantity
        self.awardValue = awardValue
    }
}
