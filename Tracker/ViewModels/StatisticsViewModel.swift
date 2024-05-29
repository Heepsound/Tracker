//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Владимир Горбачев on 29.05.2024.
//

import Foundation

final class StatisticsViewModel {
    private let statistics: [TrackersStatistics] = [
        TrackersStatistics(name: "Лучший период", count: 6),
        TrackersStatistics(name: "Идеальные дни", count: 2),
        TrackersStatistics(name: "Трекеров завершено", count: 5),
        TrackersStatistics(name: "Среднее значение", count: 4)
    ]
    
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
