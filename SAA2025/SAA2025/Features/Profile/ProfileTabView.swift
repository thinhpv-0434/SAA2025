//
//  ProfileTabView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

struct ProfileTabView: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(spacing: 12) {
            Text(localizer.t("profile.title"))
                .font(.title2.bold())
            Text(localizer.t("stub.coming_soon"))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(localizer.t("profile.nav.title"))
    }
}

#Preview {
    NavigationStack { ProfileTabView() }
        .environmentObject(Localizer())
}
