//
//  TrackerStore.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import CoreData

final class TrackerStore: NSObject {
    static let shared = TrackerStore()
    
    private var coreDataManager = CoreDataManager.shared
    
    weak var delegate: DataStoreDelegate?
    private var dataStoreUpdate = DataStoreUpdate()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.propertiesToFetch = ["name", "color", "emoji", "trackerType", "category"]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataManager.context, sectionNameKeyPath: "category", cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? .zero
    }
    
    private override init() {
        super.init()
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return .zero }
        return sections.isEmpty ? .zero : sections[section].numberOfObjects
    }
    
    func object(at indexPath: IndexPath) -> TrackerCoreData {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func save(_ tracker: Tracker, _ category: TrackerCategory, at indexPath: IndexPath?) {
        if let indexPath {
            let object = object(at: indexPath)
            fillData(object: object, tracker, category)
            coreDataManager.saveContext()
        } else {
            let object = TrackerCoreData(context: coreDataManager.context)
            object.id = tracker.id
            fillData(object: object, tracker, category)
            coreDataManager.saveContext()
        }
    }
    
    private func fillData(object: TrackerCoreData, _ tracker: Tracker, _ category: TrackerCategory) {
        object.name = tracker.name
        object.trackerType = Int16(tracker.trackerType.rawValue)
        object.color = tracker.color
        object.emoji = tracker.emoji
        object.category = TrackerCategoryStore.shared.object(category)
        if let schedule = object.schedule?.allObjects {
            for item in schedule {
                if let scheduleObject = item as? ScheduleCoreData {
                    coreDataManager.context.delete(scheduleObject)
                }
            }
        }
        for item in tracker.schedule {
            let schedule = ScheduleCoreData(context: coreDataManager.context)
            schedule.dayOfWeek = Int16(item.rawValue)
            schedule.tracker = object
        }
    }
    
    func delete(at indexPath: IndexPath) {
        let record = fetchedResultsController.object(at: indexPath)
        coreDataManager.context.delete(record)
        coreDataManager.saveContext()
    }
    
    func getOnDate(date: Date, filter: String) {
        let weekday = DaysOfWeek.dayByNumber(Calendar.current.component(.weekday, from: date))
        var requestText = "((any %K.%K == %ld) or ((any %K == nil or any %K.%K == %@) and %K == %ld))"
        if !filter.isEmpty {
            requestText.append(" and name CONTAINS[cd] %@")
        }
        let predicate = NSPredicate(
            format: requestText,
            #keyPath(TrackerCoreData.schedule),
            #keyPath(ScheduleCoreData.dayOfWeek),
            weekday?.rawValue ?? 1,
            #keyPath(TrackerCoreData.records),
            #keyPath(TrackerCoreData.records),
            #keyPath(TrackerRecordCoreData.date),
            date as CVarArg,
            #keyPath(TrackerCoreData.trackerType),
            TrackerTypes.irregularEvent.rawValue,
            filter as CVarArg
        )
        fetchedResultsController.fetchRequest.predicate = predicate
        try? fetchedResultsController.performFetch()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        dataStoreUpdate.clear()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdate(DataStoreUpdate(from: dataStoreUpdate))
        dataStoreUpdate.clear()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            guard let indexPath else { return }
            dataStoreUpdate.deletedIndexPaths.append(indexPath)
        case .insert:
            guard let newIndexPath else { return }
            dataStoreUpdate.insertedIndexPaths.append(newIndexPath)
        case .update:
            guard let indexPath else { return }
            dataStoreUpdate.updatedIndexPaths.append(indexPath)
        default:
            break
        }
    }
}


