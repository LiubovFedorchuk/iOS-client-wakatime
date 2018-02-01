//
//  Duration.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 30.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import ObjectMapper

class Duration: Mappable {
    
    var projectName: String?;
    var workingTimeDuration: Int?;
    // start time of duration as ISO 8601 UTC datetime
    // numbers after decimal point are fractions of a second
    var startTimeOfDuration: Float?;
    
    init(projectName: String,
         workingTimeDuration: Int,
         startTimeOfDuration: Float) {
        self.projectName = projectName;
        self.workingTimeDuration = workingTimeDuration;
        self.startTimeOfDuration = startTimeOfDuration;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        projectName                        <- map["project"];
        workingTimeDuration                <- map["duration"];
        startTimeOfDuration                <- map["time"];
    }
}
