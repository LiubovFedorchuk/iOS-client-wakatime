//
//  SummaryManager.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 30.01.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

/**
    # Service
 
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

class SummaryManager {
    
    func getUserSummaryForGivenTimeRange(startDate: String,
                                           endDate: String,
                                           completionHandler: @escaping ([Summary]?, Int?) -> Void) {
        let keychainManager = KeychainManager()
        let headers = keychainManager.createAuthorizationHeadersForRequest(userApiKey: nil)
        
        Alamofire.request(Constants.BASE_URL + "/users/current/summaries?start=\(startDate)&end=\(endDate)",
            
            headers: headers).validate().responseArray(keyPath: "data") {
                (response: DataResponse<[Summary]>) in
                let status = response.response?.statusCode
                switch response.result {
                case .success:
                    guard let status = status else {
                        log.error("Request passed without status code - status code is nil.")
                        completionHandler(nil, nil)
                        return
                    }
                    
                    guard status == 200,
                        let summariesData = response.result.value else {
                        log.debug("Request passed with status code, but not 200 OK: \(status)")
                        completionHandler(nil, status)
                        return
                    }
                    
                    completionHandler(summariesData, status)
                case .failure(let error):
                    guard let status = status else {
                        log.debug("Request failure with error: \(error)")
                        completionHandler(nil, nil)
                        return
                    }
                    log.debug("Request failure with status code: \(status)")
                    completionHandler(nil, status)
                }
        }
    }
}
