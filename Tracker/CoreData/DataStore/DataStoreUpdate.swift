//
//  DataStoreUpdate.swift
//  Tracker
//
//  Created by Владимир Горбачев on 11.05.2024.
//

import Foundation

struct DataStoreUpdate {
    var insertedIndexPaths: [IndexPath]
    var deletedIndexPaths: [IndexPath]
    var updatedIndexPaths: [IndexPath]
    
    init() {
        self.insertedIndexPaths = []
        self.deletedIndexPaths = []
        self.updatedIndexPaths = []
    }
    
    init (from dataStoreUpdate: DataStoreUpdate) {
        self.insertedIndexPaths = dataStoreUpdate.insertedIndexPaths
        self.deletedIndexPaths = dataStoreUpdate.deletedIndexPaths
        self.updatedIndexPaths = dataStoreUpdate.updatedIndexPaths
    }
    
    mutating func clear() {
        self.insertedIndexPaths = []
        self.deletedIndexPaths = []
        self.updatedIndexPaths = []
    }
}

