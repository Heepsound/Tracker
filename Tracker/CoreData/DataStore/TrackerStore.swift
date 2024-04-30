//
//  TrackerStore.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import CoreData

final class TrackerStore: NSObject {
    private var coreDataManager = CoreDataManager.shared
    
    weak var delegate: DataStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> TrackerCoreData? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func add(_ tracker: Tracker) {
        let object = TrackerCoreData(context: coreDataManager.context)
        object.id = tracker.id
        object.name = tracker.name
        object.trackerType = Int16(tracker.trackerType.rawValue)
        object.color = tracker.color
        object.emoji = tracker.emoji
        if tracker.schedule.isEmpty {
            let scheduleEntity = ScheduleCoreData(context: coreDataManager.context)
            scheduleEntity.tracker = object
        } else {
            for shedule in tracker.schedule {
                let scheduleEntity = ScheduleCoreData(context: coreDataManager.context)
                scheduleEntity.dayOfWeek = Int16(shedule.rawValue)
                scheduleEntity.tracker = object
            }
        }
        coreDataManager.saveContext()
    }
    
    func delete(at indexPath: IndexPath) {
        let record = fetchedResultsController.object(at: indexPath)
        coreDataManager.context.delete(record)
        coreDataManager.saveContext()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdate(DataStoreUpdate(insertedIndexes: insertedIndexes ?? IndexSet(), deletedIndexes: deletedIndexes ?? IndexSet()))
        insertedIndexes = nil
        deletedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let newIndexPath {
                insertedIndexes?.insert(newIndexPath.item)
            }
        default:
            break
        }
    }
}


