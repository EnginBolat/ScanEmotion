//
//  MeasurementCard.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct MeasurementCard: View {
    let item: Measurement
    let onItemPress: (Measurement) -> Void
    
    init(item: Measurement, onItemPress: @escaping (Measurement) -> Void) {
        self.item = item
        self.onItemPress = onItemPress
    }
    
    var body: some View {
        Button(action: { onItemPress(item) }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.mainEmotion.name)
                        .font(.headline)
                    Text("\(String(format: "%.2f", item.mainEmotion.value * 100))%")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(item.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.gray.opacity(0.8))
                    .padding(.leading, 8)
                
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadious)
                .foregroundStyle(Color.gray.opacity(0.1))
        )
    }
}

