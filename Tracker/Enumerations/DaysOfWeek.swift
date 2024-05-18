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
        let result = DateFormatManager.shared.weekDay.string(from: self.defaultDate())
        return result.prefix(1).uppercased() + result.lowercased().dropFirst()
    }
    
    var shortName: String {
        return DateFormatManager.shared.weekDayShort.string(from: self.defaultDate()).lowercased()
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
    
    private func defaultDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 4
        switch self {
        case .monday: dateComponents.day = 1
        case .tuesday: dateComponents.day = 2
        case .wednesday: dateComponents.day = 3
        case .thursday: dateComponents.day = 4
        case .friday: dateComponents.day = 5
        case .saturday: dateComponents.day = 6
        case .sunday: dateComponents.day = 7
        }
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: dateComponents) ?? Date()
    }
}

