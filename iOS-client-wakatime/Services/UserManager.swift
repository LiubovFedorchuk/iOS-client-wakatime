//
//  UserManager.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/12/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Alamofire

/**
    # Service
 
    [WakaTime API v1: User]: https://wakatime.com/developers#users
 
    Usage: to get a single user.
 
    See also: [WakaTime API v1: User]
 
 */

class UserManager {

    func getUser (headers: [String: String], completionHandler: @escaping (Int?) -> Void) {
        Alamofire.request(Constants.BASE_URL + "/users/current",
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            let status = response.response?.statusCode
                            switch response.result {
                            case .success:
                                guard let status = status else {
                                    log.error("Request passed without status code - status code is nil.")
                                    completionHandler(nil)
                                    return
                                }
                                
                                guard status == 200 else {
                                    log.debug("Request passed with status code, but not 200 OK: \(status)")
                                    completionHandler(status)
                                    return
                                }
                                
                                completionHandler(status)
                            case .failure(let error):
                                guard let status = status else {
                                    log.debug("Request failure with error: \(error)")
                                    completionHandler(nil)
                                    return
                                }
                                log.debug("Request failure with status code: \(status)")
                                completionHandler(status)
                            }
        }
    }
}
