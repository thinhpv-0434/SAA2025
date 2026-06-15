//
//  KudosTabView.swift
//  SAA2025
//

import SwiftUI

// MARK: - KudosTabViewContainer

/// Thin wrapper that matches the HomeViewContainer pattern.
struct KudosTabViewContainer: View {
    var body: some View {
        KudosTabView()
    }
}

// MARK: - KudosTabView

// mm:6885:9059
struct KudosTabView: View {

    @StateObject private var viewModel: KudosViewModel = KudosViewModel()
    @State private var spotlightSearch: String = ""
    @State private var showCopiedToast: Bool = false
    @State private var selectedProfileUser: ProfileUser?
    @EnvironmentObject private var localizer: Localizer

    /// Maps the kudos-feature user model onto the profile model. Until the
    /// directory API ships, the avatar falls back to a generic SF Symbol.
    private func profile(from user: KudosUser) -> ProfileUser {
        ProfileUser(
            displayName: user.name,
            employeeCode: user.employeeCode,
            badgeLabel: user.badgeLabel ?? "",
            badgeTier: user.badgeTier == .one ? .rising : .legend
        )
    }

    // MARK: - Copy Link helper

    private func copyLink(for card: KudosCardData) {
        KudosClipboard.copy(kudoId: card.id)
        KudosCopiedToastController.show($showCopiedToast)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // MARK: A — Hero + Send Button

                KudosHeroSection()

                SendKudosButton {
                    viewModel.navigateToSendKudos = true
                }
                .padding(.top, 12)
                .padding(.bottom, 20)

                // MARK: B — Highlight Section

                SectionHeader(
                    subtitle: localizer.t("kudos.section.subtitle"),
                    title: localizer.t("kudos.section.highlight.title")
                )
                .padding(.bottom, 12)

                KudosFilterRow(
                    selectedHashtag: viewModel.selectedHashtag,
                    selectedDepartment: viewModel.selectedDepartment,
                    hashtags: viewModel.hashtags,
                    departments: viewModel.departments,
                    onSelectHashtag: { tag in Task { await viewModel.selectHashtag(tag) } },
                    onSelectDepartment: { dept in Task { await viewModel.selectDepartment(dept) } }
                )
                .padding(.bottom, 12)

                HighlightCarousel(
                    cards: viewModel.highlightCards,
                    currentIndex: Binding(
                        get: { viewModel.currentHighlightIndex },
                        set: { viewModel.currentHighlightIndex = $0 }
                    ),
                    onCopyLink: { card in copyLink(for: card) },
                    onDetail: { card in viewModel.openDetail(for: card) },
                    onHashtagTap: { tagName in
                        if let tag = viewModel.hashtags.first(where: { "#\($0.name)" == tagName }) {
                            Task { await viewModel.selectHashtag(tag) }
                        }
                    },
                    onHeartTap: { card in viewModel.toggleHeart(kudosId: card.id) },
                    onPrevious: { viewModel.goToPreviousHighlight() },
                    onNext: { viewModel.goToNextHighlight() }
                )
                .padding(.bottom, 24)

                // MARK: B.6/B.7 — Spotlight Board

                SectionHeader(
                    subtitle: localizer.t("kudos.section.subtitle"),
                    title: localizer.t("kudos.section.spotlight.title")
                )
                .padding(.bottom, 12)

                SpotlightBoard(
                    totalKudosCount: viewModel.spotlightTotalCount,
                    searchText: $spotlightSearch
                )
                .padding(.bottom, 24)

                // MARK: C.1 — All Kudos Header

                SectionHeader(
                    subtitle: localizer.t("kudos.section.subtitle"),
                    title: localizer.t("kudos.section.all.title")
                )
                .padding(.bottom, 16)

                // MARK: D — Stats & Rewards (interleaved before C.3 per Figma)

                PersonalStatsBlock(stats: viewModel.stats)
                    .padding(.bottom, 12)

                OpenSecretBoxButton(
                    unopenedCount: viewModel.stats.secretBoxUnopened,
                    onTap: { Task { await viewModel.openSecretBox() } }
                )
                .padding(.bottom, 20)

                TopRecipientsBlock(recipients: viewModel.giftRecipients)
                    .padding(.bottom, 24)

                // MARK: C.3 — All Kudos Feed

                VStack(spacing: 16) {
                    ForEach(viewModel.allKudosCards) { card in
                        KudosCard(
                            card: card,
                            isCarouselVariant: false,
                            onCopyLink: { copyLink(for: card) },
                            onDetail: { viewModel.openDetail(for: card) },
                            onHashtagTap: { tagName in
                                if let tag = viewModel.hashtags.first(where: { "#\($0.name)" == tagName }) {
                                    Task { await viewModel.selectHashtag(tag) }
                                }
                            },
                            onHeartTap: { viewModel.toggleHeart(kudosId: card.id) },
                            onUserTap: { user in selectedProfileUser = profile(from: user) }
                        )
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 16)

                // MARK: C.2 — View All Kudos link

                Button {
                    viewModel.navigateToViewAll = true
                } label: {
                    HStack(spacing: 6) {
                        Text(localizer.t("kudos.btn.view_all"))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("saaGold"))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("saaGold"))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 32)
            }
        }
        .background(
            Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
                .ignoresSafeArea()
        )
        .overlay {
            // mm: loading overlay — covers initial fetch (TC_FUN_011 Spotlight loading)
            if viewModel.state.isLoading && viewModel.highlightCards.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
                            .opacity(0.85)
                            .ignoresSafeArea()
                    )
            }
        }
        .alert(
            localizer.t("kudos.error.title"),
            isPresented: Binding(
                get: { viewModel.state.error != nil },
                set: { if !$0 { Task { await viewModel.load() } } }
            )
        ) {
            Button(localizer.t("btn.close"), role: .cancel) {}
            Button(localizer.t("btn.retry")) { Task { await viewModel.load() } }
        } message: {
            Text(viewModel.state.error?.localizedDescription ?? "")
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { await viewModel.load() }
        .kudosCopiedToast(isVisible: showCopiedToast)
        .navigationDestination(isPresented: $viewModel.navigateToSendKudos) {
            WriteKudoContainer(onDismiss: { viewModel.navigateToSendKudos = false })
        }
        .navigationDestination(item: $viewModel.selectedDetail) { detail in
            KudosDetailView(detail: detail, onBack: { viewModel.selectedDetail = nil })
        }
        .navigationDestination(isPresented: $viewModel.navigateToViewAll) {
            KudosOverviewViewContainer(onDetail: { card in viewModel.openDetail(for: card) })
        }
        .navigationDestination(item: $selectedProfileUser) { user in
            OtherProfileView(user: user)
        }
        .sheet(isPresented: $viewModel.navigateToOpenSecretBox) {
            VStack(spacing: 12) {
                Text(localizer.t("secret_box.title"))
                    .font(.title2.bold())
                Text(localizer.t("secret_box.status.coming_soon"))
                    .foregroundStyle(.secondary)
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    NavigationStack { KudosTabView() }
        .environmentObject(Localizer())
}
