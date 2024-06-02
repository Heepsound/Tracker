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
        let categorySortDescriptor = NSSortDescriptor(key: "category.name", ascending: true)
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [categorySortDescriptor, nameSortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataManager.context, sectionNameKeyPath: "category.name", cacheName: nil)
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
        object.pinned = tracker.pinned
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
    
    func setPinned(at indexPath: IndexPath) {
        let object = object(at: indexPath)
        object.pinned = !object.pinned
        coreDataManager.saveContext()
    }
    
    func delete(at indexPath: IndexPath) {
        let record = fetchedResultsController.object(at: indexPath)
        coreDataManager.context.delete(record)
        coreDataManager.saveContext()
    }
    
    func getOnDate(date: Date, searchBy searchedText: String, filterBy filter: FilterTypes) {
        let weekday = DaysOfWeek(rawValue: Calendar.current.component(.weekday, from: date))
        var requestText = "((any %K.%K == %ld or (%K == %ld"
        var argumentsArray: [Any] = []
        argumentsArray.append(#keyPath(TrackerCoreData.schedule))
        argumentsArray.append(#keyPath(ScheduleCoreData.dayOfWeek))
        argumentsArray.append(weekday?.rawValue ?? 1)
        argumentsArray.append(#keyPath(TrackerCoreData.trackerType))
        argumentsArray.append(TrackerTypes.irregularEvent.rawValue)
        switch filter {
        case .completed:
            requestText.append(")) and any %K.%K == %@)")
            argumentsArray.append(#keyPath(TrackerCoreData.records))
            argumentsArray.append(#keyPath(TrackerRecordCoreData.date))
            argumentsArray.append(date as CVarArg)
        case .notCompleted:
            requestText.append(")) and SUBQUERY(%K, $x, $x.%K == %@).@count == 0)")
            argumentsArray.append(#keyPath(TrackerCoreData.records))
            argumentsArray.append(#keyPath(TrackerRecordCoreData.date))
            argumentsArray.append(date as CVarArg)
        default:
            requestText.append(" and (any %K == nil or any %K.%K == %@))) or %K = true)")
            argumentsArray.append(#keyPath(TrackerCoreData.records))
            argumentsArray.append(#keyPath(TrackerCoreData.records))
            argumentsArray.append(#keyPath(TrackerRecordCoreData.date))
            argumentsArray.append(date as CVarArg)
            argumentsArray.append(#keyPath(TrackerCoreData.pinned))
        }
        if !searchedText.isEmpty {
            requestText.append(" and name CONTAINS[cd] %@")
            argumentsArray.append(searchedText as CVarArg)
        }
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: requestText, argumentArray: argumentsArray)
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


