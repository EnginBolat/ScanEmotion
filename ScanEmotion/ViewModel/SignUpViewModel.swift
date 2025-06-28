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
    func signUpSync() async -> Void
}

final class SignUpViewModel: SignUpViewModelProtocol {
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordSecured: Bool = true
    
     var appRouter: AppRouter

       init(appRouter: AppRouter) {
           self.appRouter = appRouter
       }

    
    func onSignUp() {
        Task {
            await signUpSync()
            self.appRouter.currentScreen = .home
        }
    }
    
    func signUpSync() async {
        let displayName = "\(name) \(surname)"
        
            await FirebaseService.shared.signUp(email: email, password: password, name: displayName) { result in
                switch result {
                case .success(let status):
                    if status {
                        guard let uid = FirebaseService.shared.currentUID else { return }
                        self.addUserToFirebase(uid)
                    }
                case .failure(let error):
                    print("Error signing up: \(error)")
                }
            }
    }
    
    func addUserToFirebase(_ uid: String) {
        Task {
            await FirebaseService.shared.addUserToFirebase(
                uid: uid,
                name: self.name,
                surname: self.surname,
                email: self.email
            )
        }
            
            AppStorageService.shared.set(self.name, forKey: .name)
            AppStorageService.shared.set(self.surname, forKey: .surname)
            AppStorageService.shared.set(self.email, forKey: .email)
            AppStorageService.shared.set(true, forKey: .isLoggedIn)
    }
    
    
    
    func isButtonDisabled() -> Bool {
        name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty
    }
}
