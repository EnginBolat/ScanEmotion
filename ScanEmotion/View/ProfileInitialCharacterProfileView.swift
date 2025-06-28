//
//  ProfileInitialCharacterProfileView.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct ProfileInitialCharacterProfileView: View {
    let nameFirstKey: String
    let surnameFirstKey: String
    let photoUrl: String?
    
    var body: some View {
        VStack {
            if photoUrl?.isEmpty ?? true {
                HStack(spacing: 0) {
                    Text(nameFirstKey)
                        .font(.largeTitle)
                        .bold()
                    Text(surnameFirstKey)
                        .font(.largeTitle)
                        .bold()
                }
            } else {
                if let urlString = photoUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url)
                }
                    
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: .infinity)
                .foregroundStyle(Color.gray.opacity(0.2))
        )
    }
}


#Preview {
    ProfileInitialCharacterProfileView(nameFirstKey: "E", surnameFirstKey: "B", photoUrl: "")
}
