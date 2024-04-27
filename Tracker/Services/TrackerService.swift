//
//  TrackerService.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import UIKit

protocol TrackerServiceNewTrackerDelegate: AnyObject {
    func newTrackerDataChanged(_ allDataEntered: Bool)
}

protocol TrackerServiceNewCategoryDelegate: AnyObject {
    func newCategoryDataChanged(_ allDataEntered: Bool)
}

final class TrackerService {
    static let shared = TrackerService()
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var records: [TrackerRecord] = []
    
    private(set) var trackersDate: Date = Date()
    
    var newTrackerDelegate: TrackerServiceNewTrackerDelegate?
    var newCategoryDelegate: TrackerServiceNewCategoryDelegate?
    
    var newTrackerName: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerType: TrackerTypes? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerColor: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerEmoji: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerCategory: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerSchedule: [DaysOfWeek] = [] {
        didSet {
            checkNewTrackerData()
        }
    }
    
    var newCategoryName: String? {
        didSet {
            checkNewCategoryData()
        }
    }
    
    // MARK: - Lifecycle
    
    private init() {}
    
    func checkNewTrackerData() {
        guard let newTrackerType, let newTrackerName, let _ = newTrackerEmoji, let _ = newTrackerColor, let _ = newTrackerCategory else {
            newTrackerDelegate?.newTrackerDataChanged(false)
            return
        }
        newTrackerDelegate?.newTrackerDataChanged(!(newTrackerName.isEmpty || (newTrackerType == .habit && newTrackerSchedule.isEmpty)))
    }
    
    func checkNewCategoryData() {
        guard let newCategoryName else {
            newCategoryDelegate?.newCategoryDataChanged(false)
            return
        }
        newCategoryDelegate?.newCategoryDataChanged(!newCategoryName.isEmpty)
    }
    
    func clearNewTracker() {
        newTrackerName = nil
        newTrackerType = nil
        newTrackerColor = nil
        newTrackerEmoji = nil
        newTrackerCategory = nil
        newTrackerSchedule = []
    }
    
    func clearNewCategory() {
        newCategoryName = nil
    }
    
    func addNewCategory() {
        categories.append(TrackerCategory(name: newCategoryName ?? "", trackers: []))
        clearNewCategory()
    }
    
    func addNewTracker() {
        let tracker = Tracker(name: newTrackerName ?? "",
                              trackerType: newTrackerType ?? .irregularEvent,
                              color: newTrackerColor ?? "7994F5",
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

