//
//  AwardsTabView.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardsTabViewContainer

/// Thin wrapper that owns the `TokenStore` environment object so it can
/// forward it into `AwardsTopViewModel` at the point where `@EnvironmentObject`
/// is available. Mirrors `HomeViewContainer` / `KudosTabViewContainer`.
struct AwardsTabViewContainer: View {
    @EnvironmentObject private var tokenStore: TokenStore
    /// When true the screen is shown as a pushed destination (e.g. legacy
    /// callers that still want a back chevron). Tab-based navigation from
    /// Home does NOT set this — it switches tabs via `AppCoordinator`.
    var showBackButton: Bool = false

    var body: some View {
        AwardsTabView(tokenStore: tokenStore, showBackButton: showBackButton)
    }
}

// MARK: - AwardsTabView

/// Root view for the Awards tab. Owns `AwardsTopViewModel`, branches on
/// `awardsState`, and composes the three Award_Top project sections
/// (Kudos banner, Award Highlight Block, Award Information Block) over the
/// shared Awards background.
// mm:6885:10429 — [iOS] Award_Top project
struct AwardsTabView: View {

    @StateObject private var viewModel: AwardsTopViewModel
    @State private var navigateToSearch: Bool = false
    @State private var navigateToRules: Bool = false
    @State private var navigateToNotifications: Bool = false
    @EnvironmentObject private var localizer: Localizer
    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss
    private let showBackButton: Bool

    init(tokenStore: TokenStore, showBackButton: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: AwardsTopViewModel(tokenStore: tokenStore)
        )
        self.showBackButton = showBackButton
    }

    var body: some View {
        ZStack {
            AwardsBackground()

            VStack(spacing: 0) {
                AwardsScreenHeader(
                    unreadCount: 0,
                    onSearch: { navigateToSearch = true },
                    onBell: { navigateToNotifications = true },
                    onBack: showBackButton ? { dismiss() } : nil
                )

                content
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            if case .idle = viewModel.awardsState {
                await viewModel.load()
            }
            consumePendingAwardTitle()
        }
        // Switching tabs to Awards (after first load) won't re-run `.task`,
        // so also react when the coordinator publishes a new pending title.
        .onChange(of: coordinator.pendingAwardTitle) { _, _ in
            consumePendingAwardTitle()
        }
        .navigationDestination(isPresented: $viewModel.navigateToAccessDenied) {
            AccessDeniedView()
        }
        .navigationDestination(isPresented: $navigateToSearch) {
            SearchView()
        }
        .navigationDestination(isPresented: $navigateToRules) {
            RulesView()
        }
        .navigationDestination(isPresented: $navigateToNotifications) {
            NotificationsView()
        }
    }

    // MARK: - Coordinator hand-off

    /// If `AppCoordinator` has a pending award title (set by Home tapping a
    /// card), forward it to the view model and clear the coordinator state
    /// so subsequent direct tab taps don't reapply it.
    private func consumePendingAwardTitle() {
        guard let title = coordinator.pendingAwardTitle else { return }
        viewModel.selectAward(byTitle: title)
        coordinator.pendingAwardTitle = nil
    }

    // MARK: - Branches

    @ViewBuilder
    private var content: some View {
        switch viewModel.awardsState {
        case .idle, .loading:
            loadingView
        case .loaded(let awards):
            successView(awards: awards)
        case .empty:
            emptyView
        case .error:
            errorView
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(Color("saaGold"))
            Text(localizer.t("awards.loading.message"))
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func successView(awards: [Award]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AwardsKudosBanner()

                AwardHighlightBlock(
                    awards: awards,
                    selectedID: viewModel.selectedAwardID,
                    onSelect: { viewModel.selectAward($0) }
                )

                if let award = viewModel.selectedAward {
                    AwardInfoBlock(award: award)
                } else {
                    Text(localizer.t("awards.select.prompt"))
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.vertical, 32)
                }

                AwardsSunKudosSection(onCTATap: { navigateToRules = true })
            }
            .padding(.top, 8)
            .padding(.horizontal, 20)
        }
    }

    private var emptyView: some View {
        VStack(spacing: 8) {
            Text(localizer.t("awards.empty.message"))
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var errorView: some View {
        VStack(spacing: 12) {
            Text(localizer.t("awards.error.message"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)

            Button(action: { viewModel.retry() }) {
                Text(localizer.t("btn.retry"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("saaGold"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color("saaGold"), lineWidth: 1)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack { AwardsTabView(tokenStore: TokenStore()) }
        .environmentObject(TokenStore())
        .environmentObject(Localizer())
}
