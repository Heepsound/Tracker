//
//  Tracker.swift
//  Tracker
//
//  Created by Владимир Горбачев on 13.04.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let trackerType: TrackerTypes
    let color: UIColor
    let emoji: String
    let schedule: [DaysOfWeek]
}

enum TrackerTypes {
    case habit
    case irregularEvent
}

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
}
