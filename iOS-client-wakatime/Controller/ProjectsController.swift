//
//  ProjectsController.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 22.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyBeaver
import AlamofireObjectMapper

class ProjectsController {
    
    let BASE_URL = "https://wakatime.com/api/v1";
    
    func tmp(completionHandler: @escaping ([ProjectsData]?)-> ()) {
        var userSecretAPIkey: String;
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
            
            userSecretAPIkey = try passwordItem.readPassword();
        }
        catch {
            fatalError("Error reading secret API key from keychain - \(error)")
        }
        let userSecretAPIkeyUsingEncoding = userSecretAPIkey.data(using: String.Encoding.utf8)!;
        let userSecretAPIkeyBase64Encoded = userSecretAPIkeyUsingEncoding.base64EncodedString(options: []);
        let headers = ["Authorization" : "Basic \(userSecretAPIkeyBase64Encoded)"];
        Alamofire.request(BASE_URL + "/users/current/projects",
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: headers).responseObject {
                            (response: DataResponse<Projects>) in
                            if let status = response.response?.statusCode {
                                switch(status) {
                                    case 200:
                                        guard response.result.isSuccess else {
                                            completionHandler(nil);
                                            return
                                    }
                                        completionHandler(response.result.value?.data);
                                        log.debug("REST request to get all projects passed successfully. ");
                                    default:
                                        completionHandler(nil);
                                        log.error("Error: REST request to get all projects has failed.");
                                }
                        }
        }
    }
}
