//
//  EventInfoCard.swift
//  SAA2025
//

import SwiftUI

// MARK: - EventInfoCard

// mm:6885:9016
struct EventInfoCard: View {

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // mm:6885:9017
            infoRow(text: "\(localizer.t("event.info.time.label"))\(Self.formattedEventDate)")
            // mm:6885:9020
            infoRow(text: localizer.t("event.info.location"))
            // mm:6885:9023
            infoRow(text: localizer.t("event.info.livestream"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Private

    /// Formats `Config.eventDate` as `dd/MM/yyyy` (locale-independent, matches design).
    private static var formattedEventDate: String {
        let cal = Calendar(identifier: .gregorian)
        let comp = cal.dateComponents([.day, .month, .year], from: Config.eventDate)
        return String(format: "%02d/%02d/%d", comp.day ?? 0, comp.month ?? 0, comp.year ?? 0)
    }

    private func infoRow(text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        EventInfoCard()
            .padding()
            .environmentObject(Localizer())
    }
}
