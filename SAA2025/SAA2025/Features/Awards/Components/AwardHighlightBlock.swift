//
//  AwardHighlightBlock.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardHighlightBlock

/// Section B of the Awards tab. Vertical stack: small white subtitle,
/// two-line gold title, and a `Menu`-wrapped `AwardDropdownButton`.
/// The Menu lists every award supplied via `awards`; selecting one fires
/// `onSelect` with that award's `id` (primitive prop — no `Award` leakage).
// mm:6885:10453 — mms_B_Highlight (container)
struct AwardHighlightBlock: View {

    let awards: [Award]
    let selectedID: Award.ID?
    let onSelect: (Award.ID) -> Void

    @EnvironmentObject private var localizer: Localizer

    /// Title shown in the dropdown trigger, derived from the currently
    /// selected award. Falls back to a generic placeholder when nothing
    /// is selected yet (e.g. mid-load).
    private var selectionTitle: String {
        awards.first(where: { $0.id == selectedID })?.title ?? "Top Project"
    }

    var body: some View {
        // mm:6885:10454 — mms_B.1_header (container — child node IDs not in spec)
        VStack(spacing: 16) {
            // mm:6885:10454 (subtitle)
            Text(localizer.t("awards.highlight.subtitle"))
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)

            // mm:6885:10454 (title — two lines)
            Text(localizer.t("awards.highlight.title"))
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color("saaGold"))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)

            // mm:6885:10454 (dropdown trigger)
            Menu {
                ForEach(awards) { award in
                    Button(action: { onSelect(award.id) }) {
                        if award.id == selectedID {
                            Label(award.title, systemImage: "checkmark")
                        } else {
                            Text(award.title)
                        }
                    }
                }
            } label: {
                AwardDropdownButton(selectionTitle: selectionTitle)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}

private struct AwardHighlightBlockPreview: View {
    private let awards = [
        Award(id: UUID(), title: "Top Talent",     shortDescription: "", imageName: "TopTalentBadge"),
        Award(id: UUID(), title: "Top Project",    shortDescription: "", imageName: "TopProjectBadge"),
        Award(id: UUID(), title: "Top Innovation", shortDescription: "", imageName: "TopInnovationBadge")
    ]
    var body: some View {
        ZStack {
            Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0)
                .ignoresSafeArea()
            AwardHighlightBlock(
                awards: awards,
                selectedID: awards[1].id,
                onSelect: { _ in }
            )
        }
        .environmentObject(Localizer())
    }
}

#Preview { AwardHighlightBlockPreview() }
