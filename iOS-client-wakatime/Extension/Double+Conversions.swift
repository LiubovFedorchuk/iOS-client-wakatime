//
//  Double+Conversions.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/11/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places : Int) -> Double {
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
    }
}
