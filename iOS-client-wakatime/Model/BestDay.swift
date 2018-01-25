//
//  BestDay.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 25.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import ObjectMapper

class BestDay: Mappable {
    
    var createdAt: String?;
    var date: String?;
    var id: String?;
    var modifiedAt: String?;
    var totalSeconds: Int?;
    
    init() {
        
    }
    
    init(createdAt: String, date: String, id: String, modifiedAt: String, totalSeconds: Int) {
        self.createdAt = createdAt;
        self.date = date;
        self.id = id;
        self.modifiedAt = modifiedAt;
        self.totalSeconds = totalSeconds;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        createdAt          <- map["created_at"];
        date               <- map["date"];
        id                 <- map["id"];
        modifiedAt         <- map["modified_at"];
        totalSeconds       <- map["total_seconds"];
    }
}

