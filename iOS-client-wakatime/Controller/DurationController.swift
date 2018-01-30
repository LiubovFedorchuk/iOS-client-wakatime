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
 
    Usage: to get user's coding activity for the given day as an array of duration blocks.
 
    ## URL Parameters:
 
    `date` (_String_) - necessary - durations will be returned from 12am until 11:59pm in user's timezone for this day.
 
    `project` (_String_) - optional - show durations for this project.
 
    `branches` (_String_) - optional - show durations for these branches; comma separated list of branch names.
 
 */

class DurationController {
    
    let BASE_URL = "https://wakatime.com/api/v1";
    
    func getDurationOfUserCodingActivity(completionHandler: @escaping ([Duration]?, Int) -> Void) {
        let headers = createAuthorizationHeadersForRequest();
        let currentDate = getCurrentDateAsString();
        
        Alamofire.request(BASE_URL + "/users/current/durations?date=\(currentDate)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseArray(keyPath: "data") {
                (response: DataResponse<[Duration]>) in
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        let duration = response.result.value!;
                        completionHandler(duration, status);
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
    
     //TODO: transfer method
    func createAuthorizationHeadersForRequest() -> [String : String] {
        let userSecretAPIkeyUsingEncoding = readUserSecretAPIkeyFromKeyChain().data(using: String.Encoding.utf8)!;
        let userSecretAPIkeyBase64Encoded = userSecretAPIkeyUsingEncoding.base64EncodedString(options: []);
        return ["Authorization" : "Basic \(userSecretAPIkeyBase64Encoded)"];
    }
    
    func getCurrentDateAsString() -> String {
        let date = Date();
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let result = formatter.string(from: date);
        return result;
    }
}
