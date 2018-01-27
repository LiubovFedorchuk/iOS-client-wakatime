//
//  StatisticsController.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 25.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

/**
    # Controller
 
    Usage: to get user's coding activity for the given time range.
 
    ## URL Parameters:
    `range` (_String_) - necessary - show user's coding activity for:
    - `last_7_days`
    - `last_30_days`
    - `last_6_months`
    - `last_year`
 
    `project` (_String_) - optional - show more detailed stats limited to this project.
 */

class StatisticsController {
    
    let BASE_URL = "https://wakatime.com/api/v1";
    
    func getUserStatisticsForGivenTimeRange(completionHandler: @escaping (Statistic?, Int) -> Void) {
        
        let userSecretAPIkeyUsingEncoding = readUserSecretAPIkeyFromKeyChain().data(using: String.Encoding.utf8)!;
        let userSecretAPIkeyBase64Encoded = userSecretAPIkeyUsingEncoding.base64EncodedString(options: []);
        let headers = ["Authorization" : "Basic \(userSecretAPIkeyBase64Encoded)"];
        
        //TODO: add opportunity to change time range for getting user's coding activity
        let range = "last_7_days";
        
        Alamofire.request(BASE_URL + "/users/current/stats/\(range)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseObject {
                (response: DataResponse<Statistic>) in
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        let statisticsData = response.result.value!;
                        completionHandler(statisticsData, status);
                    case 401:
                        completionHandler(nil, status);
                    case 500...526:
                        completionHandler(nil, status);
                    default:
                        completionHandler(nil, status);
                    }
                }
        }
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
