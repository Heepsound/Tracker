//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import CoreData

final class TrackerCategoryStore: NSObject {
    private var coreDataManager = CoreDataManager.shared
    
    weak var delegate: DataStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
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
    
    func object(at indexPath: IndexPath) -> TrackerCategoryCoreData? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func add(_ trackerCategory: TrackerCategory) {
        let object = TrackerCategoryCoreData(context: coreDataManager.context)
        object.id = trackerCategory.id
        object.name = trackerCategory.name
        coreDataManager.saveContext()
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
