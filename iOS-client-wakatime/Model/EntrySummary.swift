//
//  EntrySummary.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 25.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import ObjectMapper

class EntrySummary: Mappable {
    
    var entryName: String?;
    var workingTimeInPercent: Float?;
    var workingTimeAsText: String?;
    
    init(entryName: String,
         workingTimeInPercent: Float,
         workingTimeAsText: String) {
        self.entryName = entryName;
        self.workingTimeInPercent = workingTimeInPercent;
        self.workingTimeAsText = workingTimeAsText;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        entryName                        <- map["name"];
        workingTimeInPercent             <- map["percent"];
        workingTimeAsText                <- map["text"];
    }
}
