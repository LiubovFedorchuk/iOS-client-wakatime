//
//  Connectivity.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/12/18.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
