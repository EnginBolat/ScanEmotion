//
//  HomeViewModel.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

enum SheetType: Identifiable {
    case optionSelection, camera, gallery, details
    var id: Int { hashValue }
}

protocol HomeViewModelProtocol: ObservableObject {
    var username: String { get set }
    var data: [Measurement] { get set }
    var isSelectionSheetOpen: Bool { get set }
    var sheetHeight: CGFloat { get set }
    var selectedSheet: SheetType? { get set }
    
    func greetingText() -> String
    func onMeasureButtonPress() -> Void
    func classifyImage(_ uiImage: UIImage)
}

final class HomeViewModel: HomeViewModelProtocol {
    var username: String
    
    @Published var data: [Measurement] = []
    @Published var isSelectionSheetOpen: Bool = false
    @Published var sheetHeight: CGFloat = .zero
    
    @Published var selectedSheet: SheetType?
    @Published var selectedMeasurement: Measurement?
    
    @Published var image: UIImage?
    @Published var predictionText: String = ""
    
    init() {
        
        if let jsonString: String = AppStorageService.shared.value(forKey: .measurements) ?? "",
           let jsonData = jsonString.data(using: .utf8) {
            let storedMeasurements = try? JSONDecoder().decode([Measurement].self, from: jsonData)
            self.data = storedMeasurements ?? []
        } else {
            self.data = []
        }
        self.username = AppStorageService.shared.value(forKey: .name) ?? ""
        
    }
    
    func greetingText() -> String {
        if username.isEmpty { return "Hoşgeldin!" }
        return "Hoşgeldin, \(username)!"
    }
    
    func onMeasureButtonPress() {
        isSelectionSheetOpen = true
    }
    
    func updateSheetType(key sheetType: SheetType) {
        selectedSheet = sheetType
    }
    
    func onItemPress(to measurement:Measurement) {
        selectedMeasurement = measurement
        selectedSheet = .details
    }
    
    func classifyImage(_ uiImage: UIImage) {
        guard let inputArray = imageToMultiArray(image: uiImage) else {
            predictionText = "Görüntü dönüştürülemedi."
            return
        }

        do {
            let model = try EmotionModel()
            let prediction = try model.prediction(inputs: inputArray)
            let raw = prediction.Identity
            let logits = (0..<raw.count).map { raw[$0].floatValue }
            let expValues = logits.map { exp($0) }
            let sumExp = expValues.reduce(0, +)
            let probabilities = expValues.map { $0 / sumExp }

            let labels = ["Kızgın", "İğrenme", "Korku", "Mutlu", "Üzgün", "Şaşırmışlık", "Doğallık"]
            let result = zip(labels, probabilities)
                .map { "\($0): \(String(format: "%.2f", $1 * 100))%" }
                .joined(separator: "\n")

            predictionText = result
            
            if let maxIndex = probabilities.firstIndex(of: probabilities.max() ?? 0.0) {
                       let dominantEmotion = labels[maxIndex]
                        let dominantValue = probabilities[maxIndex]
                       
                       let newElement = Measurement(
                           angry: probabilities[0],
                           disgust: probabilities[1],
                           fear: probabilities[2],
                           happy: probabilities[3],
                           sad: probabilities[4],
                           surprised: probabilities[5],
                           spontaneity: probabilities[6],
                           mainEmotion: MainEmotion(name: dominantEmotion, value: dominantValue)
                       )

                       data.append(newElement)
                
                // Veriyi LocalStorage'a kaydet
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(data),
                   let encodedString = String(data: encodedData, encoding: .utf8) {
                    AppStorageService.shared.set(encodedString, forKey: .measurements)
                }
                
                
                
            } else {
                predictionText = "Baskın duygu tespit edilemedi."
            }
            
        } catch {
            predictionText = "Tahmin yapılamadı: \(error.localizedDescription)"
        }
    }
}
