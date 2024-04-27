//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import CoreData

final class TrackerCategoryStore {
    private var coreDataManager = CoreDataManager.shared
    
    func add(_ trackerCategory: TrackerCategory) {
        let entity = TrackerCategoryCoreData(context: coreDataManager.context)
        entity.id = trackerCategory.id
        entity.name = trackerCategory.name
        coreDataManager.saveContext()
    }
}

