//
//  AwardsOverviewView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

struct AwardsOverviewView: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(spacing: 12) {
            Text(localizer.t("awards.overview.nav.title"))
                .font(.title2.bold())
            Text(localizer.t("stub.coming_soon"))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(localizer.t("awards.overview.nav.title"))
    }
}

#Preview {
    NavigationStack { AwardsOverviewView() }
        .environmentObject(Localizer())
}
