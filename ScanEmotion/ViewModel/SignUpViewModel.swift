//
//  SignUpViewModel.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

protocol SignUpViewModelProtocol: ObservableObject {
    var name: String { get set }
    var surname: String { get set }
    var email: String { get set }
    var password: String { get set }
    var isPasswordSecured: Bool { get set }
    
    func onSignUp() -> Void
    func isButtonDisabled() -> Bool
}

final class SignUpViewModel: SignUpViewModelProtocol {
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordSecured: Bool = true
    
    func onSignUp() {
        AppStorageService.shared.set(name, forKey: .name)
        AppStorageService.shared.set(surname, forKey: .surname)
        AppStorageService.shared.set(email, forKey: .email)
        
        AppStorageService.shared.set(true, forKey: .isLoggedIn)
    }
    
    func isButtonDisabled() -> Bool {
        name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty
    }
}
