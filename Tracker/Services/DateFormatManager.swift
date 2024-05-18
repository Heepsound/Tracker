//
//  DateFormatManager.swift
//  Tracker
//
//  Created by Владимир Горбачев on 18.05.2024.
//

import Foundation

final class DateFormatManager {
    static let shared = DateFormatManager()
    
    let weekDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = .current
        return formatter
    }()
    
    let weekDayShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEEE"
        formatter.locale = .current
        return formatter
    }()
    
    private init() { }
}
