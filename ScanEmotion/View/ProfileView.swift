//
//  ProfileView.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            ProfileInitialCharacterProfileView( nameFirstKey: String(viewModel.name.prefix(1)), surnameFirstKey: String(viewModel.surname.prefix(1)))
            VStack(alignment: .leading) {
                Text("Ad")
                Input(isPasswordSecured: .constant(false), text: $viewModel.name)
                Text("Soyad")
                Input(isPasswordSecured: .constant(false), text: $viewModel.surname)
                Text("Email")
                Input(isPasswordSecured: .constant(false), text: $viewModel.email)
                
                Spacer()
                
                VStack {
                    Button("Çıkış Yap") { viewModel.signOut() }.tint(Color.red)
                }
                .frame(maxWidth: .infinity)
            }.padding(AppConstants.padding)
        }
    }
}


#Preview {
    ProfileView()
}

