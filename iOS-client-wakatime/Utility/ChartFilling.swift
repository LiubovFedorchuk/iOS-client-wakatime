//
//  ChartFill.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 11/24/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Foundation
import Charts

class ChartFilling {
    let chartSetUp = ChartSetUp()
    
    //TODO: think about it
    var dataEntriesCoding: [BarChartDataEntry] = []
    var dataEntriesBuilding: [BarChartDataEntry] = []
    
    //TODO: rename variables (like itemList, etc.)
    func pieChartFilling(pieChartView: PieChartView, itemsList: [EntrySummary]) {
        var entryWorkingTimeItem = [PieChartDataEntry]()
        for item in itemsList {
            let dataEntry = PieChartDataEntry(value: Double(item.workingTimeInPercent!),
                                          label: "\(item.entryName!)")
            entryWorkingTimeItem.append(dataEntry)
            let dataSet = PieChartDataSet(values: entryWorkingTimeItem,
                                          label: "(\(String(describing: item.workingTimeInPercent!)) %)")
            dataSet.colors = ChartColorTemplates.material()
            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
        }
        if (entryWorkingTimeItem.count > 2) {
            pieChartView.drawEntryLabelsEnabled = false
        } else {
            pieChartView.drawEntryLabelsEnabled = true
        }
        
        chartSetUp.setUpPieChartView(pieChartView: pieChartView)
    }
    
