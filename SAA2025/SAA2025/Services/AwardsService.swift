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
///
/// Top Project fields are sourced from the Award_Top project MoMorph design.
/// Top Talent + Top Innovation use plausible mock values pending design coverage
/// (search for "TODO(Award fixtures)" to update once Figma adds those screens).
final class FakeAwardsService: AwardsService {

    private let delay: Duration

    /// - Parameter delay: Simulated network latency. Defaults to `Config.mockApiDelay`.
    init(delay: Duration = Config.mockApiDelay) {
        self.delay = delay
    }

    func loadAwards() async throws -> [Award] {
        try await Task.sleep(for: delay)
        return [
            // TODO(Award fixtures): replace quantity + awardValue + longDescription
            // with Top Talent screen data when the Figma screen lands.
            Award(
                id: UUID(),
                title: "Top Talent",
                shortDescription: "Giải thưởng Top Talent vinh danh những cá nhân xuất sắc nhất.",
                imageName: "TopTalentBadge",
                longDescription: "Giải thưởng Top Talent vinh danh các cá nhân xuất sắc nhất với đóng góp vượt trội cho dự án và tổ chức; thể hiện tinh thần học hỏi không ngừng và lan tỏa giá trị tích cực...",
                quantity: "10 Cá nhân",
                awardValue: "10.000.000 VNĐ"
            ),
            // Spec-sourced from screen FQoJZLkG_d
            Award(
                id: UUID(),
                title: "Top Project",
                shortDescription: "Giải thưởng Top Project vinh danh những tập thể dự án xuất sắc nhất.",
                imageName: "TopProjectBadge",
                longDescription: "Giải thưởng Top Project vinh danh các tập thể dự án xuất sắc với kết quả kinh doanh vượt kỳ vọng; hiệu quả vận hành tối ưu và tinh thần làm việc tận tâm...",
                quantity: "02 Tập thể",
                awardValue: "15.000.000 VNĐ"
            ),
            // TODO(Award fixtures): replace quantity + awardValue + longDescription
            // with Top Innovation screen data when the Figma screen lands.
            Award(
                id: UUID(),
                title: "Top Innovation",
                shortDescription: "Giải thưởng Top Innovation vinh danh những sáng kiến đột phá.",
                imageName: "TopInnovationBadge",
                longDescription: "Giải thưởng Top Innovation vinh danh các sáng kiến đột phá với tác động sâu rộng đến sản phẩm và quy trình; thúc đẩy đổi mới và sáng tạo trong toàn tổ chức...",
                quantity: "01 Dự án",
                awardValue: "20.000.000 VNĐ"
            )
        ]
    }
}
