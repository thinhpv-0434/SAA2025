//
//  KudosSection.swift
//  SAA2025
//

import SwiftUI

// MARK: - KudosSection

// mm:6885:9039
struct KudosSection: View {

    let info: KudosInfo
    let onDetailsTap: () -> Void

    var body: some View {
        content(info)
    }

    // MARK: - Private

    private func content(_ info: KudosInfo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // mm:6885:9040
            sectionHeader

            // mm:6885:9041
            KudosBanner()
                .padding(.horizontal, 20)

            // mm:6885:9053
            noteBlock(info)

            // mm:6885:9055
            detailsButton
        }
        .padding(.vertical, 16)
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            // mm:I6885:9040;75:1884
            Text("Phong trào ghi nhận")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color("saaGold"))
                .kerning(1.2)
                .textCase(.uppercase)
            // mm:I6885:9040;75:1886
            Text("Sun* Kudos")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
    }

    private func noteBlock(_ info: KudosInfo) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // mm:6885:9054
            Text(info.badgeText)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color("saaGold"))
                .kerning(0.8)
            Text(info.descriptionText)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.85))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 20)
    }

    private var detailsButton: some View {
        Button(action: onDetailsTap) {
            HStack(spacing: 6) {
                // mm:I6885:9055;28:1998
                Text("Chi tiết")
                    .font(.system(size: 14, weight: .semibold))
                // mm:I6885:9055;28:1997
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color("saaGold")))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ScrollView {
            KudosSection(
                info: KudosInfo(
                    isAvailable: true,
                    bannerImageName: "KudosBanner",
                    descriptionText: "Hoạt động ghi nhận và cảm ơn đồng nghiệp.",
                    badgeText: "ĐIỂM MỚI CỦA SAA 2025"
                ),
                onDetailsTap: {}
            )
        }
    }
}
