//
//  AwardDetailView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 9/6/26.
//

import SwiftUI

// MARK: - AwardDetailView

struct AwardDetailView: View {

    let award: Award

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(spacing: 12) {
            Text(award.title)
                .font(.title2.bold())
            Text(award.shortDescription)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(localizer.t("award.detail.nav.title"))
    }
}

#Preview {
    NavigationStack {
        AwardDetailView(award: Award(
            id: UUID(),
            title: "Top Talent",
            shortDescription: "Recognising outstanding individual contribution",
            imageName: "AwardBadgeBG"
        ))
    }
    .environmentObject(Localizer())
}
