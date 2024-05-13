//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Владимир Горбачев on 13.05.2024.
//

import Foundation

final class NewTrackerViewModel {
    private let dataStore = TrackerStore.shared
    
    var allDataEntered: Binding<Bool>?
    
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
    var trackerCategory: TrackerCategory? {
        didSet {
            checkNewTrackerData()
        }
    }
    var trackerSchedule: [DaysOfWeek] = [] {
        didSet {
            trackerSchedule.sort(by: {$0.dayNumber < $1.dayNumber})
            checkNewTrackerData()
        }
    }
    
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
    
    func clearNewTrackerData() {
        trackerName = nil
        trackerType = nil
        trackerColor = nil
        trackerEmoji = nil
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
    
    func add() {
        let tracker = Tracker(name: trackerName ?? "",
                              trackerType: trackerType ?? .irregularEvent,
                              color: trackerColor ?? "7994F5",
                              emoji: trackerEmoji ?? "🤔",
                              schedule: trackerSchedule)
        guard let trackerCategory else { return }
        dataStore.add(tracker, trackerCategory)
    }
}
