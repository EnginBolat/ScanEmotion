//
//  OptionsSheetBody.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct HomeOptionsSheetBody: View {
    var photoOnPress: () -> Void
    var galleryOnPress: () -> Void
    
    
    var body: some View {
        VStack {
            Text("İşlem Seç")
                .bold()
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top,24)
            
            Divider()
            
            VStack {
                ButtonWithLabel(label: "Fotoğraf Çek", onPress: { photoOnPress() }, isButtonDisabled: false)
                ButtonWithLabel(label: "Galeriden Seç", onPress: { galleryOnPress() }, isButtonDisabled: false)
            }.padding(AppConstants.padding)
        }
    }
}

#Preview {
    HomeOptionsSheetBody(
        photoOnPress: {},
        galleryOnPress: {}
    )
}
