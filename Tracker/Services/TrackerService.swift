//
//  TrackerService.swift
//  Tracker
//
//  Created by Владимир Горбачев on 14.04.2024.
//

import Foundation

final class TrackerService {
    static let shared = TrackerService()
    private(set) var trackerCategories: [TrackerCategory] = []
    private(set) var trackerRecords: [TrackerRecord] = []
    
    var newTrackerType: TrackerTypes?
    var newTrackerName: String?
    var newTrackerCategory: TrackerCategory?
    var newTrackerSchedule: [DaysOfWeek] = []
    
    private init() { }
    
    func clearNewTrackerData() {
        newTrackerType = nil
        newTrackerName = nil
        newTrackerCategory = nil
        newTrackerSchedule = []
    }
}
