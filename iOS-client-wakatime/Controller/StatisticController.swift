//
//  StatisticController.swift
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
 
    [WakaTime API v1: Stats]: https://wakatime.com/developers#stats
 
    Usage: to get user's coding activity for the given time range.
 
    See also: [WakaTime API v1: Stats]
 
    ## URL Parameters:
    `range` (_String_) - necessary - show user's coding activity for:
    - `last_7_days`
    - `last_30_days`
    - `last_6_months`
    - `last_year`
 
    `project` (_String_) - optional - show more detailed stats limited to this project.
 
 */

class StatisticController {
    
    let BASE_URL = "https://wakatime.com/api/v1";
    func getUserStatisticsForGivenTimeRange(completionHandler: @escaping (Statistic?, Int?) -> Void) {
        //TODO: add opportunity to change time range for getting user's coding activity
        let range = "last_7_days";
        let headers = createAuthorizationHeadersForRequest();
        
        Alamofire.request(BASE_URL + "/users/current/stats/\(range)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).validate().responseObject {
                (response: DataResponse<Statistic>) in
                let status = response.response?.statusCode;
                switch response.result {
                case .success:
                    guard status == 200 else {
                        log.debug("Request passed with status code, but not 200 OK: \(status!)");
                        completionHandler(nil, status!)
                        return
                    }
                    
                    let statisticsData = response.result.value!;
                    completionHandler(statisticsData, status!);
                case .failure(let error):
                    guard status == nil else {
                        log.debug("Request failure with status code: \(status!)");
                        completionHandler(nil, status!);
                        return
                    }
                    
                    log.debug("Request failure with error: \(error)");
                    completionHandler(nil, nil);
                }
        }
    }
    
    //TODO: transfer method
    func createAuthorizationHeadersForRequest() -> [String : String] {
        let userSecretAPIkeyUsingEncoding = readUserSecretAPIkeyFromKeyChain().data(using: String.Encoding.utf8)!;
        let userSecretAPIkeyBase64Encoded = userSecretAPIkeyUsingEncoding.base64EncodedString(options: []);
        let header = ["Authorization" : "Basic \(userSecretAPIkeyBase64Encoded)"];
        
        return header;
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
