//
//  LoginViewModel.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI


protocol LoginViewModelProtocol: ObservableObject {
    var savedEmail: String { get set }
    var isLoggedIn: Bool { get set }
    
    var email: String { get set }
    var password: String { get set }
    var isPasswordSecured: Bool { get set }
    var emailError: String? { get set }
    
    func isValidEmail() -> Bool
    func validateEmail() -> Bool
    
    func signIn() -> Void
    func updateButtonState()
}


final class LoginViewModel: LoginViewModelProtocol {
    @AppStorage("email") var savedEmail = ""
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordSecured: Bool = true
    @Published var emailError: String?
    @Published var isButtonDisabled: Bool = true
    
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
            savedEmail = email
            isLoggedIn = true
        }
    }
    
    func updateButtonState() {
        isButtonDisabled = email.isEmpty || password.isEmpty || !isValidEmail()
    }
}
