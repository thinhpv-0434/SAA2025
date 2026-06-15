//
//  AwardsSection.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardsSection

// mm:6885:9030
struct AwardsSection: View {

    let state: LoadState<[Award]>
    let onCardTap: (Award) -> Void
    let onRetry: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // mm:6885:9031
            sectionHeader

            // mm:6885:9032
            awardsContent
        }
        .padding(.vertical, 16)
    }

    // MARK: - Subviews

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            // mm:I6885:9031;75:1884
            Text(localizer.t("home.awards.subtitle"))
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color("saaGold"))
                .kerning(1.2)
                .textCase(.uppercase)
            Text(localizer.t("home.awards.title"))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var awardsContent: some View {
        switch state {
        case .idle, .loading:
            HStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
                Spacer()
            }
            .padding(.horizontal, 20)

        case .loaded(let awards):
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(awards) { award in
                        AwardCard(award: award) { onCardTap(award) }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }

        case .empty:
            Text(localizer.t("home.awards.empty"))
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal, 20)

        case .error(let error):
            VStack(alignment: .leading, spacing: 8) {
                Text(error.localizedDescription)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                Button(action: onRetry) {
                    Text(localizer.t("btn.retry"))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color("saaGold"))
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AwardsSection(
            state: .loaded([
                Award(id: UUID(), title: "Top Talent", shortDescription: "Vinh danh cá nhân xuất sắc nhất.", imageName: "TopTalentBadge"),
                Award(id: UUID(), title: "Top Project", shortDescription: "Vinh danh dự án dấu ấn nhất.", imageName: "TopProjectBadge")
            ]),
            onCardTap: { _ in },
            onRetry: {}
        )
        .environmentObject(Localizer())
    }
}
