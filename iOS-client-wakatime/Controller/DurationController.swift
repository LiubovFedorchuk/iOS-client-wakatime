//
//  DurationController.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 30.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

/**
    # Controller
 
    [WakaTime API v1: Durations]: https://wakatime.com/developers#durations
 
    Usage: to get user's coding activity for the given day as an array of duration blocks.
 
    See also: [WakaTime API v1: Durations]
 
    ## URL Parameters:
 
    `date` (_String_) - necessary - durations will be returned from 12am until 11:59pm in user's timezone for this day.
 
    `project` (_String_) - optional - show durations for this project.
 
    `branches` (_String_) - optional - show durations for these branches; comma separated list of branch names.
 
 */

class DurationController {
    
    let BASE_URL = "https://wakatime.com/api/v1";
    
    func getDurationOfUserCodingActivity(completionHandler: @escaping ([Duration]?, Int?) -> Void) {
        let headers = createAuthorizationHeadersForRequest();
        let currentDate = getCurrentDateAsString();
        
        Alamofire.request(BASE_URL + "/users/current/durations?date=\(currentDate)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).validate().responseArray(keyPath: "data") {
                (response: DataResponse<[Duration]>) in
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
    
     //TODO: transfer method
    func createAuthorizationHeadersForRequest() -> [String : String] {
        let userSecretAPIkeyUsingEncoding = readUserSecretAPIkeyFromKeyChain().data(using: String.Encoding.utf8)!;
        let userSecretAPIkeyBase64Encoded = userSecretAPIkeyUsingEncoding.base64EncodedString(options: []);
        let header = ["Authorization" : "Basic \(userSecretAPIkeyBase64Encoded)"];
        
        return header;
    }
    
    func getCurrentDateAsString() -> String {
        let date = Date();
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let result = formatter.string(from: date);
        
        return result;
    }
}
