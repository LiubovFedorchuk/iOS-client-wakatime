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
//    var dateOfCurrentRange: String?;
//    var startOfCurrentRange: String?;
//    var endOfCurrentRange: String?;
    var dateOfCurrentRangeAsText: String?;
    var currentTimezone: String?;
    var startOfCommonRange: String?;
    var endOfCommonRange: String?;
    
    init() {
        
    }
    
    init(projects: [EntrySummary], grandTotalHoursOfCoding: Int, grandTotalMinutesOfCoding: Int, grandTotalTimeOfCodindAsText: String, grandTotalTimeOfCodingInSeconds: Int, dateOfCurrentRangeAsText: String, currentTimezone: String, startOfCommonRange: String, endOfCommonRange: String) {
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
        projects   <- map["data.projects"];
        grandTotalHoursOfCoding  <- map["data.grand_total.hours"];
        grandTotalMinutesOfCoding  <- map["data.grand_total.minutes"];
        grandTotalTimeOfCodindAsText <- map["data.grand_total.text"];
        grandTotalTimeOfCodingInSeconds <- map["data.grand_total.total_seconds"];
        dateOfCurrentRangeAsText <- map["data.range.text"];
        currentTimezone <- map["data.range.timezone"];
        startOfCommonRange  <- map["data.start"];
        endOfCommonRange <- map["data.end"];
    }
}
