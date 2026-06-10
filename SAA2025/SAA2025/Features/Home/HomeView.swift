//
//  HomeView.swift
//  SAA2025
//

import SwiftUI

// MARK: - HomeViewContainer
//
// Thin wrapper that owns the environment object so it can forward it into
// HomeViewModel at the point where @EnvironmentObject is available.
// Phase 6 replaces this wrapper with a NavigationStack push target.

struct HomeViewContainer: View {
    @EnvironmentObject private var tokenStore: TokenStore

    var body: some View {
        HomeView(tokenStore: tokenStore)
    }
}

// MARK: - HomeView

// mm:6885:8978
struct HomeView: View {

    @StateObject private var viewModel: HomeViewModel
    @State private var selectedLang: Lang = .vn

    init(tokenStore: TokenStore) {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(tokenStore: tokenStore)
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // mm:6885:9057
                HomeHeader(
                    selectedLang: $selectedLang,
                    unreadCount: viewModel.unreadCount,
                    onSearch: { viewModel.navigateToSearch = true },
                    onBell: { viewModel.navigateToBell = true }
                )

                // mm:6885:8983
                HeroSection(
                    remaining: viewModel.remaining,
                    isEventEnded: viewModel.isEventEnded,
                    onAboutAward: { viewModel.navigateToAboutAward = true },
                    onAboutKudos: { viewModel.navigateToAboutKudos = true }
                )

                // mm:6885:9028
                ThemeNoteSection()

                // mm:6885:9030
                AwardsSection(
                    state: viewModel.awardsState,
                    onCardTap: { _ in viewModel.navigateToAboutAward = true },
                    onRetry: { viewModel.retryAwards() }
                )

                // mm:6885:9039
                if case .loaded(let info) = viewModel.kudosState {
                    KudosSection(
                        info: info,
                        onDetailsTap: { viewModel.navigateToAboutKudos = true }
                    )
                }

                // mm:6885:9058 — FAB sits inline in scroll content, right-aligned
                HStack {
                    Spacer()
                    FloatingActionButton(
                        onWriteKudo: { viewModel.navigateToWriteKudo = true },
                        onKudosFeed: { viewModel.navigateToKudosFeed = true }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer(minLength: 32)
            }
        }
        // mm:6885:8979 — keyvisual background layers bleed under safe areas
        .background(backgroundLayer.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.load()
        }
        .onAppear {
            viewModel.startCountdown()
        }
        .onDisappear {
            viewModel.stopCountdown()
        }
        .navigationDestination(isPresented: $viewModel.navigateToAboutAward) {
            AwardsOverviewView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToAboutKudos) {
            KudosOverviewView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToSearch) {
            SearchView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToBell) {
            NotificationsView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToWriteKudo) {
            WriteKudoView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToKudosFeed) {
            KudosFeedView()
        }
        .navigationDestination(isPresented: $viewModel.navigateToAccessDenied) {
            AccessDeniedView()
        }
    }

    // MARK: - Background

    private var backgroundLayer: some View {
        ZStack {
            // mm:6885:8980 — keyvisual BG image asset
            Image("KeyvisualBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()

            // mm:6885:8981 — Shadow Left: horizontal gradient #00101A → #10181F → transparent (77.2%)
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Self.shadowDark, location: 0.0),
                    .init(color: Self.shadowDarkLight, location: 0.1861),
                    .init(color: Self.shadowDark.opacity(0), location: 0.772)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()

            // mm:6885:8982 — Shadow Bottom: vertical gradient, solid #00101A bottom 25.41%, fading to transparent toward top
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Self.shadowDark.opacity(0), location: 0.0),
                    .init(color: Self.shadowDark, location: 0.7459),
                    .init(color: Self.shadowDark, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }

    private static let shadowDark = Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0)
    private static let shadowDarkLight = Color(red: 0x10 / 255.0, green: 0x18 / 255.0, blue: 0x1F / 255.0)
}

#Preview {
    HomeView(tokenStore: TokenStore())
}
