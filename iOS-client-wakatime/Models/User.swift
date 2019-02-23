//
//  User.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/12/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    
    var displayName: String?
    var email: String?
    var timezone: String?
    var lastProject: String?
    var location: String?
    
    init(displayName: String,
         email: String,
         timezone: String,
         lastProject: String,
         location: String) {
        self.displayName = displayName
        self.email = email
        self.timezone = timezone
        self.lastProject = lastProject
        self.location = location
    }
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        displayName         <- map["display_name"]
        email               <- map["email"]
        timezone            <- map["timezone"]
        lastProject         <- map["last_project"]
        location            <- map["location"]
    }
}
