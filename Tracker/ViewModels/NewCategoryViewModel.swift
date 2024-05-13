//
//  NewCategoryViewModel.swift
//  Tracker
//
//  Created by Владимир Горбачев on 13.05.2024.
//

import Foundation

final class NewCategoryViewModel {
    private let dataStore = TrackerCategoryStore.shared
    
    var allDataEntered: Binding<Bool>?
    
    var categoryName: String? {
        didSet {
            checkNewCategoryData()
        }
    }
    
    private func checkNewCategoryData() {
        var result = false
        if let categoryName, !categoryName.isEmpty {
            result = true
        }
        allDataEntered?(result)
    }
    
    func add() {
        let model = TrackerCategory(name: categoryName ?? "Untitled", trackers: [])
        dataStore.add(model)
    }
}
