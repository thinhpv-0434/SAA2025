//
//  Strings+VN.swift
//  SAA2025
//

// swiftlint:disable line_length
import Foundation

enum StringsVN {
    static let table: [String: String] = [
        // Tab bar
        "tab.saa2025": "SAA 2025",
        "tab.awards": "Giải thưởng",
        "tab.kudos": "Kudos",
        "tab.profile": "Cá nhân",

        // Common buttons / toasts
        "btn.close": "Đóng",
        "btn.done": "Xong",
        "btn.retry": "Thử lại",
        "form.required": " *",
        "toast.copied": "Đã sao chép",
        "toast.kudo_sent": "Đã gửi Kudos",
        "stub.coming_soon": "Sắp ra mắt (bản thử)",

        // Login
        "login.tagline": "Bắt đầu hành trình của bạn cùng SAA 2025.\nĐăng nhập để khám phá!",
        "login.copyright": "Bản quyền thuộc về Sun* © 2025",
        "login.error.title": "Đăng nhập thất bại",
        "login.error.message": "Vui lòng thử lại.",

        // Hero / Event info
        "hero.event.coming_soon": "Sắp diễn ra",
        "hero.event.ended": "Sự kiện đã diễn ra",
        "hero.btn.about_award": "VỀ GIẢI THƯỞNG",
        "hero.btn.about_kudos": "VỀ KUDOS",
        "event.info.time.label": "Thời gian: ",
        "event.info.location": "Địa điểm: Âu Cơ Art Center",
        "event.info.livestream": "Tường thuật trực tiếp tại Group Facebook Sun* Family",

        // Home sections
        "home.kudos.subtitle": "Phong trào ghi nhận",
        "home.kudos.title": "Sun* Kudos",
        "home.kudos.btn.details": "Chi tiết",
        "home.awards.subtitle": "Sun* Annual Awards 2025",
        "home.awards.title": "Hệ thống giải thưởng",
        "home.awards.empty": "Chưa có giải thưởng",
        "home.banner.kudos.title": "Sun* Kudos",
        "home.banner.kudos.subtitle": "KUDOS",
        "home.theme.note": "Không đơn thuần là một cái tên, \u{201C}Root Further\u{201D} chính là tinh thần mà mỗi người Sun* đang hướng tới: luôn nhìn nhận sâu sắc trong mọi bối cảnh và không ngừng sáng tạo, mở rộng bản thân để vượt qua những giới hạn mà chính mình đã từng đặt ra. Mượn hình ảnh ẩn dụ của lý thuyết phối màu, chỉ từ ba màu cơ bản: đỏ, vàng và lam, sức sáng tạo vô tận của mỗi cá nhân có thể tạo ra số lượng màu sắc gần như vô hạn, với mỗi gam màu đều đại diện cho sự bứt phá và sáng tạo không giới hạn.",
        "card.award.btn.details": "Chi tiết",

        // Kudos
        "kudos.hero.tagline": "Hệ thống ghi nhận và cảm ơn",
        "kudos.hero.title": "KUDOS",
        "kudos.section.subtitle": "Sun* Annual Awards 2025",
        "kudos.section.highlight.title": "HIGHLIGHT KUDOS",
        "kudos.section.spotlight.title": "SPOTLIGHT BOARD",
        "kudos.section.all.title": "ALL KUDOS",
        "kudos.btn.view_all": "Xem tất cả Kudos",
        "kudos.btn.send.placeholder": "Hôm nay, bạn muốn gửi kudos đến ai?",
        "kudos.btn.open_secret_box": "Mở Secret Box",
        "kudos.action.copy_link": "Sao chép link",
        "kudos.action.view_detail": "Xem chi tiết",
        "kudos.detail.header.title": "Kudo",
        "kudos.overview.subtitle": "Sun* Annual Awards 2025",
        "kudos.overview.title": "ALL KUDOS",
        "kudos.overview.header.title": "Tất cả Kudos",
        "kudos.error.title": "Đã xảy ra lỗi",
        "kudos.recipients.title": "10 SUNNER NHẬN QUÀ MỚI NHẤT",
        "kudos.stats.received": "Số Kudos bạn nhận được:",
        "kudos.stats.sent": "Số Kudos bạn đã gửi:",
        "kudos.stats.hearts": "Số tim bạn nhận được:",
        "kudos.stats.secret_box_opened": "Số Secret Box bạn đã mở:",
        "kudos.stats.secret_box_unopened": "Số Secret Box chưa mở:",
        "secret_box.title": "Secret Box",
        "secret_box.status.coming_soon": "Sắp ra mắt",

        // Write Kudo
        "writkudo.nav.title": "Kudo mới",
        "writkudo.form.header": "Gửi lời cám ơn và ghi nhận đến đồng đội",
        "writkudo.field.recipient.label": "Người nhận",
        "writkudo.field.recipient.placeholder": "Tìm kiếm",
        "writkudo.field.title.label": "Danh hiệu",
        "writkudo.field.title.placeholder": "Dành tặng một danh hiệu cho...",
        "writkudo.field.title.example": "Ví dụ: Người truyền động lực cho tôi.",
        "writkudo.field.title.helper": "Danh hiệu sẽ hiển thị làm tiêu đề Kudos của bạn.",
        "writkudo.field.message.placeholder": "Hãy gửi gắm lời cám ơn và ghi nhận đến đồng đội tại đây nhé!",
        "writkudo.field.anonymous.label": "Gửi lời cám ơn và ghi nhận ẩn danh",
        "writkudo.hint.mention.prefix": "Bạn có thể ",
        "writkudo.hint.mention.syntax": "\"@ + tên\"",
        "writkudo.hint.mention.suffix": " để nhắc tới đồng nghiệp khác",
        "writkudo.link.community_standards": "Tiêu chuẩn cộng đồng",
        "writkudo.action.cancel": "Huỷ",
        "writkudo.action.send": "Gửi đi",
        "writkudo.cancel.title": "Bỏ Kudos này?",
        "writkudo.cancel.message": "Nội dung Kudo của bạn sẽ không được lưu lại.",
        "writkudo.cancel.btn.discard": "Hủy bỏ",
        "writkudo.cancel.btn.continue": "Tiếp tục viết",
        "writkudo.error.title": "Đã xảy ra lỗi",
        "writkudo.hashtag.nav.title": "Hashtag",
        "writkudo.hashtag.counter.prefix": "Đã chọn ",
        "writkudo.hashtag.counter.sep": " / ",
        "writkudo.hashtag.available.label": "Hashtag có sẵn",
        "writkudo.hashtag.input.placeholder": "Thêm hashtag mới…",
        "writkudo.awards_info.title": "Tiêu chuẩn cộng đồng",
        "writkudo.awards_info.description": "Sun*Kudos được trao tặng dựa trên các giá trị cộng đồng SAA 2025. Bạn nên dùng danh hiệu mô tả cụ thể đóng góp của đồng nghiệp và tránh các nội dung công kích cá nhân.",
        "writkudo.awards_info.examples.label": "Một số ví dụ danh hiệu được khuyến khích:",
        "writkudo.awards_info.example.1": "Người truyền cảm hứng cho tôi",
        "writkudo.awards_info.example.2": "Đồng đội luôn sẵn sàng giúp đỡ",
        "writkudo.awards_info.example.3": "Người hùng thầm lặng của dự án",
        "writkudo.awards_info.note": "Nội dung chi tiết sẽ được BTC cập nhật sớm.",
        "writkudo.recipient_picker.nav.title": "Chọn người nhận",
        "writkudo.recipient_picker.search.placeholder": "Tìm theo tên hoặc phòng ban",
        "writkudo.hashtag.label": "Hashtag",
        "writkudo.image.label": "Hình ảnh",
        "writkudo.max_5_hint": "(Tối đa 5)",

        // Awards extras
        "awards.kudos.note": "ĐIỂM MỚI CỦA SAA 2025\nHoạt động ghi nhận và cảm ơn đồng nghiệp - lần đầu tiên được diễn ra dành cho tất cả Sunner. Hoạt động sẽ được triển khai vào tháng 11/2025, khuyến khích người Sun* chia sẻ những lời ghi nhận, cảm ơn đồng nghiệp trên hệ thống do BTC công bố. Đây sẽ là chất liệu để Hội đồng Heads tham khảo trong quá trình lựa chọn người đạt giải.",
        "award.stat.quantity.label": "Số lượng giải thưởng",
        "award.stat.value.label": "Giá trị giải thưởng",
        "award.stat.value.suffix": "cho mỗi giải thưởng",
        "writkudo.error.submit": "Không gửi được Kudos. Vui lòng thử lại.",

        // Awards
        "awards.loading.message": "Đang tải...",
        "awards.select.prompt": "Vui lòng chọn một giải thưởng.",
        "awards.empty.message": "Chưa có giải thưởng nào.",
        "awards.error.message": "Không thể tải danh sách giải thưởng.",
        "awards.overview.nav.title": "Giải thưởng",
        "award.detail.nav.title": "Chi tiết giải thưởng",
        "awards.highlight.subtitle": "Sun* Annual Awards 2025",
        "awards.highlight.title": "Hệ thống giải thưởng\nSAA 2025",
        "award.badge.accessibility_label": "Huy hiệu giải thưởng",

        // Profile
        "profile.title": "Hồ sơ cá nhân",
        "profile.nav.title": "Cá nhân",
        "profile.badge.legend_hero": "Legend Hero",
        "profile.icon_collection.title": "Bộ sưu tập icon của tôi",
        "profile.kudos.section.subtitle": "Sun* Annual Awards 2025",
        "profile.kudos.section.title": "KUDOS",
        "profile.filter.received": "Đã nhận",
        "profile.filter.sent": "Đã gửi",
        "profile.kudos.status.spam": "Spam",
        "profile.other.cta.send_prefix": "Gửi lời cảm ơn và ghi nhận tới ",
        "profile.other.received_kudos.prefix": "Đã nhận ",
        "profile.other.received_kudos.suffix": " kudos",

        // Stub screens
        "search.title": "Tìm kiếm",
        "search.nav.title": "Tìm kiếm",
        "notifications.title": "Thông báo",
        "notifications.nav.title": "Thông báo",
        "notifications.mark_all_read": "Đánh dấu đọc tất cả",
        "access_denied.title": "Truy cập bị từ chối",
        "access_denied.nav.title": "Truy cập bị từ chối",
        "access_denied.btn.back_to_login": "Quay lại đăng nhập"
    ]
}
