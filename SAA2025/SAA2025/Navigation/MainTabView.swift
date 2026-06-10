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

    var body: some View {
        TabView {
            NavigationStack {
                HomeViewContainer()
            }
            .tabItem {
                Label("SAA 2025", systemImage: "house.fill")
            }

            NavigationStack {
                AwardsTabView()
            }
            .tabItem {
                Label("Awards", systemImage: "trophy.fill")
            }

            NavigationStack {
                KudosTabViewContainer()
            }
            .tabItem {
                Label("Kudos", systemImage: "heart.fill")
            }

            NavigationStack {
                ProfileTabView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .tint(Color("saaGold"))
    }
}

#Preview {
    MainTabView()
        .environmentObject(TokenStore())
}
