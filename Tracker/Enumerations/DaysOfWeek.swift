//
//  DaysOfWeek.swift
//  Tracker
//
//  Created by Владимир Горбачев on 07.05.2024.
//

import Foundation

enum DaysOfWeek: Int {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var name: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var shortName: String {
        switch self {
        case .monday: return "пн"
        case .tuesday: return "вт"
        case .wednesday: return "ср"
        case .thursday: return "чт"
        case .friday: return "пт"
        case .saturday: return "сб"
        case .sunday: return "вс"
        }
    }
    
    var dayNumber: Int {
        switch self {
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        case .sunday: return 7
        }
    }
    
    static func dayByNumber(_ num: Int) -> DaysOfWeek? {
        switch num {
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        case 1: return .sunday
        default: return nil
        }
    }
}

