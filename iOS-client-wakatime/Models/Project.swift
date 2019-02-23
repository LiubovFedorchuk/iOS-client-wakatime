//
//  Project.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/12/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import ObjectMapper

class Project: Mappable {
    
    var name: String?
    var privacy: String?
    var repository: String?
    
    init(name: String,
         privacy: String,
         repository: String) {
        self.name = name
        self.privacy = privacy
        self.repository = repository  
    }
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name             <- map["name"]
        privacy          <- map["privacy"]
        repository       <- map["repository"]
    }
}
