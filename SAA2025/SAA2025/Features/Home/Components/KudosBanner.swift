//
//  KudosBanner.swift
//  SAA2025
//

import SwiftUI

// MARK: - KudosBanner

// mm:6885:9041
struct KudosBanner: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        // mm:6885:9043
        Group {
            if UIImage(named: "KudosBanner") != nil {
                Image("KudosBanner")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            } else {
                fallbackBanner
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Fallback

    private var fallbackBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.06, green: 0.06, blue: 0.12))
            VStack(spacing: 8) {
                // mm:6885:9045
                Text(localizer.t("home.banner.kudos.title"))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Text(localizer.t("home.banner.kudos.subtitle"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                    .kerning(3)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 145)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        KudosBanner()
            .padding()
            .environmentObject(Localizer())
    }
}
