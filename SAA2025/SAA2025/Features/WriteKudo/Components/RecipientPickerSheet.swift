//
//  RecipientPickerSheet.swift
//  SAA2025
//
//  B.2 recipient bottom sheet — searchable mock user list.
//

import SwiftUI

// MARK: - RecipientPickerSheet

struct RecipientPickerSheet: View {

    let recipients: [KudosUser]
    let onSelect: (KudosUser) -> Void
    let onDismiss: () -> Void

    @State private var search: String = ""
    @EnvironmentObject private var localizer: Localizer

    private var filtered: [KudosUser] {
        let q = search.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return recipients }
        return recipients.filter {
            $0.name.lowercased().contains(q) || $0.department.lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                List(filtered) { user in
                    Button(action: { onSelect(user) }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                            Text(user.department)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .listStyle(.plain)
            }
            .navigationTitle(localizer.t("writkudo.recipient_picker.nav.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(localizer.t("btn.close")) { onDismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
            TextField(localizer.t("writkudo.recipient_picker.search.placeholder"), text: $search)
                .font(.system(size: 14))
            if !search.isEmpty {
                Button(action: { search = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            RecipientPickerSheet(
                recipients: WriteKudoFixtures.allUsers,
                onSelect: { _ in },
                onDismiss: {}
            )
            .environmentObject(Localizer())
        }
}
