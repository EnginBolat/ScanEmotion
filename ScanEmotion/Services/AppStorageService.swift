//
//  Untitled.swift
//  ScanEmotion
//
//  Created by Engin Bolat on 15.06.2025.
//

import SwiftUI

enum AppStorageKeys: String, CaseIterable {
    case isLoggedIn
    case name
    case surname
    case email
    case measurements
}

protocol AppStorageServiceProtocol {
    func set<T>(_ value: T, forKey key: AppStorageKeys)
    func value<T>(forKey key: AppStorageKeys) -> T?
}

public class AppStorageService: AppStorageServiceProtocol {
    static let shared = AppStorageService()
    private init() { }

    func set<T>(_ value: T, forKey key: AppStorageKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    func value<T>(forKey key: AppStorageKeys) -> T? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    func reset(forKey key: AppStorageKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    func resetAll() {
        for key in AppStorageKeys.allCases {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
}
