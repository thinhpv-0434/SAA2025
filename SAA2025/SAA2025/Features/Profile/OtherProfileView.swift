//
//  OtherProfileView.swift
//  SAA2025
//
//  Screen: [iOS] Profile người khác — bEpdheM0yU
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/bEpdheM0yU
//

import SwiftUI

// MARK: - OtherProfileView

/// Profile screen for sunners *other than the signed-in user*. Differs from
/// the own-profile screen (mm:6885:10333) in three ways: shows the viewee's
/// six earned badges (REVIVAL → ROOT FURTHER) instead of placeholder slots,
/// surfaces a gold-outlined "Gửi lời cảm ơn…" CTA, and drops the personal
/// stats card (you cannot peek at someone else's secret boxes).
// mm:6885:10395 — [iOS] Profile người khác
struct OtherProfileView: View {

    let user: ProfileUser

    /// Fixture kudos this user has received. Until the per-user kudos API
    /// lands we slice the same in-memory pool used elsewhere; the design
    /// renders five cards so we match that count by default.
    var receivedCards: [KudosCardData] = Array(KudosFixtures.cards.prefix(5))

    @Environment(\.dismiss) private var dismiss
    @State private var showCopiedToast: Bool = false
    @State private var navigateToSearch: Bool = false

    var body: some View {
        ZStack(alignment: .top) {
            AwardsBackground()

            VStack(spacing: 0) {
                AwardsScreenHeader(
                    unreadCount: 0,
                    onSearch: { navigateToSearch = true },
                    onBell: {}
                )

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        ProfileUserCard(user: user)
                            .padding(.top, 8)

                        ProfileBadgeShowcase()
                            .padding(.top, 4)

                        collectionTitle

                        SendKudosCTAButton(
                            recipientName: user.displayName,
                            onTap: {}
                        )
                        .padding(.top, 4)

                        kudosSection
                            .padding(.top, 12)
                            .padding(.bottom, 32)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .kudosCopiedToast(isVisible: showCopiedToast)
        .navigationDestination(isPresented: $navigateToSearch) {
            SearchView()
        }
    }

    @EnvironmentObject private var localizer: Localizer

    // mm:6885:10426 — mms_4_A.2.1. Tên ("Bộ sưu tập icon của tôi")
    private var collectionTitle: some View {
        Text(localizer.t("profile.icon_collection.title"))
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.white.opacity(0.85))
    }

    private var kudosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ProfileKudosSectionHeader()

            ReceivedKudosCountLabel(count: receivedCards.count)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            kudosList
        }
    }

    private var kudosList: some View {
        VStack(spacing: 16) {
            ForEach(receivedCards) { card in
                KudosCard(
                    card: card,
                    isCarouselVariant: false,
                    onCopyLink: {
                        KudosClipboard.copy(kudoId: card.id)
                        KudosCopiedToastController.show($showCopiedToast)
                    },
                    onDetail: {},
                    onHashtagTap: { _ in },
                    onHeartTap: {}
                )
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    NavigationStack {
        OtherProfileView(user: .mockOther)
            .environmentObject(Localizer())
            .environmentObject(TokenStore())
    }
}
