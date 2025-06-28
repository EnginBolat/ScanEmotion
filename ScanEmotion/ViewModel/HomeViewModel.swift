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
    func classifyImage(_ uiImage: UIImage) async
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
        self.username = FirebaseService.shared.currentUser?.displayName ?? ""
        fetchDataFromFirebase()
    }
    
    private func fetchDataFromFirebase() {
        Task { [weak self] in
            
            guard let self = self else { return }

            let measurements: [Measurement]
            if let uid = FirebaseService.shared.currentUID {
                measurements = await FirebaseService.shared.getAllMeasurements(uid: uid)
            } else {
                measurements = []
            }

            await MainActor.run {
                self.data = measurements
            }
        }
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
    
    @MainActor
    func addMeasurementToFirestore(_ measurement: Measurement) async -> String {
            let currentUserSession = await FirebaseService.shared.checkUserSession()
            guard let currentUser = currentUserSession else { return "" }
            
            let addMeasurementResult = await FirebaseService.shared.addMeasurementToFirebase(
                uid: currentUser.uid!,
                measurement: measurement
            )
            if addMeasurementResult != "error" {
                return addMeasurementResult
            }
            else {
                return ""
            }
    }
    
    
    func classifyImageSync(_ uiImage: UIImage) {
        Task {
            await classifyImage(uiImage)
        }
    }
    
    @MainActor
    private func setAndUploadMeasurement(probabilities: Array<Float>, labels: Array<String>) {
        Task {
            if let maxIndex = probabilities.firstIndex(of: probabilities.max() ?? 0.0) {
                let dominantEmotion = labels[maxIndex]
                let dominantValue = probabilities[maxIndex]
                
                var newElement = Measurement(
                    angry: probabilities[0],
                    disgust: probabilities[1],
                    fear: probabilities[2],
                    happy: probabilities[3],
                    sad: probabilities[4],
                    surprised: probabilities[5],
                    spontaneity: probabilities[6],
                    mainEmotion: MainEmotion(name: dominantEmotion, value: dominantValue)
                )
                let documentId = await addMeasurementToFirestore(newElement)
                newElement.id = documentId
                data.append(newElement)
                
            } else {
                predictionText = "Baskın duygu tespit edilemedi."
            }
        }
    }
    
    @MainActor
    func classifyImage(_ uiImage: UIImage) async {
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
                
                let result = zip(AppConstants.emotions, probabilities)
                    .map { "\($0): \(String(format: "%.2f", $1 * 100))%" }
                    .joined(separator: "\n")

                predictionText = result
                setAndUploadMeasurement(probabilities: probabilities, labels: AppConstants.emotions)
            } catch {
                predictionText = "Tahmin yapılamadı: \(error.localizedDescription)"
            }
        }
}
