//
//  AppRouter.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 21.06.2025.
//

import SwiftUI

class AppRouter: ObservableObject {
    enum Screen {
        case login
        case home
    }
    
    @Published var currentScreen: Screen = .login
}
