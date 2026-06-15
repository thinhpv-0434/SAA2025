//
//  AwardsSunKudosSection.swift
//  SAA2025
//

import SwiftUI

// MARK: - AwardsSunKudosSection

/// Bottom section of the Awards tab. Promotes the Sun*Kudos system as a
/// related-feature CTA. Layout (per node 6885:10485):
/// 1. Header — small white subtitle "Phong trào ghi nhận" + gold title "Sun* Kudos"
/// 2. Kudos brand banner — full-width rounded card with the KUDOS wordmark
/// 3. Body copy — "ĐIỂM MỚI CỦA SAA 2025" + multi-line description
/// 4. Gold "Chi tiết" CTA button
// mm:6885:10485 — kudos section (container)
struct AwardsSunKudosSection: View {

    let onCTATap: () -> Void

    @EnvironmentObject private var localizer: Localizer

    private static let dividerColor = Color(red: 0x2E/255.0, green: 0x39/255.0, blue: 0x40/255.0)

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header
            banner
            note
            ctaButton
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 16)
    }

    // MARK: - Subviews

    // mm:6885:10486 — header (subtitle + divider + title)
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(localizer.t("home.kudos.subtitle"))
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)

            Rectangle()
                .fill(Self.dividerColor)
                .frame(height: 1)

            Text(localizer.t("home.kudos.title"))
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color("saaGold"))
                .padding(.top, 8)
        }
    }

    // mm:6885:10487 — Sun*Kudos brand banner
    private var banner: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background panel — uses existing KudosBanner asset when present;
            // otherwise renders a tonal placeholder so the layout still holds.
            if UIImage(named: "KudosBanner") != nil {
                Image("KudosBanner")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 145)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 4.65))
            } else {
                RoundedRectangle(cornerRadius: 4.65)
                    .fill(Color(red: 0x0F/255.0, green: 0x0F/255.0, blue: 0x0F/255.0))
                    .frame(height: 145)

                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(Color(red: 0xFF/255.0, green: 0x6A/255.0, blue: 0x1A/255.0))
                    Text(localizer.t("kudos.hero.title"))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 0xDB/255.0, green: 0xD1/255.0, blue: 0xC1/255.0))
                        .kerning(-2)
                }
                .padding(16)
            }
        }
    }

    // mm:6885:10499 — note copy
    private var note: some View {
        Text(localizer.t("awards.kudos.note"))
            .font(.system(size: 14, weight: .light))
            .foregroundColor(.white)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
    }

    // mm:6885:10501 — CTA button
    private var ctaButton: some View {
        Button(action: onCTATap) {
            HStack(spacing: 8) {
                Text(localizer.t("home.kudos.btn.details"))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0))

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(minWidth: 160)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("saaGold"))
            )
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0x00/255.0, green: 0x10/255.0, blue: 0x1A/255.0)
            .ignoresSafeArea()
        ScrollView { AwardsSunKudosSection(onCTATap: {}) }
    }
    .environmentObject(Localizer())
}
