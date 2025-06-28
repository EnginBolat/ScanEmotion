//
//  LastMeasurementsView.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct HomeLastMeasurementsView: View {
    let data: [Measurement]
    let onItemPress: (Measurement) -> Void
    
    init(data: [Measurement], onItemPress: @escaping (Measurement) -> Void) {
        self.data = data
        self.onItemPress = onItemPress
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if data.isEmpty {
                Text("Hiç veri yok.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(EdgeInsets(top: 32, leading: 0, bottom: 32, trailing: 0))
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(data.prefix(10), id: \.id) { item in
                            measurementCard(for: item)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                }.scrollBounceBehavior(.basedOnSize)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadious)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func measurementCard(for item: Measurement) -> some View {
        var mainEmotionPercentageString: String {
            "\(item.mainEmotion): \(String(format: "%.2f", item.mainEmotion.value * 100))%"
        }
        
        MeasurementCard(item: item, onItemPress: onItemPress)
    }
}

#Preview {
    HomeLastMeasurementsView(
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
        onItemPress: { _ in }
    ).padding(AppConstants.padding)
}
