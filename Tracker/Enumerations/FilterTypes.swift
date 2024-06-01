//
//  FilterTypes.swift
//  Tracker
//
//  Created by Владимир Горбачев on 25.05.2024.
//

import Foundation

enum FilterTypes: Int {
    case all = 0, forToday, completed, notCompleted
    
    var name: String {
        switch self {
        case .all: return "Все трекеры"
        case .forToday: return "Трекеры на сегодня"
        case .completed: return "Завершенные"
        case .notCompleted: return "Не завершенные"
        }
    }
}
