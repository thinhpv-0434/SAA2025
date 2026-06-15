//
//  SearchView.swift
//  SAA2025
//
//  Screens:
//   - Empty state ("Recent"):     3jgwke3E8O
//   - Active typing (results):    hldqjHoSRH
//   Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/3jgwke3E8O
//

import SwiftUI

// MARK: - SearchView

/// Global sunner search reached from the magnifying-glass icon on the Home
/// header. Two visual states share one screen:
///   - Empty input → "Recent" header + recent rows (× to remove)
///   - Typing → matching sunner rows
/// Tapping a row navigates to that sunner's `OtherProfileView`.
struct SearchView: View {

    @StateObject private var viewModel = SearchViewModel()
    @State private var selectedProfile: ProfileUser?
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        ZStack(alignment: .top) {
            AwardsBackground()

            VStack(spacing: 0) {
                SearchInputBar(
                    query: $viewModel.query,
                    placeholder: localizer.t("search.input.placeholder"),
                    onBack: { dismiss() },
                    onSubmit: {}
                )
                .padding(.top, 4)
                .padding(.bottom, 12)

                content
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: viewModel.query) { _, _ in viewModel.onQueryChange() }
        .navigationDestination(item: $selectedProfile) { user in
            OtherProfileView(user: user)
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isQueryEmpty {
            recentSection
        } else {
            resultsList
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            RecentSearchesHeader(onViewAll: {})
                .padding(.top, 4)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 4) {
                    ForEach(viewModel.recent) { item in
                        SunnerSearchRow(
                            result: item,
                            onRemove: { viewModel.removeRecent(item) },
                            onTap: { open(item) }
                        )
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 32)
            }
        }
    }

    private var resultsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 4) {
                ForEach(viewModel.results) { item in
                    SunnerSearchRow(
                        result: item,
                        onRemove: nil,
                        onTap: { open(item) }
                    )
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 32)
        }
    }

    private func open(_ item: SunnerSearchResult) {
        viewModel.recordRecent(item)
        selectedProfile = ProfileUser(
            displayName: item.displayName,
            employeeCode: item.employeeCode,
            badgeLabel: item.badgeTier == .legend ? "Legend Hero" : "Rising Hero",
            badgeTier: item.badgeTier
        )
    }
}

#Preview {
    NavigationStack { SearchView() }
        .environmentObject(Localizer())
}
