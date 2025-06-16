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
    
    var body: some View {
        HStack(spacing: 0) {
            Text(nameFirstKey)
                .font(.largeTitle)
                .bold()
            Text(surnameFirstKey)
                .font(.largeTitle)
                .bold()
        }.padding(24)
            .background(
                RoundedRectangle(cornerRadius: .infinity)
                    .foregroundStyle(Color.gray.opacity(0.2))
            )
    }
}


#Preview {
    ProfileInitialCharacterProfileView(nameFirstKey: "E", surnameFirstKey: "B")
}
