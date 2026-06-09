//
//  LoginView.swift
//  SAA2025
//
//  Created by pham.van.thinh on 8/6/26.
//

import SwiftUI

// MARK: - LoginView

// mm:6885:8963
struct LoginView: View {

    @StateObject private var viewModel: LoginViewModel
    @State private var selectedLang: Lang = .vn

    init(tokenStore: TokenStore) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(tokenStore: tokenStore))
    }

    var body: some View {
        ZStack {
            // mm:6885:8964 / mm:6885:8965
            background

            VStack(spacing: 0) {
                // mm:6885:8972
                header

                Spacer()

                // mm:6885:8967
                logoSection

                // mm:6885:8968
                taglineText

                Spacer()

                // mm:6885:8969
                loginButton

                // mm:6885:8970 / mm:6885:8971
                footer
            }
        }
        .alert(
            "Đăng nhập thất bại",
            isPresented: $viewModel.showError
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Vui lòng thử lại.")
        }
    }

    // MARK: - Subviews

    private var background: some View {
        // mm:6885:8965
        Image("KeyvisualBG")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

    private var header: some View {
        // mm:6885:8972
        HStack(alignment: .center) {
            // mm:6885:8977
            Image("SunAALogo")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 44)

            Spacer()

            // mm:6885:8976
            LanguagePicker(selectedLang: $selectedLang)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var logoSection: some View {
        // mm:6885:8967
        HStack {
            Image("RootFurtherLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 247, height: 109)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private var taglineText: some View {
        // mm:6885:8968
        HStack {
            Text("Bắt đầu hành trình của bạn cùng SAA 2025.\nĐăng nhập để khám phá!")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
                .lineSpacing(4)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }

    private var loginButton: some View {
        // mm:6885:8969
        GoogleSignInButton(isLoading: viewModel.isLoading) {
            viewModel.signIn()
        }
        .padding(.bottom, 40)
    }

    private var footer: some View {
        // mm:6885:8970 / mm:6885:8971
        Text("Bản quyền thuộc về Sun* © 2025")
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.white.opacity(0.7))
            .padding(.bottom, 24)
    }
}

#Preview {
    LoginView(tokenStore: TokenStore())
}
