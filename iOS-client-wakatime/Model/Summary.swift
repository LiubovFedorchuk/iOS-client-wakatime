//
//  Summary.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 30.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import ObjectMapper

class Summary: Mappable {
    
    var projects: [EntrySummary]?;
    var grandTotalHoursOfCoding: Int?;
    var grandTotalMinutesOfCoding: Int?;
    var grandTotalTimeOfCodindAsText: String?;
    var grandTotalTimeOfCodingInSeconds: Int?;
    var dateOfCurrentRangeAsText: String?;
    var currentTimezone: String?;
    var startOfCommonRange: String?;
    var endOfCommonRange: String?;
    
    init(projects: [EntrySummary],
         grandTotalHoursOfCoding: Int,
         grandTotalMinutesOfCoding: Int,
         grandTotalTimeOfCodindAsText: String,
         grandTotalTimeOfCodingInSeconds: Int,
         dateOfCurrentRangeAsText: String,
         currentTimezone: String,
         startOfCommonRange: String,
         endOfCommonRange: String) {
        self.projects = projects;
        self.grandTotalHoursOfCoding = grandTotalHoursOfCoding;
        self.grandTotalMinutesOfCoding = grandTotalMinutesOfCoding;
        self.grandTotalTimeOfCodindAsText = grandTotalTimeOfCodindAsText;
        self.grandTotalTimeOfCodingInSeconds = grandTotalTimeOfCodingInSeconds;
        self.dateOfCurrentRangeAsText = dateOfCurrentRangeAsText;
        self.currentTimezone = currentTimezone;
        self.startOfCommonRange = startOfCommonRange;
        self.endOfCommonRange = endOfCommonRange;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        projects                                <- map["projects"];
        grandTotalHoursOfCoding                 <- map["grand_total.hours"];
        grandTotalMinutesOfCoding               <- map["grand_total.minutes"];
        grandTotalTimeOfCodindAsText            <- map["grand_total.text"];
        grandTotalTimeOfCodingInSeconds         <- map["grand_total.total_seconds"];
        dateOfCurrentRangeAsText                <- map["range.text"];
        currentTimezone                         <- map["range.timezone"];
        startOfCommonRange                      <- map["start"];
        endOfCommonRange                        <- map["end"];
    }
}
