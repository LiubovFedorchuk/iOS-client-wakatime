//
//  ChartFill.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 11/24/18.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Foundation
import Charts

class ChartFill {
    let chartSetUp = ChartSetUp()
    
    func pieChartFill(pieChartView: PieChartView, itemsList: [EntrySummary]) {
        var entryWorkingTimeItem = [PieChartDataEntry]()
        for item in itemsList {
            let entry = PieChartDataEntry(value: Double(item.workingTimeInPercent!),
                                          label: "\(item.entryName!)")
            entryWorkingTimeItem.append(entry)
            let dataSet = PieChartDataSet(values: entryWorkingTimeItem,
                                          label: "(\(String(describing: item.workingTimeInPercent!)) %)")
            dataSet.colors = ChartColorTemplates.material()
            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
        }
        if (entryWorkingTimeItem.count > 2) {
            pieChartView.drawEntryLabelsEnabled = false
        }
        
        chartSetUp.setUpPieChartView(pieChartView: pieChartView)
    }
    
    func horizontalBarChartFill(horizontalBarChartView: HorizontalBarChartView,
                                workingTimeAsPercentage: [Double],
                                workingTimeAsPercentageAsString: [String]) {
        
        horizontalBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: workingTimeAsPercentageAsString)
        var dataEntries = [ChartDataEntry]()
        for i in 0..<workingTimeAsPercentage.count {
            let entry = BarChartDataEntry(x: Double(i), y: workingTimeAsPercentage[i])
            dataEntries.append(entry)
        }
        
        let dataSet = BarChartDataSet(values: dataEntries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.valueTextColor = UIColor.darkGray
        if(workingTimeAsPercentage.count == 1) {
            dataSet.colors = [UIColor(red: 60/255, green: 163/255, blue: 232/255, alpha: 1.0)]
        } else {
            dataSet.colors = [UIColor(red: 254/255, green: 211/255, blue: 121/255, alpha: 1.0),
                              UIColor(red: 60/255, green: 163/255, blue: 232/255, alpha: 1.0)]
        }
        
        let barChartData = BarChartData(dataSet: dataSet)
        horizontalBarChartView.data = barChartData
    
        chartSetUp.setUpHorizontalBarChartView(horizontalBarChartView: horizontalBarChartView)
    }
    
    func combinedChartFill(combinedChartView: CombinedChartView) {
        let daysOfTheWeekArray = ["13 Jan", "14 Jan", "15 Jan", "16 Jan", "17 Jan", "18 Jan", "19 Jan"]
//        let yValuesLineChart = [2.1, 3.3, 4.0, 1.0, 0.25, 4.5, 3.2]
        var yValuesLineChart = [Double]()
        let yValuesBarChart = [2.1, 3.3, 4.0, 1.0, 0.25, 4.5, 3.2]
        //before request is not active we don`t really know how many this arrays can exist
        let yValuesBarChart2 = [0.1, 1.3, 0.0, 0.2, 1.25, 2.25, 1.3]

        combinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: daysOfTheWeekArray)
        var dataEntriesCodingByProjectsForBarChart: [BarChartDataEntry] = []
        var dataEntriesTotalCodingTimeForLineChart: [ChartDataEntry] = []
        
        var dataEntriesCodingByProjectsForBarChart2: [BarChartDataEntry] = []
        for i in 0..<daysOfTheWeekArray.count {

            
//            let dataEntryCoding = BarChartDataEntry(x: Double(i) , y: yValuesBarChart[i])
//            dataEntriesCodingByProjectsForBarChart.append(dataEntryCoding)


            
            let dataEntryProject = BarChartDataEntry(x: Double(i), yValues:[yValuesBarChart[i], yValuesBarChart2[i]])
            let sum = yValuesBarChart[i] + yValuesBarChart2[i]
//            if(abs(yValuesBarChart[i] - yValuesBarChart2[i]) >= 0.6) {
//                yValuesLineChart.append(sum - 0.6 + 1)
//
//            } else {
                yValuesLineChart.append(sum)
//            }
//            if(yValuesBarChart[i] > yValuesBarChart2[i]) {
            
//            } else {
//                yValuesLineChart.append(yValuesBarChart2[i])
//            }
            dataEntriesCodingByProjectsForBarChart2.append(dataEntryProject)
            let dataEntryTotalCodingTime = ChartDataEntry(x: Double(i), y: yValuesLineChart[i])
            dataEntriesTotalCodingTimeForLineChart.append(dataEntryTotalCodingTime)
        }
        let lineDataSet = LineChartDataSet(values: dataEntriesTotalCodingTimeForLineChart, label: "total line")
        setUpLineChart(lineChartDataSet: lineDataSet)
//        let barDataSet = BarChartDataSet(values: dataEntriesCodingByProjectsForBarChart, label: "ios-client-wakatime")
        
