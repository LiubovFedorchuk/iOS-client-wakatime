//
//  DateExtentions.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 2/14/19.
//  Copyright © 2019 Liubov Fedorchuk. All rights reserved.
//

import Foundation

extension Date {
    
    func stringFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: self)
        
        return result
    }
    
    func dateAsStringSevenDaysAgoFromNow() -> String {
        let dateSevenDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let newDate = dateSevenDaysAgo else {
            return ""
        }
        let result = formatter.string(from: newDate)
        
        return result
    }
}
