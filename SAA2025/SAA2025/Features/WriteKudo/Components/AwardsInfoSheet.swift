//
//  AwardsInfoSheet.swift
//  SAA2025
//
//  B.5 Community Standards / Awards Information bottom sheet.
//

import SwiftUI

// MARK: - AwardsInfoSheet

struct AwardsInfoSheet: View {

    let onDismiss: () -> Void

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(localizer.t("writkudo.awards_info.title"))
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom, 4)

                    Text(localizer.t("writkudo.awards_info.description"))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary)
                        .lineSpacing(4)

                    Text(localizer.t("writkudo.awards_info.examples.label"))
                        .font(.system(size: 14, weight: .medium))

                    VStack(alignment: .leading, spacing: 8) {
                        bulletRow(localizer.t("writkudo.awards_info.example.1"))
                        bulletRow(localizer.t("writkudo.awards_info.example.2"))
                        bulletRow(localizer.t("writkudo.awards_info.example.3"))
                    }

                    Text(localizer.t("writkudo.awards_info.note"))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.top, 12)
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(localizer.t("btn.close")) { onDismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }

    @ViewBuilder
    private func bulletRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.system(size: 14, weight: .bold))
            Text(text)
                .font(.system(size: 14, weight: .regular))
            Spacer()
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            AwardsInfoSheet(onDismiss: {})
                .environmentObject(Localizer())
        }
}
