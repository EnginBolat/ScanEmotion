//
//  LastMeasurementsMoreViewModel.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

protocol LastMeasurementsMoreViewModelProtocol: ObservableObject {
    var selectedMeasurement: Measurement? { get set }
    var sheetHeight: CGFloat { get set }
    
    func onItemPress(to measurement:Measurement) 
}

final class LastMeasurementsMoreViewModel: LastMeasurementsMoreViewModelProtocol {
    @Published var selectedMeasurement: Measurement?
    @Published var sheetHeight: CGFloat = .zero
    
    func onItemPress(to measurement:Measurement) {
        selectedMeasurement = measurement
    }
}
