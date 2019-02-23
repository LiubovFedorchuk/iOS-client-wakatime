//
//  Statistic.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 25.01.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import ObjectMapper

class Statistic: Mappable {
    
    var usedEditors: [EntrySummary]?
    var usedLanguages: [EntrySummary]?
    var usedOperatingSystems: [EntrySummary]?
    var humanReadableDailyAverage: String?
    var humanReadableTotalWorkingTime: String?
    var dailyAverageWorkingTime: Int?
    var startOfRange: String?
    var endOfRange: String?
    var totalWorkingTimeInSeconds: Int?
    
    init(usedEditors: [EntrySummary],
         usedLanguages: [EntrySummary],
         usedOperatingSystems: [EntrySummary],
         humanReadableDailyAverage: String,
         humanReadableTotalWorkingTime: String,
         dailyAverageWorkingTime: Int,
         startOfRange: String,
         endOfRange: String,
         totalWorkingTimeInSeconds: Int) {
        self.usedEditors = usedEditors
        self.usedLanguages = usedLanguages
        self.usedOperatingSystems = usedOperatingSystems
        self.humanReadableDailyAverage = humanReadableDailyAverage
        self.humanReadableTotalWorkingTime = humanReadableTotalWorkingTime
        self.dailyAverageWorkingTime = dailyAverageWorkingTime
        self.startOfRange = startOfRange
        self.endOfRange = endOfRange
        self.totalWorkingTimeInSeconds = totalWorkingTimeInSeconds
    }
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        usedEditors                         <- map["editors"]
        usedLanguages                       <- map["languages"]
        usedOperatingSystems                <- map["operating_systems"]
        humanReadableDailyAverage           <- map["human_readable_daily_average"]
        humanReadableTotalWorkingTime       <- map["human_readable_total"]
        dailyAverageWorkingTime             <- map["daily_average"]
        startOfRange                        <- map["start"]
        endOfRange                          <- map["end"]
        totalWorkingTimeInSeconds           <- map["total_seconds"]
    }
}
