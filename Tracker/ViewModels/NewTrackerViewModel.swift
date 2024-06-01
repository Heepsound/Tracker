//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Владимир Горбачев on 13.05.2024.
//

import Foundation

final class NewTrackerViewModel {
    private let dataStore = TrackerStore.shared
    private let recordStore = TrackerRecordStore.shared
    
    let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    let colors = [
        "FD4C49", "FF881E", "007BFA", "6E44FE", "33CF69", "E66DD4",
        "F9D4D4", "34A7FE", "46E69D", "35347C", "FF674D", "FF99CC",
        "F6C48B", "7994F5", "832CF1", "AD56DA", "8D72E6", "2FD058"
    ]
    
    var allDataEntered: Binding<Bool>?
    
    var indexPath: IndexPath? {
        didSet {
            guard let indexPath else { return }
            let object = dataStore.object(at: indexPath)
            guard let category = object.category else { return }
            let tracker = Tracker(trackerCoreData: object)
            trackerName = tracker.name
            trackerType = tracker.trackerType
            trackerColor = tracker.color
            trackerEmoji = tracker.emoji
            trackerPinned = tracker.pinned
            trackerSchedule = tracker.schedule
            trackerCategory = TrackerCategory(trackerCategoryCoreData: category)
        }
    }
    
    var trackerName: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var trackerType: TrackerTypes? {
        didSet {
            checkNewTrackerData()
        }
    }
    var trackerColor: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var trackerEmoji: String? {
        didSet {
            checkNewTrackerData()
        }
    }
    var trackerPinned: Bool?
    var trackerCategory: TrackerCategory? {
        didSet {
            checkNewTrackerData()
        }
    }
    var trackerSchedule: [DaysOfWeek] = [] {
        didSet {
            checkNewTrackerData()
        }
    }
        
    var categoryRowsCount: Int {
        if let isIrregularEvent {
            return isIrregularEvent ? 1 : 2
        } else {
            return 0
        }
    }
    
    var isIrregularEvent: Bool? {
        guard let trackerType else { return nil }
        return trackerType == .irregularEvent
    }
    
    var isEditMode: Bool {
        guard let _ = indexPath else { return false }
        return true
    }
    
    var emojiIndexPath: IndexPath? {
        guard let trackerEmoji, let index = emojis.firstIndex(of: trackerEmoji) else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    var colorIndexPath: IndexPath? {
        guard let trackerColor, let index = colors.firstIndex(of: trackerColor) else { return nil }
        return IndexPath(row: index, section: 0)
    }
    
    func clearNewTrackerData() {
        indexPath = nil
        trackerName = nil
        trackerType = nil
        trackerColor = nil
        trackerEmoji = nil
        trackerPinned = nil
        trackerCategory = nil
        trackerSchedule = []
    }
    
    private func checkNewTrackerData() {
        var result = false
        if let trackerType, let trackerName, let _ = trackerEmoji, let _ = trackerColor, let _ = trackerCategory {
            result = !(trackerName.isEmpty || (trackerType == .habit && trackerSchedule.isEmpty))
        }
        allDataEntered?(result)
    }
    
    func save() {
        let tracker = Tracker(name: trackerName ?? "",
                            trackerType: trackerType ?? .irregularEvent,
                            color: trackerColor ?? "7994F5",
                            emoji: trackerEmoji ?? "🤔",
                            pinned: trackerPinned ?? false,
                            schedule: trackerSchedule)
        guard let trackerCategory else { return }
        dataStore.save(tracker, trackerCategory, at: indexPath)
    }
    
    // MARK: - Records
    
    func recordCount(indexPath: IndexPath) -> Int {
        return recordStore.recordCount(indexPath: indexPath)
    }
}
