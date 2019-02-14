//
//  Project.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/12/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import ObjectMapper

class Project: Mappable {
    
    var id: String?
    var name: String?
    var privacy: String?
    var repository: String?
    
    init(id: String,
         name: String,
         privacy: String,
         repository: String) {
        self.id = id
        self.name = name
        self.privacy = privacy
        self.repository = repository  
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id               <- map["id"]
        name             <- map["name"]
        privacy          <- map["privacy"]
        repository       <- map["repository"]
    }
}
