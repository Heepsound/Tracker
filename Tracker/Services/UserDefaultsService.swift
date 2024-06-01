//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Владимир Горбачев on 11.05.2024.
//

import Foundation

struct UserDefaultsService {
    private enum Keys: String {
        case onboardingCompleted, currentTrackerFilter
    }
    
    static var onboardingCompleted: Bool {
        get {
            return UserDefaults().bool(forKey: Keys.onboardingCompleted.rawValue)
        }
        set {
            UserDefaults().set(newValue, forKey: Keys.onboardingCompleted.rawValue)
        }
    }
    
    static var currentTrackerFilter: Int {
        get {
            return UserDefaults().integer(forKey: Keys.currentTrackerFilter.rawValue)
        }
        set {
            UserDefaults().set(newValue, forKey: Keys.currentTrackerFilter.rawValue)
        }
    }
}
