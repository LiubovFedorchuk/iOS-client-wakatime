//
//  SummaryController.swift
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
 
    [WakaTime API v1: Summaries]: https://wakatime.com/developers#summaries
 
    Usage: to get user's coding activity for the given time range as an array of summaries segmented by day.
 
    See also: [WakaTime API v1: Summaries]
 
    ## URL Parameters:
 
    `start` (_String_) - necessary - start date of the time range.
 
    `end` (_String_) - necessary - end date of the time range.
 
    `project` (_String_) - optional - show time logged to this project.
 
    `branches` (_String_) - optional - show coding activity for these branches;
    comma separated list of branch names.

 */

class SummaryController {
    
    let BASE_URL = "https://wakatime.com/api/v1";
    
    func getUserSummariesForGivenTimeRange(completionHandler: @escaping ([Summary]?, Int?) -> Void) {
        let start = getStartDayAsString();
        let end = getEndDateAsString();
        let headers = createAuthorizationHeadersForRequest();
        
        Alamofire.request(BASE_URL + "/users/current/summaries?start=\(start)&end=\(end)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).validate().responseArray(keyPath: "data") {
                (response: DataResponse<[Summary]>) in
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
    
    func getStartDayAsString() -> String {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date());
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let result = formatter.string(from: sevenDaysAgo!);
        
        return result;
    }
    
    func getEndDateAsString() -> String {
        let date = Date();
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let result = formatter.string(from: date);
        
        return result;
    }
}
