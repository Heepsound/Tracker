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
    
    func delete(indexPath: IndexPath, trackersDate: Date) {
        guard let tracker = trackerStore.object(at: indexPath) else { return }
        let predicate = NSPredicate(format: "%K == %@ and %K == %@",
                                        #keyPath(TrackerRecordCoreData.tracker),
                                        tracker,
                                        #keyPath(TrackerRecordCoreData.date),
                                        trackersDate as CVarArg)
        guard let result = recordsByPredicate(tracker: tracker, predicate: predicate, resultType: .managedObjectIDResultType) else { return }
        for record in result {
            if let id = record as? NSManagedObjectID, let object = coreDataManager.context.object(with: id) as? TrackerRecordCoreData {
                coreDataManager.context.delete(object)
            }
        }
        coreDataManager.saveContext()
    }
    
    func recordCount(indexPath: IndexPath) -> Int {
        guard let tracker = trackerStore.object(at: indexPath) else { return .zero }
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.tracker), tracker)
        guard let result = recordsByPredicate(tracker: tracker, predicate: predicate, resultType: .countResultType), let count = result[0] as? Int else { return 0 }
        return count
    }
    
    func isDone(indexPath: IndexPath, trackersDate: Date) -> Bool {
        guard let tracker = trackerStore.object(at: indexPath) else { return false }
        let predicate = NSPredicate(format: "%K == %@ and %K == %@",
                                    #keyPath(TrackerRecordCoreData.tracker),
                                    tracker,
                                    #keyPath(TrackerRecordCoreData.date),
                                    trackersDate as CVarArg)
        guard let result = recordsByPredicate(tracker: tracker, predicate: predicate, resultType: .countResultType), let count = result[0] as? Int else { return false }
        return count > 0
    }
    
    private func recordsByPredicate(tracker: TrackerCoreData, predicate: NSPredicate, resultType: NSFetchRequestResultType) -> [any NSFetchRequestResult]? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = predicate
        request.resultType = resultType
        guard let result = try? coreDataManager.context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
                let result = result.finalResult else { return nil }
        return result
    }
}

