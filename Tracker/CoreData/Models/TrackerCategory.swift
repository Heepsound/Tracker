//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Владимир Горбачев on 13.04.2024.
//

import Foundation

struct TrackerCategory: DataRecord  {
    let id: UUID
    let name: String
    let trackers: [Tracker]
    
    init(name: String, trackers: [Tracker]) {
        self.id = UUID().self
        self.name = name
        self.trackers = trackers
    }
}
