//
//  MainTabView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

// MARK: - MainTabView

/// Root TabView for authenticated users.
/// Each tab owns an independent NavigationStack so back-stacks are preserved
/// when switching tabs. Phase 6 wires real content into tab 1 (SAA 2025).
struct MainTabView: View {

    @EnvironmentObject private var tokenStore: TokenStore
    @EnvironmentObject private var localizer: Localizer
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack {
                HomeViewContainer()
            }
            .tag(AppCoordinator.Tab.home)
            .tabItem {
                Label(localizer.t("tab.saa2025"), systemImage: "house.fill")
            }

            NavigationStack {
                AwardsTabViewContainer()
            }
            .tag(AppCoordinator.Tab.awards)
            .tabItem {
                Label(localizer.t("tab.awards"), systemImage: "trophy.fill")
            }

            NavigationStack {
                KudosTabViewContainer()
            }
            .tag(AppCoordinator.Tab.kudos)
            .tabItem {
                Label(localizer.t("tab.kudos"), systemImage: "heart.fill")
            }

            NavigationStack {
                ProfileTabView()
            }
            .tag(AppCoordinator.Tab.profile)
            .tabItem {
                Label(localizer.t("tab.profile"), systemImage: "person.fill")
            }
        }
        .tint(Color("saaGold"))
    }
}

#Preview {
    MainTabView()
        .environmentObject(TokenStore())
        .environmentObject(Localizer())
}
