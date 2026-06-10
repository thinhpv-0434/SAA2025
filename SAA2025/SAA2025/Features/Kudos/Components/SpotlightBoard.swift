//
//  SpotlightBoard.swift
//  SAA2025
//

import SwiftUI

// MARK: - SpotlightBoard

// mm:6885:B.7: Spotlight Board — total count + network chart placeholder + search field
struct SpotlightBoard: View {

    let totalKudosCount: Int
    @Binding var searchText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // mm:6885:B.7.1 — "388 KUDOS" total count badge
            // mm:6885:9088 — B.7.1 total count label
            Text("\(totalKudosCount) KUDOS")
                .font(.system(size: 13, weight: .black))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.12))
                )
                .padding(.horizontal, 20)

            // mm:6885:B.7.2 — network chart placeholder (static PNG crop placeholder)
            networkChartPlaceholder

            // mm:6885:B.7.3 — search field "Tìm kiếm"
            searchField
                .padding(.horizontal, 20)
        }
    }

    // MARK: - Network Chart Placeholder

    private var networkChartPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0x0A / 255.0, green: 0x12 / 255.0, blue: 0x1E / 255.0))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )

            // Static visual — dots + lines network chart
            networkDotPattern

            // Overlay label
            VStack(spacing: 4) {
                Spacer()
                Text("Spotlight Network")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.25))
                    .padding(.bottom, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .padding(.horizontal, 20)
    }

    // Simple decorative dot/line pattern standing in for the real network chart
    private var networkDotPattern: some View {
        Canvas { context, size in
            let dotPositions: [(CGFloat, CGFloat)] = [
                (0.15, 0.3), (0.35, 0.15), (0.55, 0.25), (0.75, 0.1),
                (0.25, 0.55), (0.5, 0.5), (0.7, 0.6), (0.9, 0.4),
                (0.1, 0.75), (0.4, 0.8), (0.65, 0.85), (0.85, 0.75)
            ]
            let edges: [(Int, Int)] = [
                (0,1),(1,2),(2,3),(0,4),(4,5),(5,6),(6,7),(4,8),(8,9),(9,10),(10,11),(5,9),(2,6)
            ]
            let pts = dotPositions.map { CGPoint(x: $0.0 * size.width, y: $0.1 * size.height) }

            // Draw edges
            for (a, b) in edges {
                var path = Path()
                path.move(to: pts[a])
                path.addLine(to: pts[b])
                context.stroke(path, with: .color(.white.opacity(0.12)), lineWidth: 1)
            }
            // Draw nodes
            for pt in pts {
                let rect = CGRect(x: pt.x - 3, y: pt.y - 3, width: 6, height: 6)
                context.fill(Path(ellipseIn: rect), with: .color(Color("saaGold").opacity(0.6)))
            }
        }
    }

    // MARK: - Search Field

    // mm:6885:B.7.3 — "Tìm kiếm" text input
    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.4))
            TextField("", text: $searchText)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .placeholder(when: searchText.isEmpty) {
                    Text("Tìm kiếm")
                        .foregroundColor(.white.opacity(0.4))
                }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

// MARK: - View+Placeholder helper

private extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: .leading) {
            if shouldShow { placeholder() }
            self
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0x00 / 255.0, green: 0x10 / 255.0, blue: 0x1A / 255.0).ignoresSafeArea()
        SpotlightBoard(totalKudosCount: 388, searchText: .constant(""))
            .padding(.vertical, 12)
    }
}
