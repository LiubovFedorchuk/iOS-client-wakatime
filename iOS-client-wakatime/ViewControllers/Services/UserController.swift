//
//  UserController.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/12/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Foundation
import Alamofire

/**
    # Controller
 
    [WakaTime API v1: User]: https://wakatime.com/developers#users
 
    Usage: to get a single user.
 
    See also: [WakaTime API v1: User]
 
 */

class UserController {
    
    let BASE_URL = "https://wakatime.com/api/v1"
    
    func getUser (headers: [String:String], completionHandler: @escaping (Int?) -> Void) {
        Alamofire.request(BASE_URL + "/users/current",
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            let status = response.response?.statusCode
                            switch response.result {
                                
                            case .success:
                                guard status == 200 else {
                                    log.debug("Request passed with status code, but not 200 OK: \(status!)")
                                    completionHandler(status!)
                                    return
                                }
                                completionHandler(status!)
                            case .failure(let error):
                                guard status == nil else {
                                    log.debug("Request failure with status code: \(status!)")
                                    completionHandler(status!)
                                    return
                                }
                                log.debug("Request failure with error: \(error)")
                                completionHandler(nil)
                            }
        }
    }
}
