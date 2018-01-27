//
//  SummariesController.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 27.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

/**
 # Controller
 
    Usage: to get user's coding activity for the given time range as an array of summaries segmented by day.
 
 ## URL Parameters:
    `start` (_Date_) - required - start date of the time range.
 
    `end` (_Date_) - required - end date of the time range.
 
    `project` (_String_) - optional - show time logged to this project.
 
    `branches` (_String_) - optional - show coding activity for these branches; comma separated list of branch names.
 */

class SummariesController {
    
    let BASE_URL = "https://wakatime.com/api/v1";
    
    func getUserSummariesForGivenTimeRange(completionHandler: @escaping (Statistic?, Int) -> Void) {
        
        let userSecretAPIkeyUsingEncoding = readUserSecretAPIkeyFromKeyChain().data(using: String.Encoding.utf8)!;
        let userSecretAPIkeyBase64Encoded = userSecretAPIkeyUsingEncoding.base64EncodedString(options: []);
        let headers = ["Authorization" : "Basic \(userSecretAPIkeyBase64Encoded)"];
        
    }
    
    //TODO: transfer method
    
    func readUserSecretAPIkeyFromKeyChain() -> String {
        var userSecretAPIkey: String;
        do {
            let userSecretAPIkeyItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup);
            userSecretAPIkey = try userSecretAPIkeyItem.readPassword();
        }
        catch {
            fatalError("Error reading secret API key from keychain - \(error)");
        }
        
        return userSecretAPIkey;
    }
}
