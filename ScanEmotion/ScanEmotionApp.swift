//
//  ScanEmotionApp.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 14.06.2025.
//

import SwiftUI
import FirebaseCore

@main
struct ScanEmotionApp: App {
    @StateObject private var appRouter = AppRouter()
    @StateObject private var userSession = UserSession()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appRouter)
                .environmentObject(userSession)
        }
    }
}
