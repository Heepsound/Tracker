//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Владимир Горбачев on 27.04.2024.
//

import CoreData

struct DataStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

protocol DataStoreDelegate: AnyObject {
    func didUpdate(_ update: DataStoreUpdate)
}

protocol DataRecord {
    var id: UUID { get }
}

final class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Lifecycle
    
    private override init() {
        super.init()
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
