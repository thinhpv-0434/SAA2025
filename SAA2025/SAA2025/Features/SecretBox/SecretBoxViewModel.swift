//
//  SecretBoxViewModel.swift
//  SAA2025
//

import Combine
import Foundation

// MARK: - SecretBoxState

/// Drives the visual on `SecretBoxView`. Mirrors the three Figma states
/// (mm:6885:9402 unopened, mm:6885:9532 about-to-open, mm:6885:9577+
/// revealed) and is owned by `SecretBoxViewModel`.
enum SecretBoxState {
    case unopened
    case opening
    case revealed(SecretBoxReward)

    var isUnopened: Bool {
        if case .unopened = self { return true }
        return false
    }

    var revealedReward: SecretBoxReward? {
        if case .revealed(let r) = self { return r }
        return nil
    }
}

// MARK: - SecretBoxViewModel

/// Tap-to-open mini state machine. Holds the remaining-unopened count and
/// the current reveal. Until the prize draw moves server-side, the next
/// reward is picked from `SecretBoxFixtures.pool`.
@MainActor
final class SecretBoxViewModel: ObservableObject {

    @Published private(set) var state: SecretBoxState = .unopened
    @Published private(set) var unopenedCount: Int

    private var rewardCursor: Int = 0

    init(unopenedCount: Int = 5) {
        self.unopenedCount = unopenedCount
    }

    /// Called when the user taps the gift box. No-op if no unopened boxes
    /// remain or if we're mid-animation.
    func openNext() {
        guard case .unopened = state else { return }
        guard unopenedCount > 0 else { return }

        state = .opening

        Task {
            try? await Task.sleep(for: .milliseconds(700))
            let pool = SecretBoxFixtures.pool
            let reward = pool[rewardCursor % pool.count]
            rewardCursor &+= 1
            state = .revealed(reward)
            unopenedCount -= 1
        }
    }

    /// Called by the "Mở thêm Secret Box" CTA on the reveal screen.
    /// Resets to unopened so the user can roll again.
    func resetToUnopened() {
        guard unopenedCount > 0 else { return }
        state = .unopened
    }
}
