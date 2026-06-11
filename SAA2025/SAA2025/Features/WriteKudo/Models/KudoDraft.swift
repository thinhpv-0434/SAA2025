//
//  KudoDraft.swift
//  SAA2025
//
//  Domain model for the Write Kudo composer (mm:6885:9271).
//

import Foundation

// MARK: - KudoDraft

/// A fully-validated kudo ready for submission.
/// The composer ViewModel builds this in-memory; `KudosService.submitKudo`
/// consumes it. Plain text only — toolbar formatting is visual-only for v1.
struct KudoDraft: Hashable {
    let recipient: KudosUser
    let title: String            // 1..100 chars
    let message: String          // 1..1000 chars, plain text
    let hashtags: [String]       // 1..5 entries, normalized to "#Tag"
    let imageAssetNames: [String] // 0..5 mock asset names
    let isAnonymous: Bool
}

// MARK: - Validation constants

enum KudoDraftLimits {
    static let titleMax: Int = 100
    static let messageMax: Int = 1000
    static let hashtagMax: Int = 5
    static let imageMax: Int = 5
}

// MARK: - KudoImageAttachment

/// Wraps a mock asset name with a stable identity so SwiftUI `ForEach` can
/// safely render duplicates (the mock-asset pool cycles a small set of names).
struct KudoImageAttachment: Identifiable, Hashable {
    let id: UUID
    let assetName: String

    init(assetName: String, id: UUID = UUID()) {
        self.id = id
        self.assetName = assetName
    }
}
