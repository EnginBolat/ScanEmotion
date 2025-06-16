//
//  LastMeasurementsMoreView.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct LastMeasurementsMoreView: View {
   @StateObject var viewModel = LastMeasurementsMoreViewModel()
    
    var body: some View {
        ScrollView() {
            ForEach(viewModel.measurements) { item in
                MeasurementCard(item: item, onItemPress: viewModel.onItemPress)
            }
        }.padding(20)
        .sheet(item: $viewModel.selectedMeasurement) { item in
            DetailsView(measurement: item)
                .modifier(GetHeightModifier(height: $viewModel.sheetHeight))
                .presentationDetents([.height(viewModel.sheetHeight)])
        }
    }
}
