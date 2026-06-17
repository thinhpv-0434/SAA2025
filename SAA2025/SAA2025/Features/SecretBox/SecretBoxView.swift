//
//  SecretBoxView.swift
//  SAA2025
//
//  Screens: [iOS] Open secret box (kQk65hSYF2 + 8 standby/reveal variants)
//  Design: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/kQk65hSYF2
//

import SwiftUI

// MARK: - SecretBoxView

/// Tap-to-open Secret Box reached from the "Mở Secret Box" CTA on the
/// Profile and Kudos tabs. One screen covers all nine Figma variants by
/// switching on `SecretBoxState`: the wrapped gift box, the about-to-open
/// burst, and six reward reveals (badge icons + physical gifts).
// mm:6885:9402 — [iOS] Open secret box
struct SecretBoxView: View {

    @StateObject private var viewModel: SecretBoxViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizer: Localizer

    init(unopenedCount: Int = 5) {
        _viewModel = StateObject(
            wrappedValue: SecretBoxViewModel(unopenedCount: unopenedCount)
        )
    }

    private static let divider = Color.white.opacity(0.18)

    var body: some View {
        ZStack(alignment: .top) {

            VStack(spacing: 0) {
                topBar

                Spacer(minLength: 24)

                headlines

                Spacer(minLength: 12)

                interactiveStage

                Spacer(minLength: 12)

                Rectangle().fill(Self.divider).frame(height: 1).padding(.horizontal, 24)

                footer

                Spacer()
            }
        }
        .background(Color.black)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Top bar

    private var topBar: some View {
        ZStack {
            Text(localizer.t("secret_box.nav.title"))
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 4)
    }

    // MARK: - Headlines (state-dependent)

    @ViewBuilder
    private var headlines: some View {
        switch viewModel.state {
        case .unopened, .opening:
            VStack(spacing: 8) {
                Text(localizer.t("secret_box.headline.discover"))
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color("saaGold"))
                    .multilineTextAlignment(.center)
                    .kerning(0.6)
                Rectangle().fill(Self.divider).frame(height: 1).padding(.horizontal, 24)
                Text(localizer.t("secret_box.headline.tap_hint"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)

        case .revealed:
            VStack(spacing: 8) {
                Text(localizer.t("secret_box.headline.congrats"))
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color("saaGold"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Rectangle().fill(Self.divider).frame(height: 1).padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Interactive stage (tappable box / reveal art)

    private var interactiveStage: some View {
        Button(action: { viewModel.openNext() }) {
            SecretBoxIllustration(state: viewModel.state)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Footer

    @ViewBuilder
    private var footer: some View {
        switch viewModel.state {
        case .unopened, .opening:
            HStack(spacing: 6) {
                Text(localizer.t("secret_box.footer.unopened_label"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.85))
                Text(String(format: "%02d", viewModel.unopenedCount))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .monospacedDigit()
            }
            .padding(.top, 16)

        case .revealed(let reward):
            VStack(spacing: 16) {
                Text(reward.caption)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color("saaGold"))
                    .padding(.top, 14)

                if viewModel.unopenedCount > 0 {
                    Button(action: { viewModel.resetToUnopened() }) {
                        HStack(spacing: 6) {
                            Text(localizer.t("secret_box.btn.open_another"))
                                .font(.system(size: 14, weight: .semibold))
                            Text("(\(viewModel.unopenedCount))")
                                .font(.system(size: 14, weight: .regular))
                        }
                        .foregroundColor(Color(red: 0x1A / 255.0, green: 0x14 / 255.0, blue: 0x0A / 255.0))
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0xFA / 255.0, green: 0xE6 / 255.0, blue: 0x86 / 255.0))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { SecretBoxView() }
        .environmentObject(Localizer())
}
