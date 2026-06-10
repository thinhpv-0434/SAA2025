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
                    subtitle: "Sun* Annual Awards 2025",
                    title: "HIGHLIGHT KUDOS"
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
                    onCopyLink: { _ in },
                    onDetail: { _ in viewModel.navigateToKudosDetail = true },
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
                    subtitle: "Sun* Annual Awards 2025",
                    title: "SPOTLIGHT BOARD"
                )
                .padding(.bottom, 12)

                SpotlightBoard(
                    totalKudosCount: viewModel.spotlightTotalCount,
                    searchText: $spotlightSearch
                )
                .padding(.bottom, 24)

                // MARK: C.1 — All Kudos Header

                SectionHeader(
                    subtitle: "Sun* Annual Awards 2025",
                    title: "ALL KUDOS"
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
                            onCopyLink: {},
                            onDetail: { viewModel.navigateToKudosDetail = true },
                            onHashtagTap: { tagName in
                                if let tag = viewModel.hashtags.first(where: { "#\($0.name)" == tagName }) {
                                    Task { await viewModel.selectHashtag(tag) }
                                }
                            },
                            onHeartTap: { viewModel.toggleHeart(kudosId: card.id) }
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
                        Text("View all Kudos")
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
            "Đã xảy ra lỗi",
            isPresented: Binding(
                get: { viewModel.state.error != nil },
                set: { if !$0 { Task { await viewModel.load() } } }
            )
        ) {
            Button("Đóng", role: .cancel) {}
            Button("Thử lại") { Task { await viewModel.load() } }
        } message: {
            Text(viewModel.state.error?.localizedDescription ?? "")
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { await viewModel.load() }
        .navigationDestination(isPresented: $viewModel.navigateToSendKudos) { WriteKudoView() }
        .navigationDestination(isPresented: $viewModel.navigateToKudosDetail) { KudosFeedView() }
        .navigationDestination(isPresented: $viewModel.navigateToViewAll) { KudosOverviewViewContainer() }
        .sheet(isPresented: $viewModel.navigateToOpenSecretBox) {
            VStack(spacing: 12) {
                Text("Secret Box")
                    .font(.title2.bold())
                Text("Coming soon")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    NavigationStack { KudosTabView() }
}
