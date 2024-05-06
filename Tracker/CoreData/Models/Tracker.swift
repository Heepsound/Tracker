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
    let color: String
    let emoji: String
    let schedule: [DaysOfWeek]

    init(name: String, trackerType: TrackerTypes, color: String, emoji: String, schedule: [DaysOfWeek]) {
        self.id = UUID().self
        self.name = name
        self.trackerType = trackerType
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
    
    init(trackerCoreData: TrackerCoreData) {
        self.id = trackerCoreData.id ?? UUID().self
        self.name = trackerCoreData.name ?? ""
        self.trackerType = TrackerTypes(rawValue: Int(trackerCoreData.trackerType)) ?? .habit
        self.color = trackerCoreData.color ?? "7994F5"
        self.emoji = trackerCoreData.emoji ?? "🤔"
        var tempSchedule: [DaysOfWeek] = []
        if let schedule = trackerCoreData.schedule {
            for item in schedule {
                if let scheduleCoreData = item as? ScheduleCoreData {
                    tempSchedule.append(DaysOfWeek(rawValue: Int(scheduleCoreData.dayOfWeek)) ?? .monday)
                }
            }
        }
        self.schedule = tempSchedule
    }
}

enum TrackerTypes: Int {
    case habit = 1, irregularEvent
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
