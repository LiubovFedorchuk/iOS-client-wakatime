//
//  StringExtention.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 2/14/19.
//  Copyright © 2019 Liubov Fedorchuk. All rights reserved.
//

import Foundation

extension String {
    
    func convertDateAsStringToAnotherFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM d"
        
        guard let newDate = date else {
            return ""
        }
        
        return dateFormatter.string(from: newDate)
    }
}
