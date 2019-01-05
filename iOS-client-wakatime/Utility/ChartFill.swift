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
    
 
    
    func horizontalBarChartFill(horizontalBarChartView: HorizontalBarChartView) {
        
        let values = [100]
        let labels = ["100%"]
        
        horizontalBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        
        var dataEntries = [ChartDataEntry]()
        
        for i in 0..<values.count {
            let entry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(entry)
        }
        
        let dataSet = BarChartDataSet(values: dataEntries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.valueTextColor = UIColor.darkGray
        dataSet.colors = [UIColor(red: 60.0/255.0, green: 163.0/255.0, blue: 232.0/255.0, alpha: 1.0),
                          UIColor(red: 254.0/255.0, green: 211.0/255.0, blue: 121.0/255.0, alpha: 1.0)]
        let barChartData = BarChartData(dataSet: dataSet)
        horizontalBarChartView.data = barChartData
        chartSetUp.setUpHorizontalBarChartView(horizontalBarChartView: horizontalBarChartView)
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
        chartSetUp.setUpHalfPieChartView(halfPieChartView: halfPieChartView)
    }
    
    func combinedChartFill(combinedChartView: CombinedChartView) {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        
        combinedChartView.xAxis.axisMaximum = data.xMax + 0.25
        combinedChartView.data = data
        
        chartSetUp.setUpCombinedChartView(combinedChartView: combinedChartView);
    }
    
    func generateLineData() -> LineChartData {
        let entries = (0..<12).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i) + 0.5, y: Double(arc4random_uniform(15) + 5))
        }
        
        let set = LineChartDataSet(values: entries, label: "Line DataSet")
        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 10)
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateBarData() -> BarChartData {
        let entries1 = (0..<12).map { _ -> BarChartDataEntry in
            return BarChartDataEntry(x: 0, y: Double(arc4random_uniform(25) + 25))
        }
        let entries2 = (0..<12).map { _ -> BarChartDataEntry in
            return BarChartDataEntry(x: 0, yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)])
        }
        
        let set1 = BarChartDataSet(values: entries1, label: "Bar 1")
        set1.setColor(UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1))
        set1.valueTextColor = UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1)
        set1.valueFont = .systemFont(ofSize: 10)
        set1.axisDependency = .left
        
        let set2 = BarChartDataSet(values: entries2, label: "")
        set2.stackLabels = ["Stack 1", "Stack 2"]
        set2.colors = [UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1),
                       UIColor(red: 23/255, green: 197/255, blue: 255/255, alpha: 1)
        ]
        set2.valueTextColor = UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1)
        set2.valueFont = .systemFont(ofSize: 10)
        set2.axisDependency = .left
        
        let groupSpace = 0.06
        let barSpace = 0.02 // x2 dataset
        let barWidth = 0.45 // x2 dataset
        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
        
        let data = BarChartData(dataSets: [set1, set2])
        data.barWidth = barWidth
        
        // make this BarData object grouped
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        return data
    }
}

extension BarChartView {
    
    class BarChartFormatter: IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
    }
}
