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
        VStack(alignment: .leading, spacing: 24) {
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
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)
            // mm:I6885:9031;75:1885 — 1px separator
            Rectangle()
                .fill(Color(red: 0x2E / 255.0, green: 0x39 / 255.0, blue: 0x40 / 255.0))
                .frame(height: 1)
            // mm:I6885:9031;75:1887
            Text(localizer.t("home.awards.title"))
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Self.titleGold)
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
                HStack(alignment: .top, spacing: 16) {
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
                        .foregroundColor(Self.titleGold)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // #FFEA9E — design token "Details / Text Primary 1"
    private static let titleGold = Color(red: 0xFF / 255.0, green: 0xEA / 255.0, blue: 0x9E / 255.0)
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AwardsSection(
            state: .loaded([
                Award(id: UUID(), title: "Top Talent", shortDescription: "Giải thưởng Top Talent vinh danh những cá nhân xuất ...", imageName: "TopTalentBadge"),
                Award(id: UUID(), title: "Top Project", shortDescription: "Giải thưởng Top Project vinh danh các tập thể dự án xuất...", imageName: "TopProjectBadge")
            ]),
            onCardTap: { _ in },
            onRetry: {}
        )
        .environmentObject(Localizer())
    }
}
