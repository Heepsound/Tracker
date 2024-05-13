//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Владимир Горбачев on 13.04.2024.
//

import Foundation

struct TrackerCategory  {
    let id: UUID
    let name: String
    let trackers: [Tracker]
    
    init(name: String, trackers: [Tracker]) {
        self.id = UUID().self
        self.name = name
        self.trackers = trackers
    }
    
    init(trackerCategoryCoreData: TrackerCategoryCoreData) {
        self.id = trackerCategoryCoreData.id ?? UUID().self
        self.name = trackerCategoryCoreData.name ?? ""
        var tempTrackers: [Tracker] = []
        if let trackers = trackerCategoryCoreData.trackers {
            for item in trackers {
                if let tracker = item as? TrackerCoreData {
                    tempTrackers.append(Tracker(trackerCoreData: tracker))
                }
            }
        }
        self.trackers = tempTrackers
    }
}
