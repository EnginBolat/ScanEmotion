//
//  LastMeasurementsMoreViewModel.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

protocol LastMeasurementsMoreViewModelProtocol: ObservableObject {
    var measurements: [Measurement] { get set }
    var selectedMeasurement: Measurement? { get set }
    var sheetHeight: CGFloat { get set }
    
    func getMeasurementsFromstorage()
}

final class LastMeasurementsMoreViewModel: LastMeasurementsMoreViewModelProtocol {
    @Published var measurements: [Measurement] = []
    @Published var selectedMeasurement: Measurement?
    @Published var sheetHeight: CGFloat = .zero
    
    init() {
        getMeasurementsFromstorage()
    }
    
    func onItemPress(to measurement:Measurement) {
        selectedMeasurement = measurement
    }
    
    func getMeasurementsFromstorage() {
        if let jsonString: String = AppStorageService.shared.value(forKey: .measurements) ?? "",
           let jsonData = jsonString.data(using: .utf8) {
            let storedMeasurements = try? JSONDecoder().decode([Measurement].self, from: jsonData)
            self.measurements = storedMeasurements ?? []
        } else {
            self.measurements = []
        }
    }
}
