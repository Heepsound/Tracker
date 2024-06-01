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
    
    var indexPath: IndexPath? {
        didSet {
            guard let indexPath else { return }
            let object = dataStore.object(at: indexPath)
            categoryName = object.name
        }
    }
    
    var isEditMode: Bool {
        guard let _ = indexPath else { return false }
        return true
    }
    
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
    
    func save() {
        let model = TrackerCategory(name: categoryName ?? "Untitled", trackers: [])
        dataStore.save(model, at: indexPath)
    }
}
