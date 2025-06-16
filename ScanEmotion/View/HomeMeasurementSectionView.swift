//
//  MeasurementSectionView.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct HomeMeasurementSectionView: View {
    let data: [Measurement]
    let onItemPress: (Measurement) -> Void
    
    var body: some View {
        HStack {
            Text("Son Ölçümler")
                .fontWeight(.regular)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
            
            if data.count > 5 {
                NavigationLink(destination: LastMeasurementsMoreView()) {
                    Text("Daha Fazla")
                        .fontWeight(.regular)
                        .font(.caption)
                        .foregroundStyle(.blue)
                        .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
                }
            }
            
        }
        HomeLastMeasurementsView(data: data,onItemPress: onItemPress)
    }
}

#Preview {
    HomeMeasurementSectionView(
        data: [
            Measurement(
                angry: 1.0,
                disgust: 1.0,
                fear: 1.0,
                happy: 1.0,
                sad: 1.0,
                surprised: 1.0,
                spontaneity: 1.0,
                mainEmotion: MainEmotion(name: "Happy", value: 1.0)
            )
        ],
        onItemPress: { measurement in print(measurement) }
    )
    .padding(AppConstants.padding)
}
