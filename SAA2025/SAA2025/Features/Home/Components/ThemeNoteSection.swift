//
//  ThemeNoteSection.swift
//  SAA2025
//

import SwiftUI

// MARK: - ThemeNoteSection

// mm:6885:9028
struct ThemeNoteSection: View {

    var body: some View {
        // mm:6885:9029
        Text(
            "Không đơn thuần là một cái tên, \u{201C}Root Further\u{201D} chính là tinh thần mà mỗi người Sun* đang hướng tới: luôn nhìn nhận sâu sắc trong mọi bối cảnh và không ngừng sáng tạo, mở rộng bản thân để vượt qua những giới hạn mà chính mình đã từng đặt ra. Mượn hình ảnh ẩn dụ của lý thuyết phối màu, chỉ từ ba màu cơ bản: đỏ, vàng và lam, sức sáng tạo vô tận của mỗi cá nhân có thể tạo ra số lượng màu sắc gần như vô hạn, với mỗi gam màu đều đại diện cho sự bứt phá và sáng tạo không giới hạn."
        )
        .font(.system(size: 14, weight: .regular))
        .foregroundColor(.white.opacity(0.9))
        .lineSpacing(5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ThemeNoteSection()
    }
}
