//
//  ProfileKudosFilter.swift
//  SAA2025
//

import SwiftUI

// MARK: - ProfileKudosFilter

/// Sent/Received filter selector shown above the kudos list on the Profile
/// tab. Wraps `AwardDropdownButton` (visual token) inside a SwiftUI `Menu`
/// to keep selection logic native to iOS.
// mm:6885:10388 — mms_dropdown + mms_A_Dropdown-List
enum ProfileKudosFilter: Hashable {
    case received
    case sent

    func label(_ localizer: Localizer, count: Int) -> String {
        let key = self == .received ? "profile.filter.received" : "profile.filter.sent"
        return "\(localizer.t(key)) (\(count))"
    }
}

struct ProfileKudosFilterPicker: View {

    @Binding var selection: ProfileKudosFilter
    let receivedCount: Int
    let sentCount: Int

    @EnvironmentObject private var localizer: Localizer

    var body: some View {
        Menu {
            Button(action: { selection = .received }) {
                Label(
                    ProfileKudosFilter.received.label(localizer, count: receivedCount),
                    systemImage: selection == .received ? "checkmark" : ""
                )
            }
            Button(action: { selection = .sent }) {
                Label(
                    ProfileKudosFilter.sent.label(localizer, count: sentCount),
                    systemImage: selection == .sent ? "checkmark" : ""
                )
            }
        } label: {
            AwardDropdownButton(
                selectionTitle: currentTitle
            )
        }
    }

    private var currentTitle: String {
        switch selection {
        case .received: return ProfileKudosFilter.received.label(localizer, count: receivedCount)
        case .sent:     return ProfileKudosFilter.sent.label(localizer, count: sentCount)
        }
    }
}

#Preview {
    StatefulPreviewWrapper(ProfileKudosFilter.sent) { binding in
        ZStack {
            Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
            ProfileKudosFilterPicker(
                selection: binding,
                receivedCount: 5,
                sentCount: 5
            )
            .environmentObject(Localizer())
        }
    }
}

// MARK: - Preview helper

/// Small helper to host a `@State` value for SwiftUI previews — kept private to
/// this file because no other component currently needs it.
private struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ initial: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initial)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
