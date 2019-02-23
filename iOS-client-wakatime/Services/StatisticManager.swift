//
//  StatisticManager.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 25.01.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

/**
    # Service
 
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

class StatisticManager {
    
    func getUserStatisticsForGivenTimeRange(range: String, completionHandler: @escaping (Statistic?, Int?) -> Void) {
        let keychainManager = KeychainManager()
        let headers = keychainManager.createAuthorizationHeadersForRequest(userApiKey: nil)
        
        Alamofire.request(Constants.BASE_URL + "/users/current/stats/\(range)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).validate().responseObject(keyPath: "data") {
                (response: DataResponse<Statistic>) in
                let status = response.response?.statusCode
                switch response.result {
                case .success:
                    guard let status = status else {
                        log.error("Request passed without status code - status code is nil.")
                        completionHandler(nil, nil)
                        return
                    }
                    
                    guard status == 200,
                        let statisticsData = response.result.value else {
                            log.debug("Request passed with status code, but not 200 OK: \(status)")
                            completionHandler(nil, status)
                            return
                    }
                    
                    completionHandler(statisticsData, status)
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
