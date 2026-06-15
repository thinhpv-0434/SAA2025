//
//  SearchInputBar.swift
//  SAA2025
//

import SwiftUI

// MARK: - SearchInputBar

/// Top-of-screen row for the Sun*Kudos search: chevron-back + bordered
/// text field. Matches the Figma frames (mm:6891:22118 / 6891:21272).
struct SearchInputBar: View {

    @Binding var query: String
    let placeholder: String
    let onBack: () -> Void
    let onSubmit: () -> Void

    @FocusState private var isFocused: Bool

    private static let borderColor = Color.white.opacity(0.20)
    private static let fillColor = Color.white.opacity(0.04)

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36)

            TextField("", text: $query, prompt: prompt)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .tint(Color("saaGold"))
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit(onSubmit)
                .padding(.horizontal, 14)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Self.fillColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Self.borderColor, lineWidth: 1)
                )
                .onAppear { isFocused = true }
        }
        .padding(.horizontal, 12)
        .padding(.top, 4)
    }

    private var prompt: Text {
        Text(placeholder)
            .foregroundColor(.white.opacity(0.5))
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        StatefulPreviewWrapper("") { binding in
            SearchInputBar(
                query: binding,
                placeholder: "Search Sunner",
                onBack: {},
                onSubmit: {}
            )
        }
    }
}

private struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ initial: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initial)
        self.content = content
    }

    var body: some View { content($value) }
}
