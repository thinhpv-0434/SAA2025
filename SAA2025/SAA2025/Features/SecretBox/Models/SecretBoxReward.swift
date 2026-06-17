//
//  SecretBoxReward.swift
//  SAA2025
//

import SwiftUI

// MARK: - SecretBoxReward

/// One possible reveal in the Secret Box flow. The case payload drives
/// both the illustration on the reveal screen and the caption beneath it.
enum SecretBoxReward: Hashable, Identifiable {
    /// A SAA limited-edition icon unlocks (Touch of Light, Stay Gold, ...).
    case icon(name: String, centerColor: Color, edgeColor: Color)
    /// A physical gift (stamps, mug, scarf, t-shirt).
    case item(name: String, kind: PhysicalItemKind)

    var id: String {
        switch self {
        case .icon(let name, _, _): return "icon:\(name)"
        case .item(let name, _):    return "item:\(name)"
        }
    }

    var caption: String {
        switch self {
        case .icon(let name, _, _): return name
        case .item(let name, _):    return name
        }
    }
}

// MARK: - PhysicalItemKind

enum PhysicalItemKind: Hashable {
    case stamps   // mm:6885:9667 — three Root Further stamps
    case mug      // mm:6885:9710 — Root Further mug
    case scarf    // mm:6885:9624 — Root Further scarf
    case tshirt   // mm:6885:9839 — Burberry t-shirt
}

// MARK: - Fixture pool

/// Rotation of rewards used by `SecretBoxViewModel` until the real
/// backend draws from the prize pool.
enum SecretBoxFixtures {
    static let pool: [SecretBoxReward] = [
        // Six SAA limited-edition icons, mirroring `ProfileEarnedBadge.showcase`
        .item(name: "Khăn Root Further", kind: .scarf),
        .item(name: "Cốc Root Further", kind: .mug),
        .item(name: "Bộ tem Root Further", kind: .stamps),
        .item(name: "Áo thun SAA 2025", kind: .tshirt)
    ]
}
