//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import CoreData

final class TrackerRecordStore {
    private var coreDataManager = CoreDataManager.shared
    
    func add(tracker: Tracker, date: Date) {
        let entity = TrackerRecordCoreData(context: coreDataManager.context)
 
        entity.date = date
    }
}

