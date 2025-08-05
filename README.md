# ScanEmotion

ScanEmotion is an AI-supported emotional diary app developed for iOS. Users write about their day or feelings, and the app analyzes the emotions behind the text using AI, then displays tailored feedback or supportive messages. Built entirely with UIKit and structured using the MVVM architectural pattern.

## ✨ Features

- Write your daily emotions and thoughts.
- Emotion analysis powered by AI.
- Personalized feedback based on the detected emotions.
- Smooth onboarding experience.
- Modular and scalable architecture (MVVM).
- Fully developed in UIKit (no SwiftUI).

## 🧠 Architecture

This app follows a clear MVVM pattern:

- `ViewController`s handle only UI and user interaction.
- `ViewModel`s handle validation, business logic, and data transfer.
- `Coordinator` manages navigation between onboarding and main app screens.

User data (name, email, password, goal, challenges) is stored in `UserDefaults` and passed across screens using delegate pattern.

## 🛠️ Technologies Used

- Swift (UIKit)
- MVVM Architecture
- UserDefaults
- Programmatic UI with AutoLayout
- Delegation pattern
- Local validation logic
- Prepared for AI API integration (e.g. OpenAI)

## 🚀 Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/EnginBolat/ScanEmotion.git
   ```

2. Open the project in Xcode:

   ```bash
   open ScanEmotion.xcodeproj
   ```

3. Run the project on a simulator or device.

> ⚠️ If you plan to integrate an AI backend, you can plug it into the `EmotionAnalyzer` class or wherever the ViewModel processes user input.

## 📄 License

This project is open-source and available under the MIT License.
