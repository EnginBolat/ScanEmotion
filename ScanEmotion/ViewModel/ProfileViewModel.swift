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
    @Published var name: String = AppStorageService.shared.value(forKey: .name) ?? ""
    @Published var surname: String = AppStorageService.shared.value(forKey: .surname) ?? ""
    @Published var email: String = AppStorageService.shared.value(forKey: .email) ?? ""
    
    func signOut() {
        AppStorageService.shared.resetAll()
    }
}
