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
    var allDataEntered: Binding<Bool>?
    
    var trackersDate: Date? {
        didSet {
            guard let trackersDate else { return }
            let currentDate = Calendar.current.startOfDay(for: trackersDate)
            self.trackersDate = currentDate
            getOnDate()
        }
    }
    
    var newTrackerName: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerType: TrackerTypes? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerColor: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerEmoji: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerCategory: TrackerCategory? {
        didSet {
            checkNewTrackerData()
        }
    }
    var newTrackerSchedule: [DaysOfWeek] = [] {
        didSet {
            checkNewTrackerData()
        }
    }
    
    // MARK: - Trackers
    
    func getOnDate() {
        guard let trackersDate else { return }
        dataStore.getOnDate(date: trackersDate)
        updateData?(DataStoreUpdate(insertedIndexPaths: [], deletedIndexPaths: []))
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
    
    func add() {
        let tracker = Tracker(name: newTrackerName ?? "",
                              trackerType: newTrackerType ?? .irregularEvent,
                              color: newTrackerColor ?? "7994F5",
                              emoji: newTrackerEmoji ?? "🤔",
                              schedule: newTrackerSchedule)
        guard let newTrackerCategory else { return }
        dataStore.add(tracker, newTrackerCategory)
        getOnDate()
    }
    
    func categoryName(at indexPath: IndexPath) -> String? {
        guard let record = dataStore.object(at: indexPath) else { return nil }
        return record.category?.name
    }
    
    func isIrregularEvent() -> Bool? {
        guard let newTrackerType else { return nil }
        return newTrackerType == .irregularEvent
    }
    
    private func checkNewTrackerData() {
        var result = false
        if let newTrackerType, let newTrackerName, let _ = newTrackerEmoji, let _ = newTrackerColor, let _ = newTrackerCategory {
            result = !(newTrackerName.isEmpty || (newTrackerType == .habit && newTrackerSchedule.isEmpty))
        }
        allDataEntered?(result)
    }
    
    func clearNewTrackerData() {
        newTrackerName = nil
        newTrackerType = nil
        newTrackerColor = nil
        newTrackerEmoji = nil
        newTrackerCategory = nil
        newTrackerSchedule = []
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

