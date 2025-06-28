//
//  LoginViewModel.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI


protocol LoginViewModelProtocol: ObservableObject {
    var password: String { get set }
    var isPasswordSecured: Bool { get set }
    var emailError: String? { get set }
    
    func isValidEmail() -> Bool
    func validateEmail() -> Bool
    
    func signIn() -> Void
    func updateButtonState()
}

final class LoginViewModel: LoginViewModelProtocol {
    @Published var email = "engi.bolat@gmail.com"
    @Published var password: String = "123456"
    @Published var isPasswordSecured: Bool = true
    @Published var emailError: String?
    @Published var isButtonDisabled: Bool = true
    
    private var appRouter: AppRouter
    private var userSession: UserSession
    
    init(appRouter: AppRouter, userSession: UserSession) {
        self.appRouter = appRouter
        self.userSession = userSession
    }
    
    func isValidEmail() -> Bool {
        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com$"
        return NSPredicate(format: "SELF MATCHES %@", emailPattern).evaluate(with: email)
    }
    
    func validateEmail() -> Bool {
        if isValidEmail() {
            emailError = nil
            return true
        }
        else {
            emailError = "Lütfen geçerli bir e-mail adresi giriniz"
            return false
        }
    }
    
    //MARK: In Page Logic
    
    func signIn() {
        let status = validateEmail()
        if status {
            signInRegularAsync()
        }
    }
    
    func updateButtonState() {
        isButtonDisabled = email.isEmpty || password.isEmpty || !isValidEmail()
    }
    
    func signInRegularAsync() {
        Task {
            await FirebaseService.shared.signIn(email: email, password: password) { result in
                switch result {
                case .success(let user):
                    self.userSession.login(
                            name: user.displayName ?? "",
                            surname: "",
                            email: user.email ?? "",
                            image: user.photoURL?.absoluteString ?? ""
                    )
                    self.appRouter.currentScreen = .home
                    return
                case .failure(let error):
                    self.emailError = error.localizedDescription
                    return
                }
            }
        }
    }
}
