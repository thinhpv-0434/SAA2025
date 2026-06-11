//
//  AwardsInfoSheet.swift
//  SAA2025
//
//  B.5 Community Standards / Awards Information bottom sheet.
//

import SwiftUI

// MARK: - AwardsInfoSheet

struct AwardsInfoSheet: View {

    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tiêu chuẩn cộng đồng")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom, 4)

                    Text("Sun*Kudos được trao tặng dựa trên các giá trị cộng đồng SAA 2025. Bạn nên dùng danh hiệu mô tả cụ thể đóng góp của đồng nghiệp và tránh các nội dung công kích cá nhân.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary)
                        .lineSpacing(4)

                    Text("Một số ví dụ danh hiệu được khuyến khích:")
                        .font(.system(size: 14, weight: .medium))

                    VStack(alignment: .leading, spacing: 8) {
                        bulletRow("Người truyền cảm hứng cho tôi")
                        bulletRow("Đồng đội luôn sẵn sàng giúp đỡ")
                        bulletRow("Người hùng thầm lặng của dự án")
                    }

                    Text("Nội dung chi tiết sẽ được BTC cập nhật sớm.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.top, 12)
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Đóng") { onDismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }

    @ViewBuilder
    private func bulletRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.system(size: 14, weight: .bold))
            Text(text)
                .font(.system(size: 14, weight: .regular))
            Spacer()
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            AwardsInfoSheet(onDismiss: {})
        }
}
