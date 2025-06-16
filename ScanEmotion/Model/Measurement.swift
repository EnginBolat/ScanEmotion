//
//  Measurement.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import Foundation

struct MainEmotion: Codable {
    let name:String
    let value:Float
}

struct Measurement: Identifiable, Codable {
    let id: UUID
    let mainEmotion: MainEmotion
    let angry: Float
    let disgust: Float
    let fear: Float
    let happy: Float
    let sad: Float
    let surprised: Float
    let spontaneity: Float
    var date: Date = Date()

    init(
        id: UUID = UUID(),
        angry: Float,
        disgust: Float,
        fear: Float,
        happy: Float,
        sad: Float,
        surprised: Float,
        spontaneity: Float,
        mainEmotion: MainEmotion
    ) {
        self.id = id
        self.angry = angry
        self.disgust = disgust
        self.fear = fear
        self.happy = happy
        self.sad = sad
        self.surprised = surprised
        self.spontaneity = spontaneity
        self.mainEmotion = mainEmotion
    }
}
