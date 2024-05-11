//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Владимир Горбачев on 11.05.2024.
//

import Foundation

final class TrackerViewModel {
    private lazy var dataStore: TrackerStore = {
        let dataStore = TrackerStore.shared
        dataStore.delegate = self
        return dataStore
    }()
    
    var updateData: Binding<DataStoreUpdate>?
    
    func getOnDate(date: Date) {
        dataStore.getOnDate(date: date)
    }
    
    func hasData() -> Bool {
        return numberOfItemsInSection(0) > 0
    }
    
    func numberOfSections() -> Int {
        return dataStore.numberOfSections
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return dataStore.numberOfItemsInSection(section)
    }
    
    func model(at indexPath: IndexPath) -> Tracker? {
        guard let record = dataStore.object(at: indexPath) else { return nil }
        return Tracker(trackerCoreData: record)
    }
    
    func add(_ tracker: Tracker, _ category: TrackerCategory) {
        dataStore.add(tracker, category)
    }
    
    func categoryName(at indexPath: IndexPath) -> String? {
        guard let record = dataStore.object(at: indexPath) else { return nil }
        return record.category?.name
    }
}

// MARK: - DataStoreDelegate

extension TrackerViewModel: DataStoreDelegate {
    func didUpdate(_ update: DataStoreUpdate) {
        updateData?(update)
    }
}

