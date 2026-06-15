//
//  AccessDeniedView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

struct AccessDeniedView: View {

    @EnvironmentObject private var tokenStore: TokenStore
    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(spacing: 12) {
            Text(localizer.t("access_denied.title"))
                .font(.title2.bold())
            Text(localizer.t("stub.coming_soon"))
                .foregroundStyle(.secondary)
            Button(localizer.t("access_denied.btn.back_to_login")) {
                tokenStore.clear()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(localizer.t("access_denied.nav.title"))
    }
}

#Preview {
    NavigationStack { AccessDeniedView() }
        .environmentObject(TokenStore())
        .environmentObject(Localizer())
}
