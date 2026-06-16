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

    var body: some View {
        AwardsTabView(tokenStore: tokenStore)
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
    @EnvironmentObject private var localizer: Localizer

    init(tokenStore: TokenStore) {
        _viewModel = StateObject(
            wrappedValue: AwardsTopViewModel(tokenStore: tokenStore)
        )
    }

    var body: some View {
        ZStack {
            AwardsBackground()

            VStack(spacing: 0) {
                AwardsScreenHeader(
                    unreadCount: 0,
                    onSearch: { navigateToSearch = true },
                    onBell: {}
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
            VStack(spacing: 20) {
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
