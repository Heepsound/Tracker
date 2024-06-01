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
    var updateTrackersDate: Binding<Date>?
    var updateSearchIsActive: Binding<Bool>?
    var updateFilterIsActive: Binding<Bool>?
    
    var trackersDate: Date {
        didSet {
            trackersDate = Calendar.current.startOfDay(for: trackersDate)
            updateTrackersDate?(trackersDate)
            if currentTrackerFilter == .forToday && trackersDate != Calendar.current.startOfDay(for: Date()) {
                currentTrackerFilter = .all
                updateFilterIsActive?(false)
            }
            getOnDate()
        }
    }
    
    var searchedText: String = "" {
        didSet {
            updateSearchIsActive?(searchedText != "")
            getOnDate()
        }
    }
    
    var currentTrackerFilter: FilterTypes {
        didSet {
            UserDefaultsService.currentTrackerFilter = currentTrackerFilter.rawValue
            updateFilterIsActive?(currentTrackerFilter != .all)
            if currentTrackerFilter == .forToday {
                trackersDate = Date()
            }
        }
    }
    
    var anyFiltersIsActive: Bool {
        return searchedText != "" || currentTrackerFilter != .all
    }
    
    // MARK: - Lifecycle
    
    init() {
        trackersDate = Calendar.current.startOfDay(for: Date())
        currentTrackerFilter = FilterTypes(rawValue: UserDefaultsService.currentTrackerFilter) ?? .all
    }
    
    func initialize() {
        getOnDate()
        updateFilterIsActive?(currentTrackerFilter != .all)
    }
    
    // MARK: - Trackers
    
    func getOnDate() {
        dataStore.getOnDate(date: trackersDate, searchBy: searchedText, filterBy: currentTrackerFilter)
        updateData?(DataStoreUpdate())
        updateFilterIsActive?(currentTrackerFilter != .all)
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
        updateFilterIsActive?(currentTrackerFilter != .all)
    }
    
    func setPinned(at indexPath: IndexPath)  {
        dataStore.setPinned(at: indexPath)
        getOnDate()
    }
    
    // MARK: - Records
    
    func addRecord(indexPath: IndexPath) {
        recordStore.add(indexPath: indexPath, onDate: trackersDate)
        getOnDate()
    }
    
    func deleteRecord(indexPath: IndexPath) {
        recordStore.delete(indexPath: indexPath, trackersDate: trackersDate)
        getOnDate()
    }
    
    func recordCount(indexPath: IndexPath) -> Int {
        return recordStore.recordCount(indexPath: indexPath)
    }
    
    func isDoneOnDate(indexPath: IndexPath) -> Bool {
        return recordStore.isDone(indexPath: indexPath, trackersDate: trackersDate)
    }
}

// MARK: - DataStoreDelegate

extension TrackerViewModel: DataStoreDelegate {
    func didUpdate(_ update: DataStoreUpdate) {
        updateData?(update)
    }
}

