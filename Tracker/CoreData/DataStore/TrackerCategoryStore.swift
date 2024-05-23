//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import CoreData

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    
    private var coreDataManager = CoreDataManager.shared
    
    weak var delegate: DataStoreDelegate?
    private var insertedIndexPaths: [IndexPath] = []
    private var deletedIndexPaths: [IndexPath] = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? .zero
    }
    
    private override init() {
        super.init()
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return .zero }
        return sections.isEmpty ? .zero : sections[section].numberOfObjects
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategoryCoreData {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func object(_ model: TrackerCategory) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        guard let result = try? coreDataManager.context.fetch(request) else { return nil }
        return result[0]
    }
    
    func save(_ trackerCategory: TrackerCategory, at indexPath: IndexPath?) {
        if let indexPath {
            let object = object(at: indexPath)
            object.name = trackerCategory.name
            coreDataManager.saveContext()
        } else {
            let object = TrackerCategoryCoreData(context: coreDataManager.context)
            object.id = trackerCategory.id
            object.name = trackerCategory.name
            coreDataManager.saveContext()
        }
    }
    
    func delete(at indexPath: IndexPath) {
        let record = fetchedResultsController.object(at: indexPath)
        coreDataManager.context.delete(record)
        coreDataManager.saveContext()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
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
            if let indexPath {
                deletedIndexPaths.append(indexPath)
            }
        case .insert:
            if let newIndexPath {
                insertedIndexPaths.append(newIndexPath)
            }
        //case .update:
            //if let indexPath {
                
            //}
        default:
            break
        }
    }
}
