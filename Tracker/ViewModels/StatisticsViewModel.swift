//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Владимир Горбачев on 29.05.2024.
//

import Foundation

final class StatisticsViewModel {
    private let dataStore = StatisticsStore.shared
    private var statistics: [TrackersStatistics] = []
    var updateData: Binding<Bool>?
    
    func getData() {
        let bestPeriod = dataStore.bestPeriod()
        let perfectDays = dataStore.perfectDays()
        let completedTrackers = dataStore.completedTrackers()
        let averageValue = dataStore.averageValue()
        if bestPeriod > 0 || perfectDays > 0 || completedTrackers > 0 || averageValue > 0 {
            statistics = [
                TrackersStatistics(name: "Лучший период", count: bestPeriod),
                TrackersStatistics(name: "Идеальные дни", count: perfectDays),
                TrackersStatistics(name: "Трекеров завершено", count: completedTrackers),
                TrackersStatistics(name: "Среднее значение", count: averageValue)
            ]
        } else {
            statistics = []
        }
        updateData?(true)
    }
    
    var hasData: Bool {
        return numberOfRowsInSection(0) > 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return statistics.count
    }
    
    func model(at indexPath: IndexPath) -> TrackersStatistics {
        return statistics[indexPath.row]
    }
}
