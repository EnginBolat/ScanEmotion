//
//  UserSession.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 16.06.2025.
//

import Foundation

class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var email: String = ""
    @Published var image: String = ""
    
    func login(name: String, surname: String, email: String, image: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.image = image
        self.isLoggedIn = true
    }
    
    func logout() {
        self.name = ""
        self.surname = ""
        self.email = ""
        self.image = ""
        self.isLoggedIn = false
    }
}