    func horizontalBarChartFilling(horizontalBarChartView: HorizontalBarChartView,
                                workingTimeAsPercentage: [Double],
                                workingTimeAsPercentageAsString: [String]) {
        
        horizontalBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: workingTimeAsPercentageAsString)
        var dataEntries = [ChartDataEntry]()
        for i in 0..<workingTimeAsPercentage.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: workingTimeAsPercentage[i])
            dataEntries.append(dataEntry)
        }
        
        let dataSet = BarChartDataSet(values: dataEntries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.valueTextColor = UIColor.darkGray
        if(workingTimeAsPercentage.count == 1) {
            dataSet.colors = [UIColor(red: 60/255, green: 163/255, blue: 232/255, alpha: 1)]
        } else {
            dataSet.colors = [UIColor(red: 254/255, green: 211/255, blue: 121/255, alpha: 1),
                              UIColor(red: 60/255, green: 163/255, blue: 232/255, alpha: 1)]
        }
        
        let barChartData = BarChartData(dataSet: dataSet)
        horizontalBarChartView.data = barChartData
    
        chartSetUp.setUpHorizontalBarChartView(horizontalBarChartView: horizontalBarChartView)
    }
    
    //TODO: needed refactoring THIS function
    //add marker
    // or add labels with coding time for each project for selected date
    func combinedChartFilling(combinedChartView: CombinedChartView,
                           codingTimePerProjectsByDaysForBarChart: [[Double]],
                           projectNameArray: [String],
                           daysOfGivenTimePeriodArray: [String]) {
        var totalCodingTimePerDayForLineChartArray = [Double]()
        combinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: daysOfGivenTimePeriodArray)
        
        var dataEntriesCodingPerProjectsForBarChart: [ChartDataEntry] = []
        var dataEntriesTotalCodingTimeForLineChart: [ChartDataEntry] = []
        
        for i in 0..<daysOfGivenTimePeriodArray.count {
            var totalCodingTimeForProjectsPerDay = 0.0
            var yValuesForStackedBarChart = [Double]()
            for j in 0..<codingTimePerProjectsByDaysForBarChart.count {
                yValuesForStackedBarChart.append(codingTimePerProjectsByDaysForBarChart[j][i])
                totalCodingTimeForProjectsPerDay += codingTimePerProjectsByDaysForBarChart[j][i]
            }
            
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: yValuesForStackedBarChart)
            dataEntriesCodingPerProjectsForBarChart.append(dataEntry)
            totalCodingTimePerDayForLineChartArray.append(totalCodingTimeForProjectsPerDay)
            let dataEntryTotalCodingTime = ChartDataEntry(x: Double(i), y: totalCodingTimePerDayForLineChartArray[i])
            dataEntriesTotalCodingTimeForLineChart.append(dataEntryTotalCodingTime)
        }
        
        let barChartDataSet = BarChartDataSet(values: dataEntriesCodingPerProjectsForBarChart, label: "")
        barChartDataSet.stackLabels = projectNameArray
        setUpBarChart(barChartDataSet: barChartDataSet, colorsCount: projectNameArray.count)
        
        let lineDataSet = LineChartDataSet(values: dataEntriesTotalCodingTimeForLineChart, label: "daily activity")
        setUpLineChart(lineChartDataSet: lineDataSet)

        let data: CombinedChartData = CombinedChartData()
        data.barData = BarChartData(dataSets: [barChartDataSet])
        data.barData.barWidth = 1
        data.lineData = LineChartData(dataSets: [lineDataSet])
        combinedChartView.data = data
        chartSetUp.setUpCombinedChartView(combinedChartView: combinedChartView)
    }

    func setUpLineChart(lineChartDataSet: LineChartDataSet) {
        lineChartDataSet.setColor(UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.75))
        lineChartDataSet.setCircleColor(UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.75))
        lineChartDataSet.circleRadius = 3.5
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.drawValuesEnabled = true
        lineChartDataSet.valueFont = UIFont(name: "PingFangSC-Light", size: 10)!
        lineChartDataSet.valueTextColor = .lightGray
        lineChartDataSet.axisDependency = .left
    }

    func setUpBarChart(barChartDataSet: BarChartDataSet, colorsCount: Int) {
        var colors = [UIColor]()
        for i in 0..<colorsCount {
            colors.append(ChartColorTemplates.nerd()[i])
        }
        barChartDataSet.colors = colors
        barChartDataSet.drawValuesEnabled = false
        barChartDataSet.axisDependency = .left
        barChartDataSet.barBorderWidth = 0
    }
    
    func multipleBarChartFilling(multipleBarChartView: BarChartView,
                                  codingTimePerDay: [Double],
                                  buildingTimePerDay: [Double]?,
                                  daysOfGivenTimePeriodArray: [String]) {
        
        let groupCount = daysOfGivenTimePeriodArray.count
        multipleBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: daysOfGivenTimePeriodArray)
        
        if (codingTimePerDay.isEmpty == false && buildingTimePerDay != nil) {
//            var dataEntriesCoding: [BarChartDataEntry] = []
//            var dataEntriesBuilding: [BarChartDataEntry] = []
            
            for i in 0..<daysOfGivenTimePeriodArray.count {
                
                let dataEntryCoding = BarChartDataEntry(x: Double(i) , y: codingTimePerDay[i].rounded(toPlaces: 2))
                dataEntriesCoding.append(dataEntryCoding)
                
                let dataEntryBuilding = BarChartDataEntry(x: Double(i) , y: buildingTimePerDay![i].rounded(toPlaces: 2))
                dataEntriesBuilding.append(dataEntryBuilding)
            }
            
            self.setUpTotalWorkingOfMultipleBarChart(dataEntriesCoding: dataEntriesCoding,
                                                        dataEntriesBuilding: dataEntriesBuilding,
                                                        groupCount: groupCount,
                                                        multipleBarChartView: multipleBarChartView)
        } else {
//            var dataEntriesCoding: [BarChartDataEntry] = []
            for i in 0..<daysOfGivenTimePeriodArray.count {
                let dataEntry = BarChartDataEntry(x: Double(i) , y: codingTimePerDay[i])
                dataEntriesCoding.append(dataEntry)
            }
            self.setUpCodingPartOfMultipleBarChart(dataEntriesCoding: dataEntriesCoding,
                                                   multipleBarChartView: multipleBarChartView)
        }
        chartSetUp.setUpMultipleBarChartView(multipleBarChartView: multipleBarChartView)
    }
    
    func setUpCodingPartOfMultipleBarChart(dataEntriesCoding: [BarChartDataEntry],
                                               multipleBarChartView: BarChartView) {
        let dataSet = BarChartDataSet(values: dataEntriesCoding, label: "Coding ")
        dataSet.setColor(UIColor(red: 60/255, green: 163/255, blue: 232/255, alpha: 1))
        dataSet.valueTextColor = .lightGray
        let data = BarChartData(dataSet: dataSet)
        multipleBarChartView.xAxis.centerAxisLabelsEnabled = false
        multipleBarChartView.legend.xOffset = 67.0
        data.barWidth = 0.3
        multipleBarChartView.data = data
        multipleBarChartView.data?.highlightEnabled = true
    }
    
    func setUpTotalWorkingOfMultipleBarChart(dataEntriesCoding: [BarChartDataEntry],
                                            dataEntriesBuilding: [BarChartDataEntry],
                                            groupCount: Int,
                                            multipleBarChartView: BarChartView) {
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        let axisMin = 0
        
        let chartDataSetCoding = BarChartDataSet(values: dataEntriesCoding, label: "Coding ")
        let chartDataSetBuilding = BarChartDataSet(values: dataEntriesBuilding, label: "Building ")
        chartDataSetCoding.valueTextColor = .lightGray
        chartDataSetBuilding.valueTextColor = .lightGray
        chartDataSetCoding.setColor(UIColor(red: 60/255, green: 163/255, blue: 232/255, alpha: 1))
        chartDataSetBuilding.setColor(UIColor(red: 254/255, green: 211/255, blue: 121/255, alpha: 1))
        
        let dataSets: [BarChartDataSet] = [chartDataSetCoding, chartDataSetBuilding]
        let data = BarChartData(dataSets: dataSets)
        
        data.barWidth = barWidth
        let spaceIndividualGroupOfBarNeeds = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        multipleBarChartView.xAxis.axisMaximum = Double(axisMin) + spaceIndividualGroupOfBarNeeds * Double(groupCount)
        multipleBarChartView.xAxis.centerAxisLabelsEnabled = true
        multipleBarChartView.xAxis.axisMinimum = 0
        data.groupBars(fromX: Double(axisMin), groupSpace: groupSpace, barSpace: barSpace)
        multipleBarChartView.data = data
        multipleBarChartView.data?.highlightEnabled = true
    }

    //TODO: rename variables (like itemList, etc.)
    //split this function, move colors setting
    func halfPieChartFilling(halfPieChartView: PieChartView, itemsList: [Double]) {
        var entryWorkingTimeItem = [PieChartDataEntry]()
        for item in itemsList {
            let dataEntry = PieChartDataEntry(value: item,
                                          label: "")
            entryWorkingTimeItem.append(dataEntry)
            let dataSet = PieChartDataSet(values: entryWorkingTimeItem,
                                          label: "")
            if(itemsList.first! == 0) {
                dataSet.setColors(UIColor(red: 45/255, green: 53/255, blue: 60/255, alpha: 1))
            }
            else if (itemsList.first! < 30.0 && itemsList.first! > 0.0) {
                dataSet.colors = [UIColor(red: 214/255, green: 39/255, blue: 40/255, alpha: 1),
                                  UIColor(red: 45/255, green: 53/255, blue: 60/255, alpha: 1)]
            } else if (itemsList.first! >= 30.0 && itemsList.first! < 60.0) {
                dataSet.colors = [UIColor(red: 249/255, green: 118/255, blue: 0/255, alpha: 1),
                                  UIColor(red: 45/255, green: 53/255, blue: 60/255, alpha: 1)]
            } else if (itemsList.first! >= 60.0 && itemsList.first! < 90.0) {
                dataSet.colors = [UIColor(red: 246/255, green: 198/255, blue: 0/255, alpha: 1),
                                  UIColor(red: 45/255, green: 53/255, blue: 60/255, alpha: 1)]
            } else if (itemsList.first! >= 90.0) {
                dataSet.colors = [UIColor(red: 96/255, green: 176/255, blue: 68/255, alpha: 1),
                                  UIColor(red: 45/255, green: 53/255, blue: 60/255, alpha: 1)]
            }
            dataSet.drawValuesEnabled = false
            let data = PieChartData(dataSet: dataSet)
            halfPieChartView.data = data
        }
        halfPieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        chartSetUp.setUpHalfPieChartView(halfPieChartView: halfPieChartView)
    }
}
