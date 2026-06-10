//
//  KudosService.swift
//  SAA2025
//

import Foundation

// MARK: - Protocol

protocol KudosService {
    /// Home screen banner content (existing — kept for backward compat).
    func loadKudos() async throws -> KudosInfo

    /// Top 5 kudos by heart count (DESC). B.2.3 — supports hashtag + department AND-filter.
    func loadHighlight(hashtagId: String?, departmentId: String?) async throws -> [KudosCardData]

    /// Paginated kudos feed for All Kudos section (C.3). AND-filter on both params.
    func loadKudosFeed(page: Int, limit: Int, hashtagId: String?, departmentId: String?) async throws -> [KudosCardData]

    /// Hashtag list for B.1.1 picker.
    func loadHashtags() async throws -> [Hashtag]

    /// Department list for B.1.2 picker.
    func loadDepartments() async throws -> [Department]

    /// Personal stats for D.1.
    func loadKudosStats() async throws -> KudosStats

    /// Top 10 reward recipients for D.3.
    func loadTopRecipients() async throws -> [GiftRecipient]

    /// Spotlight total count for B.7.1.
    func loadSpotlightCount() async throws -> Int

    /// Open next unopened secret box. Returns success.
    func openNextSecretBox() async throws -> Bool
}

// MARK: - FakeKudosService

/// FakeKudosService: returns canned fixtures with simulated `Config.mockApiDelay` latency.
/// Single source of mock truth for the Sun*Kudos screen.
final class FakeKudosService: KudosService {

    private let delay: Duration

    init(delay: Duration = Config.mockApiDelay) {
        self.delay = delay
    }

    // MARK: - Home banner (existing)

    func loadKudos() async throws -> KudosInfo {
        try await Task.sleep(for: delay)
        return KudosInfo(
            isAvailable: true,
            bannerImageName: "KudosBanner",
            descriptionText: "Hoạt động ghi nhận và cảm ơn đồng nghiệp — lần đầu tiên được diễn ra dành cho tất cả Sunner. Hoạt động sẽ được triển khai vào tháng 11/2025, khuyến khích người Sun* chia sẻ những lời ghi nhận, cảm ơn đồng nghiệp trên hệ thống do BTC công bố. Đây sẽ là chất liệu để Hội đồng Heads tham khảo trong quá trình lựa chọn người đạt giải.",
            badgeText: "ĐIỂM MỚI CỦA SAA 2025"
        )
    }

    // MARK: - Sun*Kudos endpoints

    func loadHighlight(hashtagId: String?, departmentId: String?) async throws -> [KudosCardData] {
        try await Task.sleep(for: delay)
        let filtered = KudosFixtures.cards.filter { matchesFilters($0, hashtagId: hashtagId, departmentId: departmentId) }
        return Array(filtered.sorted { $0.heartCount > $1.heartCount }.prefix(5))
    }

    func loadKudosFeed(page: Int, limit: Int, hashtagId: String?, departmentId: String?) async throws -> [KudosCardData] {
        try await Task.sleep(for: delay)
        let filtered = KudosFixtures.cards.filter { matchesFilters($0, hashtagId: hashtagId, departmentId: departmentId) }
        let start = max(0, (page - 1) * limit)
        let end = min(filtered.count, start + limit)
        guard start < end else { return [] }
        return Array(filtered[start..<end])
    }

    func loadHashtags() async throws -> [Hashtag] {
        try await Task.sleep(for: delay)
        return KudosFixtures.hashtags
    }

    func loadDepartments() async throws -> [Department] {
        try await Task.sleep(for: delay)
        return KudosFixtures.departments
    }

    func loadKudosStats() async throws -> KudosStats {
        try await Task.sleep(for: delay)
        return KudosFixtures.stats
    }

    func loadTopRecipients() async throws -> [GiftRecipient] {
        try await Task.sleep(for: delay)
        return KudosFixtures.recipients
    }

    func loadSpotlightCount() async throws -> Int {
        try await Task.sleep(for: delay)
        return 388
    }

    func openNextSecretBox() async throws -> Bool {
        try await Task.sleep(for: delay)
        return true
    }

    // MARK: - Helpers

    /// AND-logic across both filters. Nil filter = pass.
    private func matchesFilters(_ card: KudosCardData, hashtagId: String?, departmentId: String?) -> Bool {
        let hashtagOK: Bool = {
            guard let tagId = hashtagId, let tag = KudosFixtures.hashtags.first(where: { $0.id == tagId }) else { return true }
            return card.hashtags.contains { $0.dropFirst().lowercased() == tag.name.lowercased() }
        }()
        let deptOK: Bool = departmentId == nil || card.departmentId == departmentId
        return hashtagOK && deptOK
    }
}