        let barChartDataSet2 = BarChartDataSet(values: dataEntriesCodingByProjectsForBarChart2, label: "")
        barChartDataSet2.stackLabels = ["azaza", "tmp"]
        barChartDataSet2.colors =  [UIColor.darkGray, UIColor.lightGray]
        barChartDataSet2.drawValuesEnabled = false
//        setUpBarChart(barChartDataSet: barDataSet)
//        setUpBarChartTMP(barChartDataSet2: barChartDataSet2)
        
        let data: CombinedChartData = CombinedChartData()
        data.barData = BarChartData(dataSets: [barChartDataSet2])
        data.barData.barWidth = 1
        data.lineData = LineChartData(dataSets: [lineDataSet])
        combinedChartView.data = data
        chartSetUp.setUpCombinedChartView(combinedChartView: combinedChartView)
    }

    func setUpLineChart(lineChartDataSet: LineChartDataSet) {
        lineChartDataSet.setColor(UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.75))
//        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.setCircleColor(UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.75))
        lineChartDataSet.circleRadius = 3.5
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
//        lineChartDataSet.circleHoleRadius = 2.5
//        lineChartDataSet.fillColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.drawValuesEnabled = true
        lineChartDataSet.valueFont = UIFont(name: "PingFangSC-Light", size: 10)!
        lineChartDataSet.valueTextColor = .lightGray
        lineChartDataSet.axisDependency = .left
    }

    func setUpBarChart(barChartDataSet: BarChartDataSet) {
        barChartDataSet.setColor(UIColor(red: 60/255, green: 163/255, blue: 232/255, alpha: 0.35))
        barChartDataSet.valueTextColor = .lightGray
        barChartDataSet.barBorderColor = UIColor(red: 60/255, green: 163/255, blue: 232/255, alpha: 1.0)
        barChartDataSet.barBorderWidth = 1
        barChartDataSet.drawValuesEnabled = false
    }
    
