//
//  FirebaseUser.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 16.06.2025.
//

import Foundation
import FirebaseAuth

struct FirebaseUser {
    let uid: String?
    let displayName: String?
    let email: String?
    let phoneNumber: String?
    let photoURL: URL?

    init(user: User) {
        self.uid = user.uid
        self.displayName = user.displayName
        self.email = user.email
        self.phoneNumber = user.phoneNumber
        self.photoURL = user.photoURL
    }
}
