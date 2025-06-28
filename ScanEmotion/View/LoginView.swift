//
//  LoginView.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

enum Field: Hashable {
    case email, password
}

 struct LoginView: View {
     @StateObject var viewModel: LoginViewModel
     @FocusState private var focusedField: Field?
     
     init(appRouter: AppRouter, userSession: UserSession) {
         _viewModel = StateObject(wrappedValue: LoginViewModel(appRouter: appRouter, userSession: userSession))
     }

     
     var body: some View {
         VStack(alignment: .center, spacing: 8) {
             
             Spacer()
             Input(
                placeholder: "E-posta",
                LeftIcon: Image(systemName: "envelope"),
                autocapitalization: .never,
                isPasswordSecured: .constant(false),
                text: $viewModel.email
             ).onChange(of: viewModel.email) { _ in viewModel.updateButtonState() }
             
             if let emailError = viewModel.emailError {
                 Text(emailError)
                     .foregroundColor(.red)
                     .font(.caption)
                     .frame(maxWidth: .infinity, alignment: .leading)
                     .padding(.horizontal, AppConstants.padding)
             }
             
             Input(
                placeholder: "Şifre",
                LeftIcon: Image(systemName: "lock"),
                RightIcon: Image(systemName: "eye"),
                rightButtonPressed: { viewModel.isPasswordSecured.toggle() },
                isSecure: true,
                isPasswordSecured: $viewModel.isPasswordSecured,
                text: $viewModel.password,
             )
            
             
             // ButtonWithLabel(label:"Giriş Yap", onPress: viewModel.signIn, isButtonDisabled: viewModel.isButtonDisabled)
             ButtonWithLabel(label:"Giriş Yap", onPress: viewModel.signIn, isButtonDisabled: false)
             
             Spacer()
             
             NavigationLink(destination: SignUpView()) {
                 HStack(spacing: 4) {
                     Text("Hesabın yok mu?")
                         .foregroundColor(.gray)
                     Text("Kayıt ol")
                         .foregroundColor(.blue)
                         .underline()
                 }
                 .font(.footnote)
             }
             
         }.padding(EdgeInsets(top: 0, leading: AppConstants.cornerRadious, bottom: 0, trailing: AppConstants.cornerRadious))
     }
 }

#Preview {
    LoginView(appRouter: AppRouter(), userSession: UserSession())
}
