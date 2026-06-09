//
//  GoogleSignInButton.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import SwiftUI

// MARK: - GoogleSignInButton

// mm:6885:8969
struct GoogleSignInButton: View {

    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            buttonLabel
        }
        .disabled(isLoading)
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Label

    private var buttonLabel: some View {
        HStack(spacing: 10) {
            // mm:I6885:8969;28:1998
            Text("LOGIN With Google")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))

            // mm:I6885:8969;28:1997
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.13, green: 0.13, blue: 0.13)))
                    .frame(width: 20, height: 20)
            } else {
                Image("GoogleGLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 16)
        .background(
            Capsule()
                .fill(Color(red: 0.96, green: 0.93, blue: 0.84)) // cream/pale-yellow
        )
        .opacity(isLoading ? 0.7 : 1.0)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 20) {
            GoogleSignInButton(isLoading: false, action: {})
            GoogleSignInButton(isLoading: true, action: {})
        }
    }
}
