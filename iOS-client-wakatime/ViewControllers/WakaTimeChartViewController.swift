//
//  WakaTimeChartViewController.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 23.01.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Charts

class WakaTimeChartViewController: UIViewController {
    
    lazy var dateManager = DateManager()
    let statisticController = StatisticController()
    let summaryController = SummaryController()
    let chartSetUp = ChartSetUp()
    let alertSetUp = AlertSetUp()
    var isAuthenticated = false
    
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]

    @IBOutlet weak var todayChangesOfWorkingProgress: UILabel!
    @IBOutlet weak var todayWorkingProgressInPercent: UILabel!
    @IBOutlet weak var todayWorkingTimeLabel: UILabel!
    @IBOutlet weak var dailyAverageTimeLabel: UILabel!
    @IBOutlet weak var timeOfCodingLast7DaysLabel: UILabel!
    @IBOutlet weak var editorPieChartView: PieChartView!
    @IBOutlet weak var languagePieChartView: PieChartView!
    @IBOutlet weak var operatingSystemPieChartView: PieChartView!
    @IBOutlet weak var codingActivityCombinedChartView: CombinedChartView!
    @IBOutlet weak var codingDailyAverageHalfPieChartView: PieChartView!
    @IBOutlet weak var codingActivityCurrentlyHorizontalBarChartView: HorizontalBarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Connectivity.isConnectedToInternet {
            let alert = alertSetUp.showAlert(alertTitle: "No Internet Conection", alertMessage: "Turn on cellural data or use Wi-Fi to access data.")
            self.present(alert, animated: true, completion: nil)
        } else {
            let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey")
            if (!hasLogin) {
                self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self)
            } else {
                getStatisticForLast7Days()
                getSummaryForLast7Days()
                getDailyProgressForDailyCodingAvarageChart()
                combinedChartFill(combinedChartView: codingActivityCombinedChartView)
                fillLabelWithDailyWorkingTime()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        if !Connectivity.isConnectedToInternet {
            let alert = alertSetUp.showAlert(alertTitle: "No Internet Conection", alertMessage: "Turn on cellural data or use Wi-Fi to access data.")
            self.present(alert, animated: true, completion: nil)
        } else {
            let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey")
            if (!hasLogin) {
                self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self)
            } else {
                getStatisticForLast7Days()
                getSummaryForLast7Days()
                getDailyProgressForDailyCodingAvarageChart()
                combinedChartFill(combinedChartView: codingActivityCombinedChartView)
                fillLabelWithDailyWorkingTime()
            }
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        isAuthenticated = true
    }
    
    @IBAction func logoutWakaTimeButtonTapped(_ sender: Any) {
        self.logoutUserFromWakaTime()
    }
    
    func logoutUserFromWakaTime() {
        UserDefaults.standard.set(false, forKey: "hasUserSecretAPIkey")
        self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self)
        let keychainManager = KeychainManager()
        keychainManager.deleteUserSecretAPIkeyFromKeychain()  
    }
    
    func getStatisticForLast7Days() {
        statisticController.getUserStatisticsForGivenTimeRange(completionHandler: { statistic, status in
            if (statistic != nil && status == 200) {
                self.pieChartFill(pieChartView: self.languagePieChartView,
                                  itemsList: (statistic?.usedLanguages)!)
                self.pieChartFill(pieChartView: self.editorPieChartView,
                                    itemsList: (statistic?.usedEditors)!)
                self.pieChartFill(pieChartView: self.operatingSystemPieChartView,
                                  itemsList: (statistic?.usedOperatingSystems)!)
                self.dailyAverageTimeLabel.text = statistic?.humanReadableDailyAverage!
            } else {
                guard status != nil else {
                    log.error("Unexpected error without status code.")
                    let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error",
                                              alertMessage: "Please, try again later.")
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: status!)
            }
        })
    }
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    func getSummaryForLast7Days() {
        let start = dateManager.getStartDayAsString()
        let end = dateManager.getCurrentDateAsString()
        
        summaryController.getUserSummaryForGivenTimeRange(startDate: start,
                                                          endDate: end,
                                                          completionHandler: { summary, status in
            if (summary != nil && status == 200) {
                var totalWorkingSecondsForLast7Days = 0
                for summaryItem in summary! {
                    totalWorkingSecondsForLast7Days += summaryItem.grandTotalTimeOfCodingInSeconds!
                }
                let totalWorkingHoursForLast7Days = self.secondsToHoursMinutesSeconds(seconds: totalWorkingSecondsForLast7Days).0
                let totalWorkingMinutesForLast7Days = self.secondsToHoursMinutesSeconds(seconds: totalWorkingSecondsForLast7Days).1
                self.timeOfCodingLast7DaysLabel.text = "\(totalWorkingHoursForLast7Days) hrs \(totalWorkingMinutesForLast7Days) mins in the Last 7 Days"
                //TODO: clean it
//                var last7DaysList = [String]();
//                var projectsList = [EntrySummary]();
//                var codingTimeList = [Double]();
//                var time: Double;
//                for summaryItem in summary! {
//                    last7DaysList.append(summaryItem.dateOfCurrentRangeAsText!);
//                    projectsList = summaryItem.projects!;
//                    for projectItem in projectsList {
//                        time = Double(projectItem.workingTimeMinutesPortion!) * 0.01 + Double(projectItem.workingTimeHoursPortion!);
//                        codingTimeList.append(time);
//                    }
//                }
//                self.setChart(xValues: last7DaysList, yValuesLineChart: codingTimeList, yValuesBarChart: codingTimeList);
            } else {
                guard status != nil else {
                    let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.")
                    self.present(alert, animated: true, completion: nil)
                    log.error("Unexpected error without status code.")
                    return
                }
                
                self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: status!)
            }
        })
    }
    
    func fillLabelWithDailyWorkingTime() {
        let currentDate = dateManager.getCurrentDateAsString()
        
        summaryController.getUserSummaryForGivenTimeRange(startDate: currentDate,
                                                          endDate: currentDate,
                                                          completionHandler: { summary, status in
            if (summary != nil && status == 200) {
                for summaryItem in summary! {
                    guard summaryItem.grandTotalTimeOfCodindAsText != nil else {
                        self.todayWorkingTimeLabel.text = "0 secs"
                        return
                    }
                    self.todayWorkingTimeLabel.text = summaryItem.grandTotalTimeOfCodindAsText!
                }
            } else {
                    guard status != nil else {
                        let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.")
                        self.present(alert, animated: true, completion: nil)
                        log.error("Unexpected error without status code.")
                        return
                    }
                self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: status!)
            }
        })
    }
    
    func getDailyProgressForDailyCodingAvarageChart() {
        let date = dateManager.getCurrentDateAsString()
        
        statisticController.getUserStatisticsForGivenTimeRange(completionHandler: { statistic, statusForStatistic in
            self.summaryController.getUserSummaryForGivenTimeRange(startDate: date,
                                                                     endDate: date,
                                                                     completionHandler:{ summary, statusForSummary in
                if (statistic != nil && statusForStatistic == 200) {
                    if (summary != nil && statusForSummary == 200) {
                        var dailyProgressListInPercent = [Double]()
                        for summaryItem in summary! {
                            let dailyAverageWorkingTimeInSeconds = (statistic?.dailyAverageWorkingTime!)!
                            let currentWorkingTimeInSecodns = summaryItem.grandTotalTimeOfCodingInSeconds!
                            let progressTime = currentWorkingTimeInSecodns * 100
                            //TODO: create separate func from this part
                            if (dailyAverageWorkingTimeInSeconds == 0) {
                                self.todayWorkingProgressInPercent.text = "0.0%"
                                self.todayChangesOfWorkingProgress.text = "No Change"
                            } else {
                                let progressWorkingTimeInPercent: Double = Double(progressTime /
                                    dailyAverageWorkingTimeInSeconds).rounded(toPlaces: 1)
                                dailyProgressListInPercent.append(progressWorkingTimeInPercent)
                                self.todayWorkingProgressInPercent.text = "\(progressWorkingTimeInPercent)%"
                                if (progressWorkingTimeInPercent > 100.0) {
                                    let increase = progressWorkingTimeInPercent - 100.0
                                    self.todayChangesOfWorkingProgress.text = "\(increase.rounded(toPlaces: 1))% Increase"
                                } else {
                                    let decrease = 100.0 - progressWorkingTimeInPercent
                                    dailyProgressListInPercent.append(decrease)
                                    self.todayChangesOfWorkingProgress.text = "\(decrease.rounded(toPlaces: 1)) % Decrease"
                                }
                            }
                        }
                        self.halfPieChartFill(halfPieChartView: self.codingDailyAverageHalfPieChartView,
                                              itemsList: dailyProgressListInPercent)
                    } else {
                        guard statusForSummary != nil else {
                            let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error",
                                                 alertMessage: "Please, try again later.")
                            self.present(alert, animated: true, completion: nil)
                            log.error("Unexpected error without status code.")
                            return
                        }
                        
                        self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: statusForSummary!)
                        log.error("Unexpected error with statistic request with status code: \(statusForSummary!)")
                    }
                } else {
                    guard statusForStatistic != nil else {
                        let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error",
                                             alertMessage: "Please, try again later.")
                        self.present(alert, animated: true, completion: nil)
                        log.error("Unexpected error without status code.")
                        return
                    }
                    
                    self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: statusForStatistic!)
                    log.error("Unexpected error with statistic request with status code: \(statusForStatistic!)")
                }
            })
        })
    }
    
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
    
    func halfPieChartFill(halfPieChartView: PieChartView, itemsList: [Double]) {
        var entryWorkingTimeItem = [PieChartDataEntry]()
        for item in itemsList {
            let entry = PieChartDataEntry(value: item,
                                          label: "")
            entryWorkingTimeItem.append(entry)
            let dataSet = PieChartDataSet(values: entryWorkingTimeItem,
                                          label: "")
            //TODO: create separate func from this part
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



extension WakaTimeChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value) % months.count]
    }
}
