//
//  FiltersViewModel.swift
//  Tracker
//
//  Created by Владимир Горбачев on 25.05.2024.
//

import Foundation

final class FiltersViewModel {
    private let filterTypes: [FilterTypes] = [.all, .forToday, .completed, .notCompleted]
    
    private(set) var activeFilter: FilterTypes
    
    var filtersIsActive: Bool {
        return activeFilter != .all
    }
    
    init() {
        if let filter = FilterTypes(rawValue: UserDefaultsService.currentTrackerFilter) {
            activeFilter = filter
        } else {
            activeFilter = .all
        }
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return filterTypes.count
    }
    
    func model(at indexPath: IndexPath) -> FilterTypes {
        return filterTypes[indexPath.row]
    }
}
