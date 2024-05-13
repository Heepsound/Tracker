//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Владимир Горбачев on 11.05.2024.
//

import Foundation

struct UserDefaultsService {
    private enum Keys: String {
        case onboardingCompleted
    }
    
    static var onboardingCompleted: Bool {
        get {
            return UserDefaults().bool(forKey: Keys.onboardingCompleted.rawValue)
        }
        set {
            UserDefaults().set(newValue, forKey: Keys.onboardingCompleted.rawValue)
        }
    }
}
