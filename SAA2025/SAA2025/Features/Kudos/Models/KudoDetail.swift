//
//  KudoDetail.swift
//  SAA2025
//
//  Domain model for the Kudo detail screen (mm:6885:10128).
//

import Foundation

// MARK: - KudoDetail

struct KudoDetail: Identifiable, Hashable {
    let id: UUID
    let sender: KudosUser
    let receiver: KudosUser
    let title: String           // e.g. "NGƯỜI HÙNG CỦA LÒNG EM"
    let postedAt: String        // "10:00 - 10/30/2025"
    let message: String         // full body
    let attachedImages: [String]  // up to 5 — system image names for mocks
    let hashtags: [String]
    let heartCount: Int
    let isLiked: Bool
    let isOwn: Bool             // TC_FUN_008: sender == current user → heart disabled
}

// MARK: - Mapping from KudosCardData

extension KudoDetail {
    /// Build a detail snapshot from a list/card model.
    /// Title falls back to the card's `categoryTitle`. Attached images default
    /// to five placeholder SF Symbols so the row matches the design.
    init(from card: KudosCardData, attachedImages: [String]? = nil) {
        self.id = card.id
        self.sender = card.sender
        self.receiver = card.receiver
        self.title = card.categoryTitle
        self.postedAt = card.timestamp
        self.message = card.message
        self.attachedImages = attachedImages ?? Array(repeating: "photo.fill", count: 5)
        self.hashtags = card.hashtags
        self.heartCount = card.heartCount
        self.isLiked = card.isLiked
        self.isOwn = card.isOwn
    }
}

// MARK: - Like toggle helper

extension KudoDetail {
    func withLikeToggled() -> KudoDetail {
        let nowLiked = !isLiked
        let delta = nowLiked ? 1 : -1
        return KudoDetail(
            id: id,
            sender: sender,
            receiver: receiver,
            title: title,
            postedAt: postedAt,
            message: message,
            attachedImages: attachedImages,
            hashtags: hashtags,
            heartCount: max(0, heartCount + delta),
            isLiked: nowLiked,
            isOwn: isOwn
        )
    }
}