//    func setUpBarChartTMP(barChartDataSet2: BarChartDataSet) {
//
////        barChartDataSet2.stackLabels = ["Stack 1", "Stack 2", "Stack 3","Stack 4"]
//        barChartDataSet2.colors = [UIColor(red: 96/255, green: 176/255, blue: 68/255, alpha: 0.35),
//                       UIColor(red: 246/255, green: 198/255, blue: 0/255, alpha: 0.35)]
//        barChartDataSet2.drawValuesEnabled = false
//        barChartDataSet2.axisDependency = .left
//        barChartDataSet2.barBorderColor = UIColor(red: 60/255, green: 163/255, blue: 232/255, alpha: 1.0)
//        barChartDataSet2.barBorderWidth = 1
//    }
    
    
//    func combinedChartFill(combinedChartView: CombinedChartView) {
//        let data = CombinedChartData()
//        data.lineData = generateLineData()
//        data.barData = generateBarData()
//
//        combinedChartView.xAxis.axisMaximum = data.xMax + 0.25
//        combinedChartView.data = data
//
//        chartSetUp.setUpCombinedChartView(combinedChartView: combinedChartView)
//    }
//
//    func generateLineData() -> LineChartData {
//        let entries = (0..<12).map { (i) -> ChartDataEntry in
//            return ChartDataEntry(x: Double(i) + 0.5, y: Double(arc4random_uniform(15) + 5))
//        }
//
//        let set = LineChartDataSet(values: entries, label: "Line DataSet")
//        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
//        set.lineWidth = 2.5
//        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
//        set.circleRadius = 5
//        set.circleHoleRadius = 2.5
//        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
//        set.mode = .cubicBezier
//        set.drawValuesEnabled = true
//        set.valueFont = .systemFont(ofSize: 10)
//        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
//
//        set.axisDependency = .left
//
//        return LineChartData(dataSet: set)
//    }
//
//
//    func generateBarData() -> BarChartData {
//        let entries1 = (0..<12).map { _ -> BarChartDataEntry in
//            return BarChartDataEntry(x: 0, y: Double(arc4random_uniform(25) + 25))
//        }
//        let entries2 = (0..<12).map { _ -> BarChartDataEntry in
//            return BarChartDataEntry(x: 0, yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)])
//        }
//
//        let set1 = BarChartDataSet(values: entries1, label: "Bar 1")
//        set1.setColor(UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1))
//        set1.valueTextColor = UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1)
//        set1.valueFont = .systemFont(ofSize: 10)
//        set1.axisDependency = .left
//
//        let set2 = BarChartDataSet(values: entries2, label: "")
//        set2.stackLabels = ["Stack 1", "Stack 2"]
//        set2.colors = [UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1),
//                       UIColor(red: 23/255, green: 197/255, blue: 255/255, alpha: 1)
//        ]
//        set2.valueTextColor = UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1)
//        set2.valueFont = .systemFont(ofSize: 10)
//        set2.axisDependency = .left
//
//        let groupSpace = 0.06
//        let barSpace = 0.02 // x2 dataset
//        let barWidth = 0.45 // x2 dataset
//        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
//
//        let data = BarChartData(dataSets: [set1, set2])
//        data.barWidth = barWidth
//
//        // make this BarData object grouped
//        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
//
//        return data
//    }
    
    func multipleBarChartViewFill(multipleBarChartView: BarChartView, codingTimePerDay: [Double], buildingTimePerDay: [Double]?, daysOfTheWeekArray: [String]) {
        let groupCount = daysOfTheWeekArray.count
        multipleBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: daysOfTheWeekArray)
        if (codingTimePerDay.isEmpty == false && buildingTimePerDay != nil) {
            var dataEntriesCoding: [BarChartDataEntry] = []
            var dataEntriesBuilding: [BarChartDataEntry] = []
            
            for i in 0..<daysOfTheWeekArray.count {
                
                let dataEntryCoding = BarChartDataEntry(x: Double(i) , y: codingTimePerDay[i].rounded(toPlaces: 2))
                dataEntriesCoding.append(dataEntryCoding)
                
                let dataEntryBuilding = BarChartDataEntry(x: Double(i) , y: buildingTimePerDay![i].rounded(toPlaces: 2))
                dataEntriesBuilding.append(dataEntryBuilding)
            }
            
            self.setUpWorkingPartOfMultipleBarChartView(dataEntriesCoding: dataEntriesCoding, dataEntriesBuilding: dataEntriesBuilding, groupCount: groupCount, multipleBarChartView: multipleBarChartView)
            
        } else {
            var dataEntriesCoding: [BarChartDataEntry] = []
            for i in 0..<daysOfTheWeekArray.count {
                let dataEntry = BarChartDataEntry(x: Double(i) , y: codingTimePerDay[i])
                dataEntriesCoding.append(dataEntry)
            }
            self.setUpCodingPartOfMultipleBarChartView(dataEntriesCoding: dataEntriesCoding, multipleBarChartView: multipleBarChartView)
        }
        chartSetUp.setUpMultipleBarChartView(multipleBarChartView: multipleBarChartView)
    }
    
    func setUpCodingPartOfMultipleBarChartView(dataEntriesCoding: [BarChartDataEntry],
                                               multipleBarChartView: BarChartView) {
        let dataSet = BarChartDataSet(values: dataEntriesCoding, label: "Coding ")
        dataSet.setColor(UIColor(red: 60.0/255.0, green: 163.0/255.0, blue: 232.0/255.0, alpha: 1.0))
        dataSet.valueTextColor = .lightGray
        let data = BarChartData(dataSet: dataSet)
        multipleBarChartView.xAxis.centerAxisLabelsEnabled = false
        multipleBarChartView.legend.xOffset = 67.0
        addBalloonMarkerOnMultipleBarChartView(multipleBarChartView: multipleBarChartView)
        data.barWidth = 0.3
        multipleBarChartView.data = data
        multipleBarChartView.data?.highlightEnabled = true
    }
    
    func setUpWorkingPartOfMultipleBarChartView(dataEntriesCoding: [BarChartDataEntry],
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
        chartDataSetCoding.setColor(UIColor(red: 60.0/255.0, green: 163.0/255.0, blue: 232.0/255.0, alpha: 1.0))
        chartDataSetBuilding.setColor(UIColor(red: 254.0/255.0, green: 211.0/255.0, blue: 121.0/255.0, alpha: 1.0))
        
        let dataSets: [BarChartDataSet] = [chartDataSetCoding, chartDataSetBuilding]
        let data = BarChartData(dataSets: dataSets)
        addBalloonMarkerOnMultipleBarChartView(multipleBarChartView: multipleBarChartView)
        data.barWidth = barWidth
        let gg = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        multipleBarChartView.xAxis.axisMaximum = Double(axisMin) + gg * Double(groupCount)
        multipleBarChartView.xAxis.centerAxisLabelsEnabled = true
        multipleBarChartView.xAxis.axisMinimum = 0
        data.groupBars(fromX: Double(axisMin), groupSpace: groupSpace, barSpace: barSpace)
        multipleBarChartView.data = data
        multipleBarChartView.data?.highlightEnabled = true
    }
    
    func addBalloonMarkerOnMultipleBarChartView(multipleBarChartView: BarChartView) {
        let marker : BalloonMarker = BalloonMarker(color: UIColor.darkGray.withAlphaComponent(0.6), font: UIFont(name: "PingFangSC-Light", size: 11)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0))
        marker.minimumSize = CGSize(width: CGFloat(60.0), height: CGFloat(35.0))
        multipleBarChartView.marker = marker
    }

    func halfPieChartFill(halfPieChartView: PieChartView, itemsList: [Double]) {
        var entryWorkingTimeItem = [PieChartDataEntry]()
        for item in itemsList {
            let entry = PieChartDataEntry(value: item,
                                          label: "")
            entryWorkingTimeItem.append(entry)
            let dataSet = PieChartDataSet(values: entryWorkingTimeItem,
                                          label: "")
            if(itemsList.first! == 0) {
                dataSet.setColors(UIColor(red: 45.0/255.0, green: 53.0/255.0, blue: 60.0/255.0, alpha: 1.0))
            }
            else if (itemsList.first! < 30.0 && itemsList.first! > 0.0) {
                dataSet.colors = [UIColor(red: 214.0/255.0, green: 39.0/255.0, blue: 40.0/255.0, alpha: 1.0),
                                  UIColor(red: 45.0/255.0, green: 53.0/255.0, blue: 60.0/255.0, alpha: 1.0)]
            } else if (itemsList.first! >= 30.0 && itemsList.first! < 60.0) {
                dataSet.colors = [UIColor(red: 249.0/255.0, green: 118.0/255.0, blue: 0.0/255.0, alpha: 1.0),
                                  UIColor(red: 45.0/255.0, green: 53.0/255.0, blue: 60.0/255.0, alpha: 1.0)]
            } else if (itemsList.first! >= 60.0 && itemsList.first! < 90.0) {
                dataSet.colors = [UIColor(red: 246.0/255.0, green: 198.0/255.0, blue: 0.0/255.0, alpha: 1.0),
                                  UIColor(red: 45.0/255.0, green: 53.0/255.0, blue: 60.0/255.0, alpha: 1.0)]
            } else if (itemsList.first! >= 90) {
                dataSet.colors = [UIColor(red: 96.0/255.0, green: 176.0/255.0, blue: 68.0/255.0, alpha: 1.0),
                                  UIColor(red: 45.0/255.0, green: 53.0/255.0, blue: 60.0/255.0, alpha: 1.0)]
            }
            dataSet.drawValuesEnabled = false
            let data = PieChartData(dataSet: dataSet)
            halfPieChartView.data = data
        }
        halfPieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        chartSetUp.setUpHalfPieChartView(halfPieChartView: halfPieChartView)
    }
}
