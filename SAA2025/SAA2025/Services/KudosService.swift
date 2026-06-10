//
//  KudosService.swift
//  SAA2025
//

import Foundation

// MARK: - Protocol

protocol KudosService {
    func loadKudos() async throws -> KudosInfo
}

// MARK: - Fake Implementation (Stub)

/// FakeKudosService: returns the canonical Kudos hero content after simulated delay.
/// Feature-flag gating is the ViewModel's responsibility — service always returns
/// the payload when called.
final class FakeKudosService: KudosService {

    private let delay: Duration

    /// - Parameter delay: Simulated network latency. Defaults to `Config.mockApiDelay`.
    init(delay: Duration = Config.mockApiDelay) {
        self.delay = delay
    }

    func loadKudos() async throws -> KudosInfo {
        try await Task.sleep(for: delay)
        return KudosInfo(
            isAvailable: true,
            bannerImageName: "KudosBanner",
            descriptionText: "Hoạt động ghi nhận và cảm ơn đồng nghiệp — lần đầu tiên được diễn ra dành cho tất cả Sunner. Hoạt động sẽ được triển khai vào tháng 11/2025, khuyến khích người Sun* chia sẻ những lời ghi nhận, cảm ơn đồng nghiệp trên hệ thống do BTC công bố. Đây sẽ là chất liệu để Hội đồng Heads tham khảo trong quá trình lựa chọn người đạt giải.",
            badgeText: "ĐIỂM MỚI CỦA SAA 2025"
        )
    }
}
