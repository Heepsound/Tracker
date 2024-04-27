//
//  TrackerStore.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import CoreData

final class TrackerStore {
    private var coreDataManager = CoreDataManager.shared
    
    func add(_ tracker: Tracker) {
        let entity = TrackerCoreData(context: coreDataManager.context)
        entity.id = tracker.id
        entity.name = tracker.name
        entity.trackerType = Int16(tracker.trackerType.rawValue)
        entity.color = tracker.color
        entity.emoji = tracker.emoji
        for shedule in tracker.schedule {
            let scheduleEntity = ScheduleCoreData(context: coreDataManager.context)
            scheduleEntity.dayOfWeek = Int16(shedule.rawValue)
            scheduleEntity.tracker = entity
        }
        coreDataManager.saveContext()
    }
}
