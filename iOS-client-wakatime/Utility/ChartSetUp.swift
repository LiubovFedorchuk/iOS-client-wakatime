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
        pieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
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
        halfPieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
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
        horizontalBarChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        horizontalBarChartView.notifyDataSetChanged()
        
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
        
        horizontalBarChartView.setExtraOffsets(left: 65.0, top: 65.0, right: 0.0, bottom: 65.0)
    }
    
    func setUpMultipleBarChartView(multipleBarChartView: BarChartView) {
        multipleBarChartView.noDataText = "No chart data available."
        multipleBarChartView.rightAxis.enabled = false
        multipleBarChartView.chartDescription?.enabled = false
        multipleBarChartView.drawBarShadowEnabled = false
        multipleBarChartView.highlightFullBarEnabled = false
        multipleBarChartView.drawGridBackgroundEnabled = false
        multipleBarChartView.isUserInteractionEnabled = true
        multipleBarChartView.drawMarkers = true
        multipleBarChartView.extraBottomOffset = 10
        multipleBarChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        multipleBarChartView.notifyDataSetChanged()
        
        multipleBarChartView.noDataTextColor = UIColor(red: 123.0/255.0,
                                                    green: 128.0/255.0,
                                                    blue: 131.0/255.0,
                                                    alpha: 1.0)
        multipleBarChartView.backgroundColor = UIColor(red: 45.0/255.0,
                                                    green: 53.0/255.0,
                                                    blue: 60.0/255.0,
                                                    alpha: 1.0)
        let legend = multipleBarChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.textColor = .lightGray
        legend.font = UIFont(name: "PingFangSC-Light", size: 11)!
        legend.yOffset = 3.0
        legend.xOffset = 119.0
        legend.xEntrySpace = 90.0
        
        let xAxis = multipleBarChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "PingFangSC-Light", size: 10)!
        xAxis.labelTextColor = .lightGray
        xAxis.labelCount = 7
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 2
        
        let leftAxis = multipleBarChartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.axisMinimum = 0
        leftAxis.labelCount = 6
        leftAxis.labelFont = UIFont(name: "PingFangSC-Light", size: 10)!
        leftAxis.labelTextColor = .lightGray
        leftAxis.drawGridLinesEnabled = false
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
        combinedChartView.rightAxis.enabled = false
        combinedChartView.leftAxis.enabled = false
//        combinedChartView.extraTopOffset = 10
        combinedChartView.drawOrder = [DrawOrder.bar.rawValue, DrawOrder.line.rawValue]
        combinedChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        combinedChartView.notifyDataSetChanged()
        
        let legend = combinedChartView.legend
        legend.enabled = true
//        legend.wordWrapEnabled = true
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.textColor = .lightGray
        legend.font = UIFont(name: "PingFangSC-Light", size: 11)!
        
//        let leftAxis = combinedChartView.leftAxis
//        leftAxis.axisMinimum = 0
        
        let xAxis = combinedChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "PingFangSC-Light", size: 10)!
        xAxis.labelTextColor = .lightGray
        xAxis.labelCount = 7
        xAxis.axisMinimum = 0
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
//        xAxis.xOffset = 10
//        xAxis.yOffset = 10
//        xAxis.centerAxisLabelsEnabled = true
    }
}
