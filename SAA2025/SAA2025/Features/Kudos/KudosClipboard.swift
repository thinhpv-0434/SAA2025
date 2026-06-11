//
//  KudosClipboard.swift
//  SAA2025
//
//  Shared helper for the "Copy Link" action used by KudosCard (carousel + feed),
//  KudosOverviewView, and KudosDetailView. Builds the canonical kudos URL and
//  writes it to the system pasteboard. Calling sites are responsible for showing
//  any user-facing feedback (toast).
//

import Foundation
import UIKit

// MARK: - KudosClipboard

enum KudosClipboard {

    /// Canonical deep-link format for a Kudo.
    static func link(for kudoId: UUID) -> String {
        "saa2025://kudos/\(kudoId.uuidString)"
    }

    /// Write the kudo link to `UIPasteboard.general`. Idempotent.
    @discardableResult
    static func copy(kudoId: UUID) -> String {
        let link = link(for: kudoId)
        UIPasteboard.general.string = link
        return link
    }
}
