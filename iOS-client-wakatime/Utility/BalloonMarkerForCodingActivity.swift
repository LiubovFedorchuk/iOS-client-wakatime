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
    
    public init(color: UIColor,
                font: UIFont,
                textColor: UIColor,
                insets: UIEdgeInsets,
                date: String) {
        self.date = date
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let string = date
            + " \n"
        setLabel(string)
    }
}
