//
//  AwardsService.swift
//  SAA2025
//

import Foundation

// MARK: - Protocol

protocol AwardsService {
    func loadAwards() async throws -> [Award]
}

// MARK: - Fake Implementation (Stub)

/// FakeAwardsService: returns 3 hardcoded awards after a simulated network delay.
/// Replace with RealAwardsService when backend API is ready — swap via DI without
/// touching ViewModel.
final class FakeAwardsService: AwardsService {

    private let delay: Duration

    /// - Parameter delay: Simulated network latency. Defaults to `Config.mockApiDelay`.
    init(delay: Duration = Config.mockApiDelay) {
        self.delay = delay
    }

    func loadAwards() async throws -> [Award] {
        try await Task.sleep(for: delay)
        return [
            Award(
                id: UUID(),
                title: "Top Talent",
                shortDescription: "Giải thưởng Top Talent vinh danh những cá nhân xuất sắc nhất.",
                imageName: "TopTalentBadge"
            ),
            Award(
                id: UUID(),
                title: "Top Project",
                shortDescription: "Giải thưởng Top Project vinh danh những tập thể dự án xuất sắc nhất.",
                imageName: "TopProjectBadge"
            ),
            Award(
                id: UUID(),
                title: "Top Innovation",
                shortDescription: "Giải thưởng Top Innovation vinh danh những sáng kiến đột phá.",
                imageName: "TopInnovationBadge"
            )
        ]
    }
}
