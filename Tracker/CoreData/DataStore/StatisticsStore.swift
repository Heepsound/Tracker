//
//  StatisticsStore.swift
//  Tracker
//
//  Created by Владимир Горбачев on 30.05.2024.
//

import CoreData

final class StatisticsStore {
    static let shared = StatisticsStore()
    
    private let coreDataManager = CoreDataManager.shared
    
    private init() {}
    
    func bestPeriod() -> Int {
        let requestRecords = getRecordsRequest()
        let scheduleDictionary = getSchedulesDictionary()
        guard let result = try? coreDataManager.context.execute(requestRecords) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
              let result = result.finalResult else { return 0 }
        
        var count = 0
        var current = 0
        var previousDate: Date?
        var currentDate: Date?
        
        result.forEach { item in
            if let date = (item as AnyObject).value(forKey: "date") as? Date {
                currentDate = date
            }
            if previousDate == nil {
                previousDate = currentDate
            }
            if let diffDate = Calendar.current.dateComponents([.day], from: previousDate ?? Date(), to: currentDate ?? Date()).day,
               diffDate <= 1,
               let dayOfWeek = (item as AnyObject).value(forKey: "dayOfWeek") as? Int,
               let trackerCount = (item as AnyObject).value(forKey: "trackersCount") as? Int,
               let scheduleCount = scheduleDictionary[dayOfWeek],
               scheduleCount <= trackerCount
            {
                current += 1
            } else {
                count = max(count, current)
                current = 0
            }
            previousDate = currentDate
        }
        
        return max(count, current)
    }
    
    func perfectDays() -> Int {
        let requestRecords = getRecordsRequest()
        let scheduleDictionary = getSchedulesDictionary()
        guard let result = try? coreDataManager.context.execute(requestRecords) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
              let result = result.finalResult else { return 0 }
        
        var count = 0
        result.forEach { item in
            if let dayOfWeek = (item as AnyObject).value(forKey: "dayOfWeek") as? Int,
               let trackerCount = (item as AnyObject).value(forKey: "trackersCount") as? Int,
               let scheduleCount = scheduleDictionary[dayOfWeek],
               scheduleCount <= trackerCount
            {
                count += 1
            }
        }
        
        return count
    }
    
    func completedTrackers() -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.resultType = .countResultType
        guard let result = try? coreDataManager.context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
            let result = result.finalResult,
            let count = result[0] as? Int else { return 0 }
        return count
    }
    
    func averageValue() -> Int {
        let request = getRecordsRequest()
        guard let result = try? coreDataManager.context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
              let result = result.finalResult else { return 0 }
        
        var count = 0
        result.forEach { item in
            if let trackerCount = (item as AnyObject).value(forKey: "trackersCount") as? Int {
                count += trackerCount
            }
        }
        
        return result.count == 0 ? count : Int(count / result.count)
    }
    
    private func getRecordsRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        let countDesc = NSExpressionDescription()
        countDesc.expression = NSExpression(forFunction: "count:", arguments: [NSExpression(forKeyPath: "tracker")])
        countDesc.expressionResultType = .integer64AttributeType
        countDesc.name = "trackersCount"
        
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["date", "dayOfWeek", countDesc]
        request.propertiesToGroupBy = ["date", "dayOfWeek"]
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        return request
    }
    
    private func getSchedulesDictionary() -> [Int: Int] {
        let countDesc = NSExpressionDescription()
        countDesc.expression = NSExpression(forFunction: "count:", arguments: [NSExpression(forKeyPath: "tracker")])
        countDesc.expressionResultType = .integer64AttributeType
        countDesc.name = "trackersCount"
        
        let request = NSFetchRequest<ScheduleCoreData>(entityName: "ScheduleCoreData")
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["dayOfWeek", countDesc]
        request.propertiesToGroupBy = ["dayOfWeek"]
        request.sortDescriptors = [NSSortDescriptor(key: "dayOfWeek", ascending: true)]
        
        var dict: [Int: Int] = [:]
        
        guard let result = try? coreDataManager.context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
              let result = result.finalResult else { return dict }
        
        result.forEach { item in
            if let dayOfWeek = (item as AnyObject).value(forKey: "dayOfWeek") as? Int,
               let trackerCount = (item as AnyObject).value(forKey: "trackersCount") as? Int 
            {
                dict.updateValue(trackerCount, forKey: dayOfWeek)
            }
        }
        return dict
    }
}
