//
//  ScheduleViewModel.swift
//  Tracker
//
//  Created by Владимир Горбачев on 29.05.2024.
//

import Foundation

final class ScheduleViewModel {
    private let daysOfWeek: [DaysOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func model(at indexPath: IndexPath) -> DaysOfWeek {
        return daysOfWeek[indexPath.row]
    }
}

