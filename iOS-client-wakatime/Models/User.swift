//
//  User.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/12/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    var id: String?
    var displayName: String?
    var email: String?
    var timezone: String?
    var lastPlugin: String?
    var lastPluginName: String?
    var lastProject: String?
    var location: String?
    
    init(id: String,
         displayName: String,
         email: String,
         timezone: String,
         lastPlugin: String,
         lastPluginName: String,
         lastProject: String,
         location: String) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.timezone = timezone
        self.lastPlugin = lastPlugin
        self.lastPluginName = lastPluginName
        self.lastProject = lastProject
        self.location = location
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        displayName         <- map["display_name"]
        email               <- map["email"]
        timezone            <- map["timezone"]
        lastPlugin          <- map["last_plugin"]
        lastPluginName      <- map["last_plugin_name"]
        lastProject         <- map["last_project"]
        location            <- map["location"]
    }
}
