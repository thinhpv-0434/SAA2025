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

/// FakeAwardsService: returns the six SAA 2025 awards after a simulated
/// delay. Fixture content (titles, descriptions, quantity, value) is sourced
/// directly from the Award_* iOS Figma frames in the SAA 2025 file.
final class FakeAwardsService: AwardsService {

    private let delay: Duration

    /// - Parameter delay: Simulated network latency. Defaults to `Config.mockApiDelay`.
    init(delay: Duration = Config.mockApiDelay) {
        self.delay = delay
    }

    func loadAwards() async throws -> [Award] {
        try await Task.sleep(for: delay)
        return [
            // mm:6885:10732 — Award_MVP
            Award(
                id: UUID(),
                title: "MVP (Most Valuable Person)",
                shortDescription: "Giải thưởng MVP vinh danh cá nhân xuất sắc nhất năm.",
                imageName: "AwardBadgeBG",
                longDescription: "Giải thưởng MVP vinh danh cá nhân xuất sắc nhất năm – gương mặt tiêu biểu đại diện cho toàn bộ tập thể Sun*. Họ là người đã thể hiện năng lực vượt trội, tinh thần cống hiến bền bỉ, và tầm ảnh hưởng sâu rộng, để lại dấu ấn mạnh mẽ trong hành trình của Sun* suốt năm qua.",
                quantity: "01 Cá nhân",
                awardValue: "15.000.000 VNĐ"
            ),

            // mm:6885:10577 — Award_Best Manager
            Award(
                id: UUID(),
                title: "Best Manager",
                shortDescription: "Giải thưởng Best Manager vinh danh những nhà lãnh đạo tiêu biểu.",
                imageName: "AwardBadgeBG",
                longDescription: "Giải thưởng Best Manager vinh danh những nhà lãnh đạo tiêu biểu – người đã dẫn dắt đội ngũ của mình tạo ra kết quả vượt kỳ vọng, tác động nổi bật đến hiệu quả kinh doanh và sự phát triển bền vững của tổ chức. Dưới sự lãnh đạo của họ, đội ngũ luôn chinh phục và làm chủ mọi mục tiêu bằng năng lực đa nhiệm, khả năng phối hợp hiệu quả, và tư duy ứng dụng công nghệ linh hoạt trong kỷ nguyên số.",
                quantity: "01 Cá nhân",
                awardValue: "10.000.000 VNĐ"
            ),

            // mm:6885:10503 — Award_Top project leader
            Award(
                id: UUID(),
                title: "Top Project Leader",
                shortDescription: "Giải thưởng Top Project Leader vinh danh những nhà quản lý dự án xuất sắc.",
                imageName: "AwardBadgeBG",
                longDescription: "Giải thưởng Top Project Leader vinh danh những nhà quản lý dự án xuất sắc – những người hội tụ năng lực quản lý vững vàng, khả năng truyền cảm hứng mạnh mẽ, và tư duy \"Aim High – Be Agile\" trong mọi bài toán và bối cảnh. Dưới sự dẫn dắt của họ, các thành viên không chỉ cùng nhau vượt qua thử thách và đạt được mục tiêu đề ra, mà còn giữ vững ngọn lửa nhiệt huyết, tinh thần Wasshoi, và trưởng thành để trở thành phiên bản tinh hoa – hạnh phúc hơn của chính mình.",
                quantity: "03 Cá nhân",
                awardValue: "7.000.000 VNĐ"
            ),

            // mm:6885:10429 — Award_Top project (existing screen)
            Award(
                id: UUID(),
                title: "Top Project",
                shortDescription: "Giải thưởng Top Project vinh danh những tập thể dự án xuất sắc nhất.",
                imageName: "AwardBadgeBG",
                longDescription: "Giải thưởng Top Project vinh danh các tập thể dự án xuất sắc với kết quả kinh doanh vượt kỳ vọng; hiệu quả vận hành tối ưu và tinh thần làm việc tận tâm...",
                quantity: "02 Tập thể",
                awardValue: "15.000.000 VNĐ"
            ),

            // mm:6885:10259 — Award_Top talent
            Award(
                id: UUID(),
                title: "Top Talent",
                shortDescription: "Giải thưởng Top Talent vinh danh những cá nhân xuất sắc toàn diện.",
                imageName: "AwardBadgeBG",
                longDescription: "Giải thưởng Top Talent vinh danh những cá nhân xuất sắc toàn diện – những người không ngừng khẳng định năng lực chuyên môn vững vàng, hiệu suất công việc vượt trội, luôn mang lại giá trị vượt kỳ vọng, được đánh giá cao bởi khách hàng và đồng đội. Với tinh thần sẵn sàng nhận mọi nhiệm vụ tổ chức giao phó, họ luôn là nguồn cảm hứng, thúc đẩy động lực và tạo ảnh hưởng tích cực đến cả tập thể.",
                quantity: "10 Cá nhân",
                awardValue: "7.000.000 VNĐ"
            ),

            // mm:6885:10651 — Award_Signature 2025 - Creator
            Award(
                id: UUID(),
                title: "Signature 2025 - Creator",
                shortDescription: "Giải thưởng Signature vinh danh tinh thần đặc trưng mà Sun* hướng tới.",
                imageName: "AwardBadgeBG",
                longDescription: "Giải thưởng Signature vinh danh cá nhân hoặc tập thể thể hiện tinh thần đặc trưng mà Sun* hướng tới trong từng thời kỳ.\n\nTrong năm 2025, giải thưởng Signature vinh danh Creator – cá nhân/tập thể mang tư duy chủ động và nhạy bén, luôn nhìn thấy cơ hội trong thách thức và tiên phong trong hành động. Họ là những người nhạy bén với vấn đề, nhanh chóng nhận diện và đưa ra những giải pháp thực tiễn, mang lại giá trị rõ rệt cho dự án, khách hàng hoặc tổ chức. Với tư duy kiến tạo và tinh thần \"Creator\" đặc trưng của Sun*, họ không chỉ phản ứng tích cực trước sự thay đổi mà còn chủ động tạo ra cải tiến, góp phần định hình chuẩn mực mới cho cách mà người Sun* tạo giá trị.",
                quantity: "01 Cá nhân hoặc tập thể",
                awardValue: "5.000.000 VNĐ (cá nhân) / 8.000.000 VNĐ (tập thể)"
            )
        ]
    }
}
