//
//  WriteKudoNavBar.swift
//  SAA2025
//
//  Screen: [iOS] Sun*Kudos_Viết Kudo_default — 7fFAb-K35a
//

import SwiftUI

// MARK: - WriteKudoNavBar

// mm:6885:9271 (root) — custom nav bar overlay
struct WriteKudoNavBar: View {

    let onBack: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        ZStack {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44, alignment: .leading)
                        .padding(.leading, 8)
                }
                Spacer()
            }

            Text(localizer.t("writkudo.nav.title"))
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(height: 44)
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        VStack {
            WriteKudoNavBar(onBack: {})
            Spacer()
        }
        .environmentObject(Localizer())
    }
}
