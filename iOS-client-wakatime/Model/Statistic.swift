//
//  Statistic.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 25.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import ObjectMapper

class Statistic: Mappable {
    
    var usedEditors: [EntrySummary]?;
    var usedLanguages: [EntrySummary]?;
    var usedOperatingSystems: [EntrySummary]?;
    var humanReadableDailyAverage: String?;
    var humanReadableTotal: String?;
    var dailyAverageWorkingTime: Int?;
    var startOfRange: String?;
    var endOfRange: String?;
    var totalWorkingTimeInSeconds: Int?;
    
    init(usedEditors: [EntrySummary],
         usedLanguages: [EntrySummary],
         usedOperatingSystems: [EntrySummary],
         humanReadableDailyAverage: String,
         humanReadableTotal: String,
         dailyAverageWorkingTime: Int,
         startOfRange: String,
         endOfRange: String,
         totalWorkingTimeInSeconds: Int) {
        self.usedEditors = usedEditors;
        self.usedLanguages = usedLanguages;
        self.usedOperatingSystems = usedOperatingSystems;
        self.humanReadableDailyAverage = humanReadableDailyAverage;
        self.humanReadableTotal = humanReadableTotal;
        self.dailyAverageWorkingTime = dailyAverageWorkingTime;
        self.startOfRange = startOfRange;
        self.endOfRange = endOfRange;
        self.totalWorkingTimeInSeconds = totalWorkingTimeInSeconds;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        usedEditors                         <- map["data.editors"];
        usedLanguages                       <- map["data.languages"];
        usedOperatingSystems                <- map["data.operating_systems"];
        humanReadableDailyAverage           <- map["data.human_readable_daily_average"];
        humanReadableTotal                  <- map["data.human_readable_total"];
        dailyAverageWorkingTime             <- map["data.daily_average"];
        startOfRange                        <- map["data.start"];
        endOfRange                          <- map["data.end"];
        totalWorkingTimeInSeconds           <- map["data.total_seconds"];
    }
}
