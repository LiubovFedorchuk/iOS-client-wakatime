//
//  StatisticData.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 25.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import ObjectMapper

class StatisticData: Mappable {
    
    var bestDay: BestDay?;
    var createdAt: String?;
    var dailyAverage: Int?;
    var daysIncludingHolidays: Int?;
    var daysMinusHolidays: Int?;
    var editors: [Editor]?;
    var end: String?;
    var holidays: Int?;
    var humanReadableDailyAverage: String?;
    var humanReadableTotal: String?;
    var id: String?;
    var isAlreadyUpdating: Bool?;
    var isCodingActivityVisible: Bool?;
    var isOtherUsageVisible: Bool?;
    var isStuck: Bool?;
    var isUpToDate: Bool?;
    var languages: [Language]?;
    var modifiedAt: String?;
    var operatingSystems: [OperatingSystem]?;
    var project: String?;
    var projects: [Project]?;
    var range: String?;
    var start: String?;
    var status: String?;
    var timeout: Int?;
    var timezone: String?;
    var totalSeconds: Int?;
    var userId: String?;
    var username: String?;
    var writesOnly: Bool?;
    
    init() {
        
    }
    
    init(bestDay: BestDay, createdAt: String, dailyAverage: Int, daysIncludingHolidays: Int, daysMinusHolidays: Int,
         editors: [Editor], end: String, holidays: Int,  humanReadableDailyAverage: String,
         humanReadableTotal: String, id: String, isAlreadyUpdating: Bool, isCodingActivityVisible: Bool,
         isOtherUsageVisible: Bool, isStuck: Bool, isUpToDate: Bool, languages: [Language], modifiedAt: String,
         operatingSystems: [OperatingSystem], project: String?, projects: [Project], range: String,
         start: String, status: String, timeout: Int, timezone: String, totalSeconds: Int,
         userId: String, username: String, writesOnly: Bool) {
        
        self.bestDay = bestDay;
        self.createdAt = createdAt;
        self.dailyAverage = dailyAverage;
        self.daysIncludingHolidays = daysIncludingHolidays;
        self.daysMinusHolidays = daysMinusHolidays;
        self.editors = editors;
        self.end = end;
        self.holidays = holidays;
        self.humanReadableDailyAverage = humanReadableDailyAverage;
        self.humanReadableTotal = humanReadableTotal;
        self.id = id;
        self.isAlreadyUpdating = isAlreadyUpdating;
        self.isCodingActivityVisible = isCodingActivityVisible;
        self.isOtherUsageVisible = isOtherUsageVisible;
        self.isStuck = isStuck;
        self.isUpToDate = isUpToDate;
        self.languages = languages;
        self.modifiedAt = modifiedAt;
        self.operatingSystems = operatingSystems;
        self.project = project;
        self.projects = projects;
        self.range = range;
        self.start = start;
        self.status = status;
        self.timeout = timeout;
        self.timezone = timezone;
        self.totalSeconds = totalSeconds;
        self.userId = userId;
        self.username = username;
        self.writesOnly = writesOnly;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        bestDay                             <- map["best_day"];
        createdAt                           <- map["created_at"];
        dailyAverage                        <- map["daily_average"];
        daysIncludingHolidays               <- map["days_including_holidays"];
        daysMinusHolidays                   <- map["days_minus_holidays"];
        editors                             <- map["editors"];
        end                                 <- map["end"];
        holidays                            <- map["holidays"];
        humanReadableDailyAverage           <- map["human_readable_daily_average"];
        humanReadableTotal                  <- map["human_readable_total"];
        id                                  <- map["id"];
        isAlreadyUpdating                   <- map["is_already_updating"];
        isCodingActivityVisible             <- map["is_coding_activity_visible"];
        isOtherUsageVisible                 <- map["is_other_usage_visible"];
        isStuck                             <- map["is_stuck"];
        isUpToDate                          <- map["is_up_to_date"];
        languages                           <- map["languages"];
        modifiedAt                          <- map["modified_at"];
        operatingSystems                    <- map["operating_systems"];
        project                             <- map["project"];
        projects                            <- map["projects"];
        range                               <- map["range"];
        start                               <- map["start"];
        status                              <- map["status"];
        timeout                             <- map["timeout"];
        timezone                            <- map["timezone"];
        totalSeconds                        <- map["total_seconds"];
        userId                              <- map["user_id"];
        username                            <- map["username"];
        writesOnly                          <- map["writes_only"];
    }
}
