//
//  KudosOverviewView.swift
//  SAA2025
//
//  Screen: [iOS] Sun*Kudos_All Kudos — j_a2GQWKDJ
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/j_a2GQWKDJ
//

import SwiftUI

// MARK: - KudosOverviewViewContainer

/// Thin wrapper that owns the ViewModel — mirrors `KudosTabViewContainer`.
///
/// IMPORTANT: detail navigation is NOT owned by this container. The hosting
/// NavigationStack (e.g. `KudosTabView`) registers the single
/// `navigationDestination(item:)` for `KudoDetail`. Two registrations of the
/// same item-type on one stack cause SwiftUI to suppress the inner one — that
/// is why `onDetail` is plumbed upward via a callback rather than handled here.
struct KudosOverviewViewContainer: View {

    /// Closure invoked when the user taps "Xem chi tiết" on a card.
    /// The parent passes the tapped card up to the NavigationStack owner.
    var onDetail: (KudosCardData) -> Void = { _ in }

    @StateObject private var viewModel: KudosOverviewViewModel = KudosOverviewViewModel()
    @State private var showCopiedToast: Bool = false

    var body: some View {
        KudosOverviewView(
            cards: viewModel.cards,
            isLoading: viewModel.state.isLoading && viewModel.cards.isEmpty,
            errorMessage: viewModel.state.error?.localizedDescription,
            onRetry: { Task { await viewModel.load() } },
            onCopyLink: { card in
                KudosClipboard.copy(kudoId: card.id)
                KudosCopiedToastController.show($showCopiedToast)
            },
            onDetail: onDetail,
            onHashtagTap: { _ in },
            onHeartTap: { card in viewModel.toggleHeart(kudosId: card.id) }
        )
        .task { await viewModel.load() }
        .kudosCopiedToast(isVisible: showCopiedToast)
    }
}

// MARK: - KudosOverviewView

// mm:6891:15995 — All Kudos screen root frame
struct KudosOverviewView: View {

    let cards: [KudosCardData]
    let isLoading: Bool
    let errorMessage: String?
    let onRetry: () -> Void
    let onCopyLink: (KudosCardData) -> Void
    let onDetail: (KudosCardData) -> Void
    let onHashtagTap: (String) -> Void
    let onHeartTap: (KudosCardData) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showErrorAlert: Bool = false

    private static let background = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)

    var body: some View {
        ZStack(alignment: .top) {
            KudosKeyvisualBackground()

            VStack(spacing: 0) {
                headerBar

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        sectionHeader
                            .padding(.top, 16)
                            .padding(.bottom, 20)

                        kudosFeed
                            .padding(.bottom, 32)
                    }
                }
            }

            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Self.background.opacity(0.85).ignoresSafeArea())
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert("Đã xảy ra lỗi", isPresented: $showErrorAlert) {
            Button("Đóng", role: .cancel) {}
            Button("Thử lại") { onRetry() }
        } message: {
            Text(errorMessage ?? "")
        }
        .onChange(of: errorMessage) { _, newValue in
            showErrorAlert = (newValue != nil)
        }
    }

    // MARK: - Section Header (custom — design diverges from shared SectionHeader)

    // mm:6891:* — Sun* Annual Awards 2025 (light, with divider) + ALL KUDOS (gold)
    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Sun* Annual Awards 2025")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.85))
                    .kerning(0.5)
                Rectangle()
                    .fill(Color.white.opacity(0.25))
                    .frame(height: 0.5)
            }

            Text("ALL KUDOS")
                .font(.system(size: 26, weight: .black))
                .foregroundColor(Color("saaGold"))
                .kerning(1.2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }

    // MARK: - Header Bar

    // mm:6891:15996 — back chevron + "All Kudos" title (shared with KudosDetailView)
    private var headerBar: some View {
        KudosScreenHeaderBar(title: "All Kudos", onBack: { dismiss() })
    }

    // MARK: - Feed

    // mm:6891:15997 — vertical list of B.3 KUDOS cards
    private var kudosFeed: some View {
        VStack(spacing: 16) {
            ForEach(cards) { card in
                KudosCard(
                    card: card,
                    isCarouselVariant: false,
                    onCopyLink: { onCopyLink(card) },
                    onDetail: { onDetail(card) },
                    onHashtagTap: { tag in onHashtagTap(tag) },
                    onHeartTap: { onHeartTap(card) }
                )
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    NavigationStack {
        KudosOverviewView(
            cards: KudosFixtures.cards,
            isLoading: false,
            errorMessage: nil,
            onRetry: {},
            onCopyLink: { _ in },
            onDetail: { _ in },
            onHashtagTap: { _ in },
            onHeartTap: { _ in }
        )
    }
}
