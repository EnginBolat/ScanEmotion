//
//  DetailsView.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct DetailsView: View {
    let measurement: Measurement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kızgın: \(measurement.angry)")
            Text("İğrenme: \(measurement.disgust)")
            Text("Korku: \(measurement.fear)")
            Text("Mutlu: \(measurement.happy)")
            Text("Üzgün: \(measurement.sad)")
            Text("Şaşırmışlık: \(measurement.spontaneity)")
            Text("Doğallık: \(measurement.surprised)")
            
            
        }.padding(AppConstants.padding)
    }
}

#Preview {
    DetailsView(measurement:  Measurement(
        angry: 1.0,
        disgust: 1.0,
        fear: 1.0,
        happy: 1.0,
        sad: 1.0,
        surprised: 1.0,
        spontaneity: 1.0,
        mainEmotion: MainEmotion(name: "Happy", value: 1.0)
    )
  )
}
