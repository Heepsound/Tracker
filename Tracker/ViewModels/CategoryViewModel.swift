//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Владимир Горбачев on 11.05.2024.
//

import Foundation

final class CategoryViewModel {
    private lazy var dataStore: TrackerCategoryStore = {
        let dataStore = TrackerCategoryStore.shared
        dataStore.delegate = self
        return dataStore
    }()
    
    var updateData: Binding<DataStoreUpdate>?
    
    func hasData() -> Bool {
        return numberOfRowsInSection(0) > 0
    }
    
    func numberOfSections() -> Int {
        return dataStore.numberOfSections
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return dataStore.numberOfRowsInSection(section)
    }
    
    func model(at indexPath: IndexPath) -> TrackerCategory? {
        guard let record = dataStore.object(at: indexPath) else { return nil }
        return TrackerCategory(trackerCategoryCoreData: record)
    }
    
    func add(_ model: TrackerCategory) {
        dataStore.add(model)
    }
    
    func delete(at indexPath: IndexPath) {
        dataStore.delete(at: indexPath)
    }
}

// MARK: - DataStoreDelegate

extension CategoryViewModel: DataStoreDelegate {
    func didUpdate(_ update: DataStoreUpdate) {
        updateData?(update)
    }
}

