//
//  SignUpView.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct SignUpView : View {
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            Input(
                placeholder: "Ad",
                LeftIcon: Image(systemName: "person"),
                isPasswordSecured: .constant(false),
                text: $viewModel.name
            )
            Input(
                placeholder: "Soyad",
                LeftIcon: Image(systemName: "person"),
                isPasswordSecured: .constant(false),
                text: $viewModel.surname
            )
            Input(
                placeholder: "E-posta",
                LeftIcon: Image(systemName: "envelope"),
                isPasswordSecured: .constant(false),
                text: $viewModel.email
            )
            Input(
                placeholder: "Şifre",
                LeftIcon: Image(systemName: "lock"),
                RightIcon: Image(systemName: "eye"),
                rightButtonPressed: { viewModel.isPasswordSecured.toggle() },
                isSecure: true,
                isPasswordSecured: $viewModel.isPasswordSecured,
                text: $viewModel.password,
            )
            
            ButtonWithLabel(label: "Kayıt Ol",
                            onPress: viewModel.onSignUp,
                            isButtonDisabled: viewModel.isButtonDisabled()
            )
        }.padding(AppConstants.padding)
    }
}

#Preview {
    SignUpView()
}
