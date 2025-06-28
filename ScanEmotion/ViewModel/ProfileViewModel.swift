//
//  ProfileViewModel.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

protocol ProfileViewModelProtocol: ObservableObject {
    var name: String { get set }
    var surname: String { get set }
    var email: String { get set }
}

final class ProfileViewModel: ProfileViewModelProtocol {
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    
    private var userSession: UserSession
    private var appRoute: AppRouter
    
    init(userSession: UserSession, appRoute: AppRouter) {
        self.userSession = userSession
        self.appRoute = appRoute
        
        setupInputs()
    }
    
    private func setupInputs() {
        name = userSession.name
        surname = userSession.surname
        email = userSession.email
    }
    
    func signOut() {
        FirebaseService.shared.signOut() { result in
            switch result {
            case .success:
                AppStorageService.shared.resetAll()
                self.userSession.isLoggedIn = false
                self.appRoute.currentScreen = .login
                break
            case .failure(let error):
                break
            }
        }
    }
}
