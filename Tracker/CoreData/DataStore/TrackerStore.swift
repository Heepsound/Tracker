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
    private var insertedIndexPaths: [IndexPath] = []
    private var deletedIndexPaths: [IndexPath] = []
    
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
    
    func object(at indexPath: IndexPath) -> TrackerCoreData? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func add(_ tracker: Tracker, _ category: TrackerCategory) {
        let object = TrackerCoreData(context: coreDataManager.context)
        object.id = tracker.id
        object.name = tracker.name
        object.trackerType = Int16(tracker.trackerType.rawValue)
        object.color = tracker.color
        object.emoji = tracker.emoji
        object.category = TrackerCategoryStore.shared.object(category)
        for shedule in tracker.schedule {
            let scheduleEntity = ScheduleCoreData(context: coreDataManager.context)
            scheduleEntity.dayOfWeek = Int16(shedule.rawValue)
            scheduleEntity.tracker = object
        }
        coreDataManager.saveContext()
    }
    
    func delete(at indexPath: IndexPath) {
        let record = fetchedResultsController.object(at: indexPath)
        coreDataManager.context.delete(record)
        coreDataManager.saveContext()
    }
    
    func getOnDate(date: Date) {
        let weekday = DaysOfWeek.dayByNumber(Calendar.current.component(.weekday, from: date))
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "(any %K.%K == %ld) or ((any %K == nil or any %K.%K == %@) and %K == %ld)",
                                                                      #keyPath(TrackerCoreData.schedule),
                                                                      #keyPath(ScheduleCoreData.dayOfWeek),
                                                                      weekday?.rawValue ?? 1,
                                                                      #keyPath(TrackerCoreData.records),
                                                                      #keyPath(TrackerCoreData.records),
                                                                      #keyPath(TrackerRecordCoreData.date),
                                                                      date as CVarArg,
                                                                      #keyPath(TrackerCoreData.trackerType),
                                                                      TrackerTypes.irregularEvent.rawValue)
        try? fetchedResultsController.performFetch()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        insertedIndexPaths = []
        deletedIndexPaths = []
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdate(DataStoreUpdate(
            insertedIndexPaths: insertedIndexPaths,
            deletedIndexPaths: deletedIndexPaths
        ))
        insertedIndexPaths = []
        deletedIndexPaths = []
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
            deletedIndexPaths.append(indexPath)
        case .insert:
            guard let newIndexPath else { return }
            insertedIndexPaths.append(newIndexPath)
        default:
            break
        }
    }
}


