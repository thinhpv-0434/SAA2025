//
//  ProfileTabView.swift
//  SAA2025
//
//  Screen: [iOS] Profile bản thân — hSH7L8doXB
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/hSH7L8doXB
//

import SwiftUI

// MARK: - ProfileTabView

/// Root view for the Profile tab. Composes the member card, icon collection,
/// stats block, and a filtered kudos feed over the shared Awards background.
/// Backend wiring (real `/me`, kudos counts, filtering) lands in a follow-up;
/// this layer renders fixture data so the layout reviews end-to-end.
// mm:6885:10333 — [iOS] Profile bản thân
struct ProfileTabView: View {

    @State private var filter: ProfileKudosFilter = .sent
    @State private var showCopiedToast: Bool = false
    @State private var selectedProfileUser: ProfileUser?
    @State private var navigateToSearch: Bool = false
    @State private var navigateToSecretBox: Bool = false
    @State private var navigateToNotifications: Bool = false

    @EnvironmentObject private var localizer: Localizer

    private func profile(from user: KudosUser) -> ProfileUser {
        ProfileUser(
            displayName: user.name,
            employeeCode: user.employeeCode,
            badgeLabel: user.badgeLabel ?? "",
            badgeTier: user.badgeTier == .one ? .rising : .legend
        )
    }

    private let user: ProfileUser = .mock
    private let stats: KudosStats = KudosStats(
        kudosReceived: 5,
        kudosSent: 25,
        heartsReceived: 25,
        secretBoxOpened: 25,
        secretBoxUnopened: 25
    )
    private let cards: [KudosCardData] = KudosFixtures.cards

    var body: some View {
        ZStack(alignment: .top) {
            AwardsBackground()

            VStack(spacing: 0) {
                AwardsScreenHeader(
                    unreadCount: 0,
                    onSearch: { navigateToSearch = true },
                    onBell: { navigateToNotifications = true }
                )

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ProfileUserCard(user: user)
                            .padding(.top, 8)

                        ProfileIconCollection()

                        ProfileStatsBlock(
                            stats: stats,
                            onOpenSecretBox: { navigateToSecretBox = true }
                        )

                        kudosSection
                            .padding(.top, 12)
                            .padding(.bottom, 32)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .kudosCopiedToast(isVisible: showCopiedToast)
        .navigationDestination(item: $selectedProfileUser) { user in
            OtherProfileView(user: user)
        }
        .navigationDestination(isPresented: $navigateToSearch) {
            SearchView()
        }
        .navigationDestination(isPresented: $navigateToSecretBox) {
            SecretBoxView(unopenedCount: stats.secretBoxUnopened)
        }
        .navigationDestination(isPresented: $navigateToNotifications) {
            NotificationsView()
        }
    }

    // MARK: - Kudos Section

    private var kudosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ProfileKudosSectionHeader()

            ProfileKudosFilterPicker(
                selection: $filter,
                receivedCount: visibleCards(for: .received).count,
                sentCount: visibleCards(for: .sent).count
            )
            .padding(.horizontal, 20)

            kudosList
        }
    }

    private var kudosList: some View {
        VStack(spacing: 16) {
            ForEach(visibleCards(for: filter)) { card in
                KudosCard(
                    card: card,
                    isCarouselVariant: false,
                    onCopyLink: {
                        KudosClipboard.copy(kudoId: card.id)
                        KudosCopiedToastController.show($showCopiedToast)
                    },
                    onDetail: {},
                    onHashtagTap: { _ in },
                    onHeartTap: {},
                    onUserTap: { user in selectedProfileUser = profile(from: user) }
                )
                .padding(.horizontal, 20)
            }
        }
    }

    /// Profile filter mocks "Đã nhận" vs "Đã gửi" by slicing the fixture pool.
    /// Real filtering arrives once the kudos service exposes a per-user query.
    private func visibleCards(for filter: ProfileKudosFilter) -> [KudosCardData] {
        switch filter {
        case .received: return cards
        case .sent:     return cards
        }
    }
}

#Preview {
    NavigationStack { ProfileTabView() }
        .environmentObject(Localizer())
        .environmentObject(TokenStore())
}
