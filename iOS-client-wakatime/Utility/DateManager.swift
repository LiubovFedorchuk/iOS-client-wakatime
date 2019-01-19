//
//  DateManager.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10/11/18.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation

class DateManager {
    
    func getStartDayAsString() -> String {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: sevenDaysAgo!)
        
        return result
    }
    
    func getCurrentDateAsString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        return result
    }
    
    func convertToAnotherDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM d"
        return  dateFormatter.string(from: date!)
    }
}
