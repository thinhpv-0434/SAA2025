//
//  CommunityStandardsView.swift
//  SAA2025
//
//  Screen: [iOS] Sun*Kudos_Tiêu chuẩn cộng đồng — xms7csmDhD
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/xms7csmDhD
//

import SwiftUI

// MARK: - CommunityStandardsView

/// Long-form Community Standards reached from:
/// - the "Tiêu chuẩn cộng đồng" link in WriteKudoView, and
/// - the warning row sublink on NotificationsView.
/// Layout: back-chevron + centered title at top, ROOT FURTHER wordmark,
/// then a vertically-scrolled mix of headings, paragraphs, and a 10-rule
/// numbered spam list, plus the privacy subsection at the bottom.
// mm:6885:10806 — [iOS] Sun*Kudos_Tiêu chuẩn cộng đồng
struct CommunityStandardsView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizer: Localizer

    private static let divider = Color.white.opacity(0.18)

    var body: some View {
        ZStack(alignment: .top) {
            AwardsBackground()

            VStack(spacing: 0) {
                topBar

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
                        wordmark
                            .padding(.top, 8)

                        sectionTitle("community.standards.h1")

                        paragraphBold("community.standards.intro")

                        paragraph("community.standards.spam_lead")

                        spamList

                        Rectangle().fill(Self.divider).frame(height: 1).padding(.vertical, 8)

                        sectionTitle("community.standards.privacy.h2")

                        paragraphBold("community.standards.privacy.intro")

                        bulletList(keys: [
                            "community.standards.privacy.bullet1",
                            "community.standards.privacy.bullet2"
                        ])

                        paragraphBold("community.standards.contact")
                            .padding(.top, 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Top bar

    private var topBar: some View {
        ZStack {
            Text(localizer.t("community.standards.nav.title"))
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 4)
    }

    // MARK: - Building blocks

    private var wordmark: some View {
        Text("ROOT\nFURTHER")
            .font(.system(size: 28, weight: .light, design: .serif))
            .foregroundColor(.white)
            .lineSpacing(2)
            .padding(.bottom, 4)
    }

    private func sectionTitle(_ key: String) -> some View {
        Text(localizer.t(key))
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color("saaGold"))
    }

    private func paragraph(_ key: String) -> some View {
        Text(localizer.t(key))
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.white.opacity(0.85))
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func paragraphBold(_ key: String) -> some View {
        Text(localizer.t(key))
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Numbered spam list

    private var spamList: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(1...10), id: \.self) { idx in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(idx).")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 24, alignment: .trailing)
                    Text(localizer.t("community.standards.spam.\(idx)"))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.leading, 4)
    }

    // MARK: - Bullet list

    private func bulletList(keys: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(keys, id: \.self) { key in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Text(localizer.t(key))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.leading, 4)
    }
}

#Preview {
    NavigationStack { CommunityStandardsView() }
        .environmentObject(Localizer())
}
