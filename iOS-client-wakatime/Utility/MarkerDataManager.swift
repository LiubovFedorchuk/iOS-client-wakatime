//
//  MarkerDataManager.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 2/7/19.
//  Copyright © 2019 Liubov Fedorchuk. All rights reserved.
//

import Foundation

class MarkerDataManager {
    
    var codingTimeInPercentForWeeklyBreakdownOverActivityByDays = [String]()
    var buildingTimeInPercentForWeeklyBreakdownOverActivityByDays = [String]()
    var codingTimeForWeeklyBreakdownOverActivityByDay = [String]()
    var buildingTimeForWeeklyBreakdownOverActivityByDay = [String]()
    var daysOfGivenTimePeriodArray = [String]()
    var totalCodingActivityPerDay = [String]()
    var projectNameByDay = [Int: [String]]()
    var projectWorkingTimePerDay = [Int: [String]]()
}
