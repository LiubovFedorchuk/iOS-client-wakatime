//
//  ChartSetUp.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10.08.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartSetUp {

    func setUpPieChartView(pieChartView: PieChartView) {
        pieChartView.chartDescription?.enabled = false
        pieChartView.drawHoleEnabled = false
        pieChartView.noDataText = "No chart data available."
        pieChartView.noDataTextColor = UIColor(red: 123.0/255.0,
                                               green: 128.0/255.0,
                                               blue: 131.0/255.0,
                                               alpha: 1.0)
        pieChartView.isUserInteractionEnabled = true
        pieChartView.backgroundColor = UIColor(red: 45.0/255.0,
                                               green: 53.0/255.0,
                                               blue: 60.0/255.0,
                                               alpha: 1.0);
        pieChartView.legend.textColor = UIColor(red: 123.0/255.0,
                                                green: 128.0/255.0,
                                                blue: 131.0/255.0,
                                                alpha: 1.0);
        pieChartView.legend.font = UIFont(name: "PingFangSC-Light", size: 12)!
        pieChartView.legend.orientation = .horizontal
        pieChartView.legend.verticalAlignment = .bottom
        pieChartView.legend.horizontalAlignment = .left
        pieChartView.notifyDataSetChanged()
    }
    
    func setUpHalfPieChartView(halfPieChartView: PieChartView) {
        halfPieChartView.maxAngle = 180
        halfPieChartView.rotationAngle = 180
        halfPieChartView.rotationEnabled = false
        halfPieChartView.chartDescription?.enabled = false
        halfPieChartView.legend.enabled = false
        halfPieChartView.noDataText = ""
        halfPieChartView.isUserInteractionEnabled = true
        halfPieChartView.backgroundColor = UIColor(red: 45.0/255.0,
                                                   green: 53.0/255.0,
                                                   blue: 60.0/255.0,
                                                   alpha: 1.0)
        halfPieChartView.holeColor = UIColor(red: 45.0/255.0,
                                             green: 53.0/255.0,
                                             blue: 60.0/255.0,
                                             alpha: 1.0)
        halfPieChartView.holeRadiusPercent = 0.6
        halfPieChartView.drawEntryLabelsEnabled = false
        halfPieChartView.notifyDataSetChanged()
    }
    
    func setUpHorizontalBarChartView(horizontalBarChartView: HorizontalBarChartView) {
        horizontalBarChartView.noDataText = "No chart data available."
        horizontalBarChartView.noDataTextColor = UIColor(red: 123.0/255.0,
                                                        green: 128.0/255.0,
                                                        blue: 131.0/255.0,
                                                        alpha: 1.0)
        horizontalBarChartView.backgroundColor = UIColor(red: 45.0/255.0,
                                                         green: 53.0/255.0,
                                                         blue: 60.0/255.0,
                                                         alpha: 1.0)
        horizontalBarChartView.legend.enabled = false
        horizontalBarChartView.drawBarShadowEnabled = false
        horizontalBarChartView.chartDescription?.enabled = false
        horizontalBarChartView.isUserInteractionEnabled = true
        horizontalBarChartView.drawGridBackgroundEnabled = false
        
        horizontalBarChartView.leftAxis.enabled = false
        horizontalBarChartView.rightAxis.enabled = false
        horizontalBarChartView.xAxis.drawGridLinesEnabled = false
        horizontalBarChartView.xAxis.drawAxisLineEnabled = false
        
        horizontalBarChartView.leftAxis.axisMinimum = 0.0
        horizontalBarChartView.rightAxis.axisMinimum = 0.0
        horizontalBarChartView.xAxis.labelPosition = .top
        horizontalBarChartView.xAxis.granularityEnabled = true
        horizontalBarChartView.xAxis.granularity = 1
        horizontalBarChartView.xAxis.labelTextColor = .lightGray
        
        horizontalBarChartView.setExtraOffsets(left: 65.0, top: 85.0, right: 0.0, bottom: 85.0)
        
    }
    
    func setUpCombinedChartView(combinedChartView: CombinedChartView) {
        combinedChartView.noDataText = "No chart data available."
        combinedChartView.noDataTextColor = UIColor(red: 123.0/255.0,
                                                    green: 128.0/255.0,
                                                    blue: 131.0/255.0,
                                                    alpha: 1.0)
        combinedChartView.backgroundColor = UIColor(red: 45.0/255.0,
                                                    green: 53.0/255.0,
                                                    blue: 60.0/255.0,
                                                    alpha: 1.0)
        combinedChartView.chartDescription?.enabled = false
        combinedChartView.drawBarShadowEnabled = false
        combinedChartView.highlightFullBarEnabled = false
        combinedChartView.drawOrder = [DrawOrder.bar.rawValue, DrawOrder.line.rawValue];
        
        let l = combinedChartView.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let rightAxis = combinedChartView.rightAxis
        rightAxis.axisMinimum = 0
        
        let leftAxis = combinedChartView.leftAxis
        leftAxis.axisMinimum = 0
        
        let xAxis = combinedChartView.xAxis
        xAxis.labelPosition = .bothSided
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
    }
}
