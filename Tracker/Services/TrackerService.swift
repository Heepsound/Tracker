//
//  TrackerService.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

final class TrackerService {
    static let shared = TrackerService()
    
    var categories: [TrackerCategory] = []
    private(set) var records: [TrackerRecord] = []
    
    private(set) var trackersDate: Date = Date()
    
    private var coreDataManager = CoreDataManager.shared
    
    // MARK: - Lifecycle
    
    private init() {}
    
    func getTrackers(onDate: Date) -> [TrackerCategory] {
        let calendar = Calendar.current
        trackersDate = calendar.startOfDay(for: onDate)
        let dayOfWeek = DaysOfWeek.dayByNumber(calendar.component(.weekday, from: trackersDate))
        var categoriesOnDate: [TrackerCategory]  = []
        var trackersOnDate: [Tracker] = []
        for category in categories {
            trackersOnDate = []
            for tracker in category.trackers {
                if tracker.trackerType == .irregularEvent {
                    if let date = doneDate(id: tracker.id) {
                        if date == trackersDate {
                            trackersOnDate.append(tracker)
                        }
                    } else {
                        trackersOnDate.append(tracker)
                    }
                } else {
                    if let dayOfWeek, let _ = tracker.schedule.firstIndex(of: dayOfWeek) {
                        trackersOnDate.append(tracker)
                    }
                }
            }
            if !trackersOnDate.isEmpty {
                categoriesOnDate.append(TrackerCategory(name: category.name, trackers: trackersOnDate))
            }
        }
        return categoriesOnDate
    }
    
    func setDone(id: UUID) {
        records.append(TrackerRecord(id: id, date: trackersDate))
    }
    
    func setUndone(id: UUID) {
        records.removeAll(where: {$0.id == id && $0.date == trackersDate})
    }
    
    func doneCount(id: UUID) -> Int {
        return records.filter({$0.id == id}).count
    }
    
    func doneDate(id: UUID) -> Date? {
        if let index = records.firstIndex(where: {$0.id == id}) {
            return records[index].date
        } else {
            return nil
        }
    }
    
    func isDone(id: UUID) -> Bool {
        if let _ = records.firstIndex(where: {$0.id == id && $0.date == trackersDate}) {
            return true
        } else {
            return false
        }
    }
    
    func canChangeStatus() -> Bool {
        return trackersDate <= Calendar.current.startOfDay(for: Date())
    }
}

