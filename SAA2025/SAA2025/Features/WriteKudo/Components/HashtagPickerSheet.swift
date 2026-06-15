//
//  HashtagPickerSheet.swift
//  SAA2025
//
//  E.2 hashtag picker — multi-select from existing list + free-text input.
//

import SwiftUI

// MARK: - HashtagPickerSheet

struct HashtagPickerSheet: View {

    let allHashtags: [Hashtag]
    let selectedHashtags: [String]   // already-selected
    let onToggle: (String) -> Void   // adds if not present, removes if present
    let onAddFreeText: (String) -> Void
    let onDismiss: () -> Void

    @State private var freeText: String = ""
    @EnvironmentObject private var localizer: Localizer

    private var availableCount: Int {
        max(0, KudoDraftLimits.hashtagMax - selectedHashtags.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    headerCounter
                        .padding(.horizontal, 16)

                    freeTextRow
                        .padding(.horizontal, 16)

                    Text(localizer.t("writkudo.hashtag.available.label"))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)

                    chipGrid
                        .padding(.horizontal, 16)
                }
                .padding(.vertical, 16)
            }
            .navigationTitle(localizer.t("writkudo.hashtag.nav.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(localizer.t("btn.done")) { onDismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    // MARK: - Sub-views

    private var headerCounter: some View {
        Text("\(localizer.t("writkudo.hashtag.counter.prefix"))\(selectedHashtags.count)\(localizer.t("writkudo.hashtag.counter.sep"))\(KudoDraftLimits.hashtagMax)")
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.secondary)
    }

    private var freeTextRow: some View {
        HStack(spacing: 8) {
            TextField(localizer.t("writkudo.hashtag.input.placeholder"), text: $freeText)
                .font(.system(size: 14))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Button(action: addFreeText) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(freeText.trimmingCharacters(in: .whitespaces).isEmpty || availableCount == 0)
        }
    }

    private var chipGrid: some View {
        FlowLayoutWriteKudo(spacing: 8) {
            ForEach(allHashtags) { tag in
                let display = "#\(tag.name)"
                let selected = selectedHashtags.contains(display)
                Button(action: { onToggle(display) }) {
                    Text(display)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(selected ? .white : .primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(selected ? Color.accentColor : Color(.systemGray6))
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!selected && availableCount == 0)
            }
        }
    }

    private func addFreeText() {
        let trimmed = freeText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        onAddFreeText(trimmed)
        freeText = ""
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            HashtagPickerSheet(
                allHashtags: KudosFixtures.hashtags,
                selectedHashtags: ["#Dedicated"],
                onToggle: { _ in },
                onAddFreeText: { _ in },
                onDismiss: {}
            )
            .environmentObject(Localizer())
        }
}
