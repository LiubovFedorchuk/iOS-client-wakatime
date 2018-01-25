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
    
    var data: StatisticData?;
    
    init() {
        
    }
    
    init(data: StatisticData) {
        self.data = data;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data          <- map["data"];
    }
}
