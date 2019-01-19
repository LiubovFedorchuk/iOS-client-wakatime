//
//  EntrySummary.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 25.01.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Foundation
import ObjectMapper

class EntrySummary: Mappable {
    
    var entryName: String?
    var workingTimeInPercent: Double?
    var workingTimeAsText: String?
    var totalWorkingTimeAsSecond: Int?
    var workingTimeHoursPortion: Int?
    var workingTimeMinutesPortion: Int?
    
    init(entryName: String,
         workingTimeInPercent: Double,
         workingTimeAsText: String,
         totalWorkingTimeAsSecond: Int,
         workingTimeHoursPortion: Int,
         workingTimeMinutesPortion: Int) {
        self.entryName = entryName
        self.workingTimeInPercent = workingTimeInPercent
        self.workingTimeAsText = workingTimeAsText
        self.totalWorkingTimeAsSecond = totalWorkingTimeAsSecond
        self.workingTimeHoursPortion = workingTimeHoursPortion
        self.workingTimeMinutesPortion = workingTimeMinutesPortion
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        entryName                        <- map["name"]
        workingTimeInPercent             <- map["percent"]
        workingTimeAsText                <- map["text"]
        totalWorkingTimeAsSecond         <- map["total_seconds"]
        workingTimeHoursPortion          <- map["hours"]
        workingTimeMinutesPortion        <- map["minutes"]
    }
}
