//
//  BalloonMarkerForCodingActivity.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 2/7/19.
//  Copyright © 2019 Liubov Fedorchuk. All rights reserved.
//

import Foundation
import Charts

public class BalloonMarkerForCodingActivity: BalloonMarker {
    var date: String
    var total: String
    var projectNameByDay: [String]
    var projectWorkingTimePerDay: [String]
    
    public init(color: UIColor,
                font: UIFont,
                textColor: UIColor,
                insets: UIEdgeInsets,
                date: String,
                total: String,
                projectNameByDay: [String],
                projectWorkingTimePerDay: [String]) {
        self.date = date
        self.total = total
        self.projectNameByDay = projectNameByDay
        self.projectWorkingTimePerDay = projectWorkingTimePerDay
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        var string = ""
        string = date
            + " \n"
            + "Total: "
            + total
            + "\n"
        for i in 0..<projectNameByDay.count {
            string.append(projectNameByDay[i] + ": ")
            string.append(projectWorkingTimePerDay[i] + "\n")
        }
        setLabel(string)
    }
}
