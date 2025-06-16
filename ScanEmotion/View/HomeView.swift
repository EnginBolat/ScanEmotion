//
//  HomeView.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack() {
            HomeHeaderView(title: viewModel.greetingText())
            HomeMeasurementSectionView(data: viewModel.data,onItemPress: viewModel.onItemPress)
            ButtonWithLabel(label: "Ölçüm Yap",
                            onPress: { viewModel.updateSheetType(key: .optionSelection) },
                            isButtonDisabled: false,
                            leftImage: Image(systemName: "camera")
            )
        }
        .padding(AppConstants.padding)
        .sheet(item: $viewModel.selectedSheet) { item in
            switch item {
            case .optionSelection:
                HomeOptionsSheetBody(
                    photoOnPress: { viewModel.updateSheetType(key: .camera) },
                    galleryOnPress: { viewModel.updateSheetType(key: .gallery) }
                )
                .modifier(GetHeightModifier(height: $viewModel.sheetHeight))
                .presentationDetents([.height(viewModel.sheetHeight)])
            case .camera:
                ImagePicker(
                    image: $viewModel.image,
                    sourceType: .camera,
                    onImagePicked: viewModel.classifyImage
                ).ignoresSafeArea()
            case .gallery:
                ImagePicker(
                    image: $viewModel.image,
                    sourceType: .photoLibrary,
                    onImagePicked: viewModel.classifyImage
                ).ignoresSafeArea()
            case .details:
                DetailsView(measurement: viewModel.selectedMeasurement!)
                    .modifier(GetHeightModifier(height: $viewModel.sheetHeight))
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.height(viewModel.sheetHeight)])
                    .padding(.top, AppConstants.padding)
            }
        }
        
    }
}

#Preview {
    HomeView()
}
