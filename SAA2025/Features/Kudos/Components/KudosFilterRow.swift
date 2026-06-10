//
//  KudosFilterRow.swift
//  SAA2025
//

import SwiftUI

// MARK: - KudosFilterRow

// mm:6885:9071 — B.1: two dropdown filter pills (Hashtag + Phòng ban)
struct KudosFilterRow: View {

    let selectedHashtag: Hashtag?
    let selectedDepartment: Department?
    let hashtags: [Hashtag]
    let departments: [Department]
    let onSelectHashtag: (Hashtag?) -> Void
    let onSelectDepartment: (Department?) -> Void

    var body: some View {
        HStack(spacing: 10) {
            // mm:6885:9072 — B.1.1: Hashtag filter
            Menu {
                Button("Tất cả") { onSelectHashtag(nil) }
                ForEach(hashtags) { tag in
                    Button(tag.name) { onSelectHashtag(tag) }
                }
            } label: {
                filterPill(label: selectedHashtag?.name ?? "Hashtag")
            }

            // mm:6885:9073 — B.1.2: Department filter
            Menu {
                Button("Tất cả") { onSelectDepartment(nil) }
                ForEach(departments) { dept in
                    Button(dept.name) { onSelectDepartment(dept) }
                }
            } label: {
                filterPill(label: selectedDepartment?.name ?? "Phòng ban")
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Private

    private func filterPill(label: String) -> some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
            Image(systemName: "chevron.down")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.12))
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.20), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        KudosFilterRow(
            selectedHashtag: nil,
            selectedDepartment: nil,
            hashtags: KudosFixtures.hashtags,
            departments: KudosFixtures.departments,
            onSelectHashtag: { _ in },
            onSelectDepartment: { _ in }
        )
        .padding(.vertical, 12)
    }
}
