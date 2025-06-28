import SwiftUI
import CoreML
import UIKit

struct ContentView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        switch router.currentScreen {
        case .login: NavigationStack { LoginView(appRouter: router, userSession: userSession) }
        case .home: NavigationStack { HomeView(viewModel: .init()) }
        }
    }
}

#Preview {
    ContentView().environmentObject(UserSession())
}
