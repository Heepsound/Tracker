//
//  TrackerService.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

final class TrackerService {
    static let shared = TrackerService()
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var records: [TrackerRecord] = []
    
    private(set) var trackersDate: Date = Date()
    
    static let didChangeNotification = Notification.Name(rawValue: "TrackerServiceDidChange")
    
    var newTrackerName: String?
    var newTrackerType: TrackerTypes?
    var newTrackerColor: UIColor?
    var newTrackerEmoji: String?
    var newTrackerCategory: String?
    var newTrackerSchedule: [DaysOfWeek] = []
    
    // MARK: - Lifecycle
    
    private init() {
        /*let tracker = Tracker(name: "Кошка заслонила камеру на созвоне",
                              trackerType: .habit,
                              color: .trackerPink,
                              emoji: "😻",
                              schedule: [.monday,.tuesday, .wednesday])
        let tracker2 = Tracker(name: "Уборка дома",
                              trackerType: .habit,
                              color: .trackerPink,
                              emoji: "🌺",
                               schedule: [.thursday, .friday])
        categories.append(TrackerCategory(name: "Домашний уют", trackers: [tracker, tracker2]))
        
        let tracker3 = Tracker(name: "День рождения",
                               trackerType: .irregularEvent,
                               color: .trackerBlue,
                               emoji: "🌺",
                               schedule: newTrackerSchedule)
        categories.append(TrackerCategory(name: "Радостные мелочи", trackers: [tracker3]))*/
        
        categories.append(TrackerCategory(name: "Домашний уют", trackers: []))
        categories.append(TrackerCategory(name: "Радостные мелочи", trackers: []))
    }
    
    func clearNewTracker() {
        newTrackerName = nil
        newTrackerType = nil
        newTrackerColor = nil
        newTrackerEmoji = nil
        newTrackerCategory = nil
        newTrackerSchedule = []
    }
    
    func addNewTracker() {
        let tracker = Tracker(name: newTrackerName ?? "",
                              trackerType: newTrackerType ?? .irregularEvent,
                              color: newTrackerColor ?? .trackerColdBlue,
                              emoji: newTrackerEmoji ?? "🤔",
                              schedule: newTrackerSchedule)
        if let index = categories.firstIndex(where: {$0.name == newTrackerCategory}) {
            var trackers = categories[index].trackers
            trackers.append(tracker)
            categories[index] = TrackerCategory(name: newTrackerCategory ?? "", trackers: trackers)
        }
        clearNewTracker()
    }
    
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
        NotificationCenter.default.post(name: TrackerService.didChangeNotification, object: self)
        return categoriesOnDate
    }
    
    func setDone(id: String) {
        records.append(TrackerRecord(id: id, date: trackersDate))
    }
    
    func setUndone(id: String) {
        records.removeAll(where: {$0.id == id && $0.date == trackersDate})
    }
    
    func doneCount(id: String) -> Int {
        return records.filter({$0.id == id}).count
    }
    
    func doneDate(id: String) -> Date? {
        if let index = records.firstIndex(where: {$0.id == id}) {
            return records[index].date
        } else {
            return nil
        }
    }
    
    func isDone(id: String) -> Bool {
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

