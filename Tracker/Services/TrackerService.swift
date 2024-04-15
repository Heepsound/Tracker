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
    
    var newTrackerName: String?
    var newTrackerType: TrackerTypes?
    var newTrackerColor: UIColor?
    var newTrackerEmoji: String?
    var newTrackerCategory: String?
    var newTrackerSchedule: [DaysOfWeek] = []
    
    // MARK: - Lifecycle
    
    private init() {
        let tracker = Tracker(name: "Кошка заслонила камеру на созвоне",
                              trackerType: .habit,
                              color: .trackerPink,
                              emoji: "😻",
                              schedule: newTrackerSchedule)
        let tracker2 = Tracker(name: "Уборка дома",
                              trackerType: .habit,
                              color: .trackerPink,
                              emoji: "🌺",
                              schedule: newTrackerSchedule)
        categories.append(TrackerCategory(name: "Домашний уют", trackers: [tracker, tracker2]))
        
        let tracker3 = Tracker(name: "День рождения",
                               trackerType: .irregularEvent,
                               color: .trackerBlue,
                               emoji: "🌺",
                               schedule: newTrackerSchedule)
        categories.append(TrackerCategory(name: "Радостные мелочи", trackers: [tracker3]))
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
                              color: newTrackerColor ?? UIColor(),
                              emoji: newTrackerEmoji ?? "",
                              schedule: newTrackerSchedule)
        if let index = categories.firstIndex(where: {$0.name == newTrackerCategory}) {
            var trackers = categories[index].trackers
            trackers.append(tracker)
            categories[index] = TrackerCategory(name: newTrackerCategory ?? "", trackers: trackers)
        }
        clearNewTracker()
    }
}
