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

    var body: some View {
        TabView {
            NavigationStack {
                HomeViewContainer()
            }
            .tabItem {
                Label(localizer.t("tab.saa2025"), systemImage: "house.fill")
            }

            NavigationStack {
                AwardsTabViewContainer()
            }
            .tabItem {
                Label(localizer.t("tab.awards"), systemImage: "trophy.fill")
            }

            NavigationStack {
                KudosTabViewContainer()
            }
            .tabItem {
                Label(localizer.t("tab.kudos"), systemImage: "heart.fill")
            }

            NavigationStack {
                ProfileTabView()
            }
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
