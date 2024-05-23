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
    
    private let recordStore = TrackerRecordStore.shared
    
    var updateData: Binding<DataStoreUpdate>?
    
    var trackersDate: Date? {
        didSet {
            guard let trackersDate else { return }
            let currentDate = Calendar.current.startOfDay(for: trackersDate)
            self.trackersDate = currentDate
            getOnDate()
        }
    }
    
    var trackersFilter: String = "" {
        didSet {
            getOnDate()
        }
    }
    
    // MARK: - Trackers
    
    func getOnDate() {
        guard let trackersDate else { return }
        dataStore.getOnDate(date: trackersDate, filter: trackersFilter)
        updateData?(DataStoreUpdate())
    }
    
    var hasData: Bool {
        return numberOfItemsInSection(0) > 0
    }
    
    var numberOfSections: Int {
        return dataStore.numberOfSections
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return dataStore.numberOfItemsInSection(section)
    }
    
    func model(at indexPath: IndexPath) -> Tracker {
        let record = dataStore.object(at: indexPath)
        return Tracker(trackerCoreData: record)
    }
    
    func categoryName(at indexPath: IndexPath) -> String? {
        let record = dataStore.object(at: indexPath)
        return record.category?.name
    }
    
    func delete(indexPath: IndexPath) {
        dataStore.delete(at: indexPath)
    }
    
    // MARK: - Records
    
    func addRecord(indexPath: IndexPath) {
        guard let trackersDate else { return }
        recordStore.add(indexPath: indexPath, onDate: trackersDate)
        getOnDate()
    }
    
    func deleteRecord(indexPath: IndexPath) {
        guard let trackersDate else { return }
        recordStore.delete(indexPath: indexPath, trackersDate: trackersDate)
        getOnDate()
    }
    
    func recordCount(indexPath: IndexPath) -> Int {
        return recordStore.recordCount(indexPath: indexPath)
    }
    
    func isDoneOnDate(indexPath: IndexPath) -> Bool {
        guard let trackersDate else { return false }
        return recordStore.isDone(indexPath: indexPath, trackersDate: trackersDate)
    }
}

// MARK: - DataStoreDelegate

extension TrackerViewModel: DataStoreDelegate {
    func didUpdate(_ update: DataStoreUpdate) {
        updateData?(update)
    }
}

