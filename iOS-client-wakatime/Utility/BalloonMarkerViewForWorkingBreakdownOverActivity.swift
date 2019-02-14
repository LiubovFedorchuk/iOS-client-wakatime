//
//  BalloonMarkerViewForWorkingBreakdownOverActivity.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 2/7/19.
//  Copyright © 2019 Liubov Fedorchuk. All rights reserved.
//

import Charts

public class BalloonMarkerForWorkingBreakdownOverActivity: BalloonMarker {
    var date: String
    var coding: String
    var building: String
    
    public init(color: UIColor,
                font: UIFont,
                textColor: UIColor,
                insets: UIEdgeInsets,
                date: String,
                coding: String,
                building: String) {
        self.date = date
        self.coding = coding
        self.building = building
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let string = date
            + "\n"
            + coding
            + building
        setLabel(string)
    }
}
