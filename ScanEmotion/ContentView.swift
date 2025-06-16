import SwiftUI
import CoreML
import UIKit

struct ContentView: View {
     @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            if isLoggedIn {
                HomeView()
            }
            else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
