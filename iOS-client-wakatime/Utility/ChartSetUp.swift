//
//  ChartSetUp.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10.08.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Charts

class ChartSetUp {

    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.positiveSuffix = " hrs"
        
        return formatter
    }()
    
    func setUpPieChartView(pieChartView: PieChartView) {
        pieChartView.drawHoleEnabled = false
        pieChartView.chartDescription?.enabled = false
        pieChartView.isUserInteractionEnabled = true
        pieChartView.noDataText = "No chart data available."
        pieChartView.noDataTextColor = UIColor(red: 123/255,
                                               green: 128/255,
                                               blue: 131/255,
                                               alpha: 1)
        pieChartView.backgroundColor = UIColor(red: 45/255,
                                               green: 53/255,
                                               blue: 60/255,
                                               alpha: 1)
        pieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        pieChartView.notifyDataSetChanged()
        
        let legend = pieChartView.legend
        legend.font = UIFont(name: "PingFangSC-Light", size: 12)!
        legend.textColor = UIColor(red: 123/255,
                                   green: 128/255,
                                   blue: 131/255,
                                   alpha: 1)
        legend.orientation = .horizontal
        legend.verticalAlignment = .bottom
        legend.horizontalAlignment = .left
    }
    
    func setUpHalfPieChartView(halfPieChartView: PieChartView) {
        halfPieChartView.maxAngle = 180
        halfPieChartView.rotationAngle = 180
        halfPieChartView.holeRadiusPercent = 0.6
        halfPieChartView.rotationEnabled = false
        halfPieChartView.legend.enabled = false
        halfPieChartView.drawEntryLabelsEnabled = false
        halfPieChartView.chartDescription?.enabled = false
        halfPieChartView.noDataText = "No chart data available."
        halfPieChartView.isUserInteractionEnabled = true
        halfPieChartView.backgroundColor = UIColor(red: 45/255,
                                                   green: 53/255,
                                                   blue: 60/255,
                                                   alpha: 1)
        halfPieChartView.holeColor = halfPieChartView.backgroundColor
        halfPieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        halfPieChartView.notifyDataSetChanged()
    }
    
    func setUpHorizontalBarChartView(horizontalBarChartView: HorizontalBarChartView) {
        horizontalBarChartView.noDataText = "No chart data available."
        horizontalBarChartView.noDataTextColor = UIColor(red: 123/255,
                                                         green: 128/255,
                                                         blue: 131/255,
                                                         alpha: 1)
        horizontalBarChartView.backgroundColor = UIColor(red: 45/255,
                                                         green: 53/255,
                                                         blue: 60/255,
                                                         alpha: 1)
        horizontalBarChartView.legend.enabled = false
        horizontalBarChartView.leftAxis.enabled = false
        horizontalBarChartView.rightAxis.enabled = false
        horizontalBarChartView.drawBarShadowEnabled = false
        horizontalBarChartView.drawGridBackgroundEnabled = false
        horizontalBarChartView.chartDescription?.enabled = false
        horizontalBarChartView.isUserInteractionEnabled = true
        horizontalBarChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        horizontalBarChartView.notifyDataSetChanged()
        horizontalBarChartView.setExtraOffsets(left: 65, top: 65, right: 0, bottom: 65)
        
        let xAxis = horizontalBarChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.labelPosition = .top
        xAxis.granularity = 1
        xAxis.labelTextColor = .lightGray
    }
    
    func setUpMultipleBarChartView(multipleBarChartView: BarChartView) {
        multipleBarChartView.noDataText = "No chart data available."
        multipleBarChartView.drawBarShadowEnabled = false
        multipleBarChartView.highlightFullBarEnabled = false
        multipleBarChartView.drawGridBackgroundEnabled = false
        multipleBarChartView.chartDescription?.enabled = false
        multipleBarChartView.drawMarkers = true
        multipleBarChartView.isUserInteractionEnabled = true
        multipleBarChartView.extraBottomOffset = 10
        multipleBarChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        multipleBarChartView.notifyDataSetChanged()
        
        multipleBarChartView.noDataTextColor = UIColor(red: 123/255,
                                                    green: 128/255,
                                                    blue: 131/255,
                                                    alpha: 1)
        multipleBarChartView.backgroundColor = UIColor(red: 45/255,
                                                    green: 53/255,
                                                    blue: 60/255,
                                                    alpha: 1)
        let legend = multipleBarChartView.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.textColor = .lightGray
        legend.font = UIFont(name: "PingFangSC-Light", size: 11)!
        legend.yOffset = 3
        legend.xOffset = 119
        legend.xEntrySpace = 90
        
        let xAxis = multipleBarChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "PingFangSC-Light", size: 10)!
        xAxis.labelTextColor = .lightGray
        xAxis.labelCount = 7
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        
        let leftAxis = multipleBarChartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
        leftAxis.labelCount = 6
        leftAxis.labelFont = UIFont(name: "PingFangSC-Light", size: 10)!
        leftAxis.labelTextColor = .lightGray
        leftAxis.drawGridLinesEnabled = false
        
        let rightAxis = multipleBarChartView.rightAxis
        rightAxis.axisMinimum = 0
        rightAxis.drawZeroLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawTopYLabelEntryEnabled = false
        rightAxis.drawBottomYLabelEntryEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = false
    }
    
    func setUpCombinedChartView(combinedChartView: CombinedChartView) {
        combinedChartView.noDataText = "No chart data available."
        combinedChartView.noDataTextColor = UIColor(red: 123/255,
                                                    green: 128/255,
                                                    blue: 131/255,
                                                    alpha: 1)
        combinedChartView.backgroundColor = UIColor(red: 45/255,
                                                    green: 53/255,
                                                    blue: 60/255,
                                                    alpha: 1)
        combinedChartView.chartDescription?.enabled = false
        combinedChartView.drawBarShadowEnabled = false
        combinedChartView.highlightFullBarEnabled = false
        combinedChartView.drawOrder = [DrawOrder.bar.rawValue, DrawOrder.line.rawValue]
        combinedChartView.setExtraOffsets(left: 20, top: 0, right: 20, bottom: 0)
        combinedChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        combinedChartView.notifyDataSetChanged()
        
        let legend = combinedChartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.textColor = .lightGray
        legend.font = UIFont(name: "PingFangSC-Light", size: 11)!
        
        let rightAxis = combinedChartView.rightAxis
        rightAxis.axisMinimum = 0
        rightAxis.drawZeroLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawTopYLabelEntryEnabled = false
        rightAxis.drawBottomYLabelEntryEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = false
        
        let leftAxis = combinedChartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawGridLinesEnabled = false

        let xAxis = combinedChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "PingFangSC-Light", size: 10)!
        xAxis.labelTextColor = .lightGray
        xAxis.labelCount = 7
        xAxis.granularity = 1
    }
}
