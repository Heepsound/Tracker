//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import CoreData

final class TrackerRecordStore {
    static let shared = TrackerRecordStore()
    
    private var coreDataManager = CoreDataManager.shared
    private var trackerStore = TrackerStore.shared
    
    // MARK: - Lifecycle
    
    private init() {}
    
    func add(indexPath: IndexPath, onDate: Date) {
        guard let tracker = trackerStore.object(at: indexPath) else { return }
        let record = TrackerRecordCoreData(context: coreDataManager.context)
        record.tracker = tracker
        record.date = onDate
        coreDataManager.saveContext()
    }
    
    func delete(id: UUID, trackersDate: Date) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K.id == %@ and %K == %@",
                                        #keyPath(TrackerRecordCoreData.tracker),
                                        id as CVarArg,
                                        #keyPath(TrackerRecordCoreData.date),
                                        trackersDate as CVarArg)
        request.resultType = .managedObjectIDResultType
        guard let result = try? coreDataManager.context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>, let result = result.finalResult else { return }
        for record in result {
            if let id = record as? NSManagedObjectID, let object = coreDataManager.context.object(with: id) as? TrackerRecordCoreData {
                coreDataManager.context.delete(object)
            }
        }
        coreDataManager.saveContext()
    }
    
    func recordCount(indexPath: IndexPath) -> Int {
        guard let tracker = trackerStore.object(at: indexPath) else { return .zero }
        return tracker.records?.count ?? .zero
    }
    
    func isDone(indexPath: IndexPath, trackersDate: Date) -> Bool {
        guard let tracker = trackerStore.object(at: indexPath), let records = tracker.records else {
            return false
        }
        let record = records.first(where: {($0 as? TrackerRecordCoreData)?.date == trackersDate})
        return record != nil
    }
}

