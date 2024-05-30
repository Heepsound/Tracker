//
//  DaysOfWeek.swift
//  Tracker
//
//  Created by Владимир Горбачев on 07.05.2024.
//

import Foundation

enum DaysOfWeek: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    var name: String {
        let result = DateFormatManager.shared.weekDay.string(from: self.defaultDate())
        return result.prefix(1).uppercased() + result.lowercased().dropFirst()
    }
    
    var shortName: String {
        return DateFormatManager.shared.weekDayShort.string(from: self.defaultDate()).lowercased()
    }
    
    var sortNumber: Int {
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

