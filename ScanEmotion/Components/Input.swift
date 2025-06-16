//
//  Input.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct Input: View {
    
    var placeholder: String = "Placeholder"

    var LeftIcon: Image?
    var leftButtonPressed: (() -> Void)?

    var RightIcon: Image?
    var rightButtonPressed: (() -> Void)?
    
    var isSecure: Bool = false
    @Binding var isPasswordSecured: Bool
    @Binding var text: String
    
    var body: some View {
        
        HStack {
            if let LeftIcon = LeftIcon {
                PressableIcon(icon: LeftIcon, onPress: self.leftButtonPressed, isDisabled: self.leftButtonPressed == nil)
            }
            
            Group {
                if isSecure && isPasswordSecured {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .frame(height: 20)
            .textFieldStyle(.plain)
          
            if let RightIcon = RightIcon {
                PressableIcon(icon: RightIcon, onPress: self.rightButtonPressed, isDisabled: self.rightButtonPressed == nil)
            }
        }.padding()
            .background(
                RoundedRectangle(cornerRadius: AppConstants.cornerRadious).fill(Color(.systemGray6))
            )
    }
}


#Preview {
    Input(placeholder: "Preview",
          LeftIcon: Image(systemName: "lock"),
          leftButtonPressed: { },
          RightIcon: Image(systemName: "eye"),
          rightButtonPressed: { },
          isSecure: true,
          isPasswordSecured: .constant(true),
          text: .constant("Password"),
    ).padding(AppConstants.padding)
}
