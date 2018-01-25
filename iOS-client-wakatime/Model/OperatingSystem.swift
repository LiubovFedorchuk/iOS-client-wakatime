//
//  OperatingSystem.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 25.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import ObjectMapper

class OperatingSystem: Mappable {
    
    var digital: String?;
    var hours: Int?;
    var minutes: Int?;
    var name: String?;
    var percent: Float?;
    var text: String?;
    var totalSeconds: Int?;
    
    init() {
        
    }
    
    init(digital: String, hours: Int, minutes: Int, name: String, percent: Float, text: String, totalSeconds: Int) {
        self.digital = digital;
        self.hours = hours;
        self.minutes = minutes;
        self.name = name;
        self.percent = percent;
        self.text = text;
        self.totalSeconds = totalSeconds;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        digital             <- map["digital"];
        hours               <- map["hours"];
        minutes             <- map["minutes"];
        name                <- map["name"];
        percent             <- map["percent"];
        text                <- map["text"];
        totalSeconds        <- map["total_seconds"];
    }
}
