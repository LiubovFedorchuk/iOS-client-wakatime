//
//  IntExtensions.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 2/14/19.
//  Copyright © 2019 Liubov Fedorchuk. All rights reserved.
//

import Foundation

extension Int {
    
    func secondsToHours() -> Int {
        return self / 3600
    }
    
    func secondsToMinutes() -> Int {
        return (self % 3600) / 60
    }
}
