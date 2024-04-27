//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Владимир Горбачев on 13.04.2024.
//

import Foundation

struct TrackerCategory {
    let name: String
    let trackers: [Tracker]
    
    init(name: String, trackers: [Tracker]) {
        self.name = name
        self.trackers = trackers
    }
}
