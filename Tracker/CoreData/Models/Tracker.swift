//
//  Tracker.swift
//  Tracker
//
//  Created by Владимир Горбачев on 13.04.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let trackerType: TrackerTypes
    let color: String
    let emoji: String
    let pinned: Bool
    let schedule: [DaysOfWeek]

    init(name: String, trackerType: TrackerTypes, color: String, emoji: String, pinned: Bool, schedule: [DaysOfWeek]) {
        self.id = UUID().self
        self.name = name
        self.trackerType = trackerType
        self.color = color
        self.emoji = emoji
        self.pinned = pinned
        self.schedule = schedule
    }
    
    init(trackerCoreData: TrackerCoreData) {
        self.id = trackerCoreData.id ?? UUID().self
        self.name = trackerCoreData.name ?? ""
        self.trackerType = TrackerTypes(rawValue: Int(trackerCoreData.trackerType)) ?? .habit
        self.color = trackerCoreData.color ?? "7994F5"
        self.emoji = trackerCoreData.emoji ?? "🤔"
        self.pinned = trackerCoreData.pinned
        var tempSchedule: [DaysOfWeek] = []
        if let schedule = trackerCoreData.schedule {
            for item in schedule {
                if let scheduleCoreData = item as? ScheduleCoreData {
                    tempSchedule.append(DaysOfWeek(rawValue: Int(scheduleCoreData.dayOfWeek)) ?? .monday)
                }
            }
        }
        self.schedule = tempSchedule
    }
}

