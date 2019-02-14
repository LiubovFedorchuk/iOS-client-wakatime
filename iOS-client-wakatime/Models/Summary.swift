//
//  Summary.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 30.01.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import ObjectMapper

class Summary: Mappable {
    
    var project: [EntrySummary]?
    var category: [EntrySummary]?
    var grandTotalHoursOfCoding: Int?
    var grandTotalMinutesOfCoding: Int?
    var grandTotalTimeOfCodindAsText: String?
    var grandTotalTimeOfCodingInSeconds: Int?
    var dateOfCurrentRange: String?
    var currentTimezone: String?
    var startOfCommonRange: String?
    var endOfCommonRange: String?
    
    init(project: [EntrySummary],
         category: [EntrySummary],
         grandTotalHoursOfCoding: Int,
         grandTotalMinutesOfCoding: Int,
         grandTotalTimeOfCodindAsText: String,
         grandTotalTimeOfCodingInSeconds: Int,
         dateOfCurrentRange: String,
         currentTimezone: String,
         startOfCommonRange: String,
         endOfCommonRange: String) {
        self.project = project
        self.category = category
        self.grandTotalHoursOfCoding = grandTotalHoursOfCoding
        self.grandTotalMinutesOfCoding = grandTotalMinutesOfCoding
        self.grandTotalTimeOfCodindAsText = grandTotalTimeOfCodindAsText
        self.grandTotalTimeOfCodingInSeconds = grandTotalTimeOfCodingInSeconds
        self.dateOfCurrentRange = dateOfCurrentRange
        self.currentTimezone = currentTimezone
        self.startOfCommonRange = startOfCommonRange
        self.endOfCommonRange = endOfCommonRange
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        project                                 <- map["projects"]
        category                                <- map["categories"]
        grandTotalHoursOfCoding                 <- map["grand_total.hours"]
        grandTotalMinutesOfCoding               <- map["grand_total.minutes"]
        grandTotalTimeOfCodindAsText            <- map["grand_total.text"]
        grandTotalTimeOfCodingInSeconds         <- map["grand_total.total_seconds"]
        dateOfCurrentRange                      <- map["range.date"]
        currentTimezone                         <- map["range.timezone"]
        startOfCommonRange                      <- map["start"]
        endOfCommonRange                        <- map["end"]
    }
}
