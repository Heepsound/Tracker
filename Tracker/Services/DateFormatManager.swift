//
//  DateFormatManager.swift
//  Tracker
//
//  Created by Владимир Горбачев on 06.04.2024.
//

import Foundation

final class DateFormatManager {
    static let shared = DateFormatManager()
    
    private let trackersDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private init() { }
    
    func trackersDateToString(_ date: Date) -> String {
        return trackersDateFormatter.string(from: date)
    }
}

