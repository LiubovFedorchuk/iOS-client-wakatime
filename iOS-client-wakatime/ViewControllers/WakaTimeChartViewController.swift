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
    lazy var chartFill = ChartFill()
    let statisticController = StatisticController()
    let summaryController = SummaryController()
    let alertSetUp = AlertSetUp()
    var isAuthenticated = false
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    @IBOutlet weak var todayChangesOfWorkingProgress: UILabel!
    @IBOutlet weak var todayWorkingProgressInPercent: UILabel!
    @IBOutlet weak var todayWorkingTimeLabel: UILabel!
    @IBOutlet weak var dailyAverageTimeLabel: UILabel!
    @IBOutlet weak var timeOfCodingForLast7DaysLabel: UILabel!
    @IBOutlet weak var timeOfBuildingForLast7DaysBreakdownOverPeriod: UILabel!
    @IBOutlet weak var timeOfCodingForLast7DaysBreakdownOverPeriod: UILabel!
    @IBOutlet weak var editorPieChartView: PieChartView!
    @IBOutlet weak var languagePieChartView: PieChartView!
    @IBOutlet weak var operatingSystemPieChartView: PieChartView!
    @IBOutlet weak var codingActivityCombinedChartView: CombinedChartView!
    @IBOutlet weak var codingDailyAverageHalfPieChartView: PieChartView!
    @IBOutlet weak var codingActivityCurrentlyHorizontalBarChartView: HorizontalBarChartView!
    @IBOutlet weak var weeklyBreakdownOverActivityHorizontalBarChartView: HorizontalBarChartView!
    @IBOutlet weak var weeklyBreakdownOverActivityByDayMultipleBarChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Connectivity.isConnectedToInternet {
            let alert = alertSetUp.showAlert(alertTitle: "No Internet Conection", alertMessage: "Turn on cellural data or use Wi-Fi to access data.")
            self.present(alert, animated: true, completion: nil)
            log.debug("Alert with no internet connection error prsented successfully.")
        } else {
            let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey")
            if (!hasLogin) {
                self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self)
                log.debug("Alert with no internet connection error prsented successfully.")
            } else {
                getStatisticForLast7Days()
                getSummaryForLast7Days()
                getDailyProgressForDailyCodingAvarageChart()
                getSummaryForLast7DaysForWeeklyBreakdownOverActivity()
                chartFill.combinedChartFill(combinedChartView: codingActivityCombinedChartView)
                chartFill.multipleBarChartViewFill(multipleBarChartView: weeklyBreakdownOverActivityByDayMultipleBarChartView)
                fillLabelWithDailyWorkingTime()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        if !Connectivity.isConnectedToInternet {
            let alert = alertSetUp.showAlert(alertTitle: "No Internet Connection", alertMessage: "Turn on cellural data or use Wi-Fi to access data.")
            self.present(alert, animated: true, completion: nil)
            log.debug("Alert with no internet connection error prsented successfully.")
        } else {
            let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey")
            if (!hasLogin) {
                self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self)
                log.debug("Unregistered user logout worked out successfully.")
            } else {
                getStatisticForLast7Days()
                getSummaryForLast7Days()
                getDailyProgressForDailyCodingAvarageChart()
                getSummaryForLast7DaysForWeeklyBreakdownOverActivity()
                chartFill.combinedChartFill(combinedChartView: codingActivityCombinedChartView)
                chartFill.multipleBarChartViewFill(multipleBarChartView: weeklyBreakdownOverActivityByDayMultipleBarChartView)
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
        log.debug("User Logout worked out successfully.")
        let keychainManager = KeychainManager()
        keychainManager.deleteUserSecretAPIkeyFromKeychain()  
    }
    
    func getStatisticForLast7Days() {
        statisticController.getUserStatisticsForGivenTimeRange(completionHandler: { statistic, status in
            if (statistic != nil && status == 200) {
                self.chartFill.pieChartFill(pieChartView: self.languagePieChartView,
                                  itemsList: (statistic?.usedLanguages)!)
                log.debug("Language Pie Chart View is filled successfully.")
                self.chartFill.pieChartFill(pieChartView: self.editorPieChartView,
                                    itemsList: (statistic?.usedEditors)!)
                log.debug("Editor Pie Chart View is filled successfully.")
                self.chartFill.pieChartFill(pieChartView: self.operatingSystemPieChartView,
                                  itemsList: (statistic?.usedOperatingSystems)!)
                log.debug("Operating System Pie Chart View is filled successfully.")
                self.dailyAverageTimeLabel.text = statistic?.humanReadableDailyAverage!
                log.debug("Daily Average Time Label is filled successfully.")
            } else {
                guard status != nil else {
                    log.error("Unexpected error without status code.")
                    let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error",
                                              alertMessage: "Please, try again later.")
                    self.present(alert, animated: true, completion: nil)
                    log.error("Unexpected error without status code.")
                    log.debug("Alert with unexpected error shown successfully.")
                    return
                }
                
                self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: status!)
                log.debug("Alert according to status code shown successfully.")
                log.error("Unexpected error with statistic request with status code: \(status!)")
            }
        })
    }
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    private func secondsToHoursMinutesSecondsforBuilding (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    func getSummaryForLast7Days() {
        let start = dateManager.getStartDayAsString()
        let end = dateManager.getCurrentDateAsString()
        
        summaryController.getUserSummaryForGivenTimeRange(startDate: start,
                                                          endDate: end,
                                                          completionHandler: { summary, status in
            if (summary != nil && status == 200) {
                log.debug("Request for Summary for the last 7 days passed successfully.")
                var totalCodingSecondsForLast7Days = 0
                var totalBuildingSecondsForLast7Days = 0
                for summaryItem in summary! {
                    totalCodingSecondsForLast7Days += summaryItem.grandTotalTimeOfCodingInSeconds!
                    if (summaryItem.category != nil) {
                        for categoryItem in summaryItem.category! {
                            if(categoryItem.entryName == "Building") {
                                totalBuildingSecondsForLast7Days += categoryItem.totalWorkingTimeAsSecond!
                            }
                        }
                    }
                }
                let totalCodingHoursForLast7Days = self.secondsToHoursMinutesSeconds(seconds: totalCodingSecondsForLast7Days).0
                let totalCodingMinutesForLast7Days = self.secondsToHoursMinutesSeconds(seconds: totalCodingSecondsForLast7Days).1
                
                let totalBuildingHoursForLast7Days = self.secondsToHoursMinutesSeconds(seconds: totalBuildingSecondsForLast7Days).0
                let totalBuildingMinutesForLast7Days = self.secondsToHoursMinutesSeconds(seconds: totalBuildingSecondsForLast7Days).1
                
                if(totalCodingSecondsForLast7Days != 0 && totalCodingHoursForLast7Days != 0 && totalCodingMinutesForLast7Days != 0) {
                    self.timeOfCodingForLast7DaysLabel.text = "\(totalCodingHoursForLast7Days) hrs \(totalCodingMinutesForLast7Days) mins in the Last 7 Days"
                    self.timeOfCodingForLast7DaysBreakdownOverPeriod.text = "Coding\n\(totalCodingHoursForLast7Days)h \(totalCodingMinutesForLast7Days)m"
                } else if (totalCodingHoursForLast7Days == 0 && totalCodingMinutesForLast7Days != 0) {
                    self.timeOfCodingForLast7DaysLabel.text = "\(totalCodingMinutesForLast7Days) mins in the Last 7 Days"
                    self.timeOfCodingForLast7DaysBreakdownOverPeriod.text = "Coding\n\(totalCodingMinutesForLast7Days)m"
                } else if (totalCodingMinutesForLast7Days == 0 && totalCodingHoursForLast7Days != 0) {
                    self.timeOfCodingForLast7DaysLabel.text = "\(totalCodingHoursForLast7Days) hrs in the Last 7 Days"
                    self.timeOfCodingForLast7DaysBreakdownOverPeriod.text = "Coding\n\(totalCodingHoursForLast7Days)h"
                } else {
                    self.timeOfCodingForLast7DaysBreakdownOverPeriod.text = "0 h 0 m"
                    self.timeOfCodingForLast7DaysLabel.text = "0 hrs 0 mins in the Last 7 Days"
                }
                if (totalBuildingHoursForLast7Days != 0 && totalBuildingMinutesForLast7Days != 0) {
                    self.timeOfBuildingForLast7DaysBreakdownOverPeriod.text = "Building\n\(totalBuildingHoursForLast7Days)h \(totalBuildingMinutesForLast7Days)m"
                } else if (totalBuildingHoursForLast7Days == 0) {
                    self.timeOfBuildingForLast7DaysBreakdownOverPeriod.text = "Building\n\(totalBuildingMinutesForLast7Days)m"
                } else if (totalBuildingMinutesForLast7Days == 0) {
                    self.timeOfBuildingForLast7DaysBreakdownOverPeriod.text = "Building\n\(totalBuildingHoursForLast7Days)h"
                } else {
                    self.timeOfBuildingForLast7DaysBreakdownOverPeriod.isHidden = true
                }
            } else {
                guard status != nil else {
                    let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.")
                    self.present(alert, animated: true, completion: nil)
                    log.error("Unexpected error without status code.")
                    log.debug("Alert with unexpected error shown successfully.")
                    return
                }
                self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: status!)
                log.debug("Alert according to status code shown successfully.")
                log.error("Unexpected error with statistic request with status code: \(status!)")
            }
        })
    }
    
    func getSummaryForLast7DaysForWeeklyBreakdownOverActivity() {
        let start = dateManager.getStartDayAsString()
        let end = dateManager.getCurrentDateAsString()
        
        summaryController.getUserSummaryForGivenTimeRange(startDate: start,
                                                          endDate: end,
                                                          completionHandler: { summary, status in
            if (summary != nil && status == 200) {
                log.debug("Request for Summary for weekly breakdown over activity passed successfully.")
                var weeklyBuildingTimeInSeconds = 0
                var weeklyCodingTimeInSeconds = 0
                var weeklyWorkingTime = 0
                var weeklyCodingTimeInPercent: Double
                var weeklyBuildingTimeInPercent: Double
                var weeklyWorkingTimeListInPercent = [Double]()
                var weeklyWorkingTimeListInPercentAsString = [String]()
                
                for summaryItem in summary! {
                    for categoryItem in summaryItem.category! {
                        if (categoryItem.entryName == "Coding" && categoryItem.totalWorkingTimeAsSecond != nil) {
                            weeklyCodingTimeInSeconds += categoryItem.totalWorkingTimeAsSecond!
                        } else if (categoryItem.entryName == "Building" && categoryItem.totalWorkingTimeAsSecond != nil) {
                            weeklyBuildingTimeInSeconds += categoryItem.totalWorkingTimeAsSecond!
                        }
                    }
                }
                weeklyWorkingTime = weeklyCodingTimeInSeconds + weeklyBuildingTimeInSeconds
                weeklyBuildingTimeInPercent = Double((weeklyBuildingTimeInSeconds * 100) / weeklyWorkingTime).rounded(toPlaces: 2)
                let weeklyBuildingTimeInPercentAsString = "\(weeklyBuildingTimeInPercent) %"
                weeklyWorkingTimeListInPercentAsString.append(weeklyBuildingTimeInPercentAsString)
                weeklyWorkingTimeListInPercent.append(weeklyBuildingTimeInPercent)
                
                weeklyCodingTimeInPercent = Double((weeklyCodingTimeInSeconds * 100) / weeklyWorkingTime).rounded(toPlaces: 2)
                let weeklyCodingTimeInPercentAsString = "\(weeklyCodingTimeInPercent) %"
                weeklyWorkingTimeListInPercentAsString.append(weeklyCodingTimeInPercentAsString)
                weeklyWorkingTimeListInPercent.append(weeklyCodingTimeInPercent)
                
                self.chartFill.horizontalBarChartFill(horizontalBarChartView: self.weeklyBreakdownOverActivityHorizontalBarChartView, workingTimeAsPercentage: weeklyWorkingTimeListInPercent, workingTimeAsPercentageAsString: weeklyWorkingTimeListInPercentAsString)
                log.debug("Weekly Breakdown Over Activity Horizontal Bar Chart is filled successfully.")
            } else {
                guard status != nil else {
                    let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.")
                    self.present(alert, animated: true, completion: nil)
                    log.error("Unexpected error without status code.")
                    log.debug("Alert with unexpected error shown successfully.")
                    return
                }
                self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: status!)
                log.debug("Alert according to status code shown successfully.")
                log.error("Unexpected error with statistic request with status code: \(status!)")
             }
        })
    }
    
    func fillLabelWithDailyWorkingTime() {
        let currentDate = dateManager.getCurrentDateAsString()
        
        summaryController.getUserSummaryForGivenTimeRange(startDate: currentDate,
                                                          endDate: currentDate,
                                                          completionHandler: { summary, status in
            if (summary != nil && status == 200) {
                log.debug("Request for Summary for given time range passed successfully.")
                for summaryItem in summary! {
                    guard summaryItem.grandTotalTimeOfCodindAsText != nil else {
                        self.todayWorkingTimeLabel.text = "0 secs"
                        log.debug("Today Working Time Label is empty.")
                        return
                    }
                    self.todayWorkingTimeLabel.text = summaryItem.grandTotalTimeOfCodindAsText!
                    log.debug("Today Working Time Label is filled successfully.")
                }
            } else {
                    guard status != nil else {
                        let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.")
                        self.present(alert, animated: true, completion: nil)
                        log.error("Unexpected error without status code.")
                        log.debug("Alert with unexpected error shown successfully.")
                        return
                    }
                self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: status!)
                log.debug("Alert according to status code shown successfully.")
                log.error("Unexpected error with statistic request with status code: \(status!)")
            }
        })
    }
    
    func getDailyProgressForDailyCodingAvarageChart() {
        let date = dateManager.getCurrentDateAsString()
        
        statisticController.getUserStatisticsForGivenTimeRange(completionHandler: { statistic, statusForStatistic in
            self.summaryController.getUserSummaryForGivenTimeRange(startDate: date,
                                                                     endDate: date,
                                                                     completionHandler:{ summary,
                                                                        statusForSummary in
                if ((statistic != nil && statusForStatistic == 200) || (summary != nil && statusForSummary == 200)) {
                    log.debug("Request for Statistics and Summary for given time range passed successfully.")
                    var dailyProgressListInPercent = [Double]()
                    for summaryItem in summary! {
                        let dailyAverageWorkingTimeInSeconds = (statistic?.dailyAverageWorkingTime!)!
                        let currentWorkingTimeInSecodns = summaryItem.grandTotalTimeOfCodingInSeconds!
                        let progressTime = currentWorkingTimeInSecodns * 100
                        if (dailyAverageWorkingTimeInSeconds == 0) {
                            self.todayWorkingProgressInPercent.text = "0.0%"
                            self.todayChangesOfWorkingProgress.text = "No Change"
                            log.debug("Today working progress is empty.")
                        } else {
                            let progressWorkingTimeInPercent: Double = Double(progressTime /
                                dailyAverageWorkingTimeInSeconds).rounded(toPlaces: 1)
                            dailyProgressListInPercent.append(progressWorkingTimeInPercent)
                            if (progressWorkingTimeInPercent > 100.0) {
                                let increase = progressWorkingTimeInPercent - 100.0
                                let progressWorkingTimeInPercentForDisplaying = progressWorkingTimeInPercent - increase
                                self.todayWorkingProgressInPercent.text = "\(progressWorkingTimeInPercentForDisplaying.rounded(toPlaces: 1))%"
                                self.todayChangesOfWorkingProgress.text = "\(increase.rounded(toPlaces: 1))% Increase"
                                log.debug("Today working progress is increase.")
                            } else {
                                let decrease = 100.0 - progressWorkingTimeInPercent
                                dailyProgressListInPercent.append(decrease)
                                self.todayWorkingProgressInPercent.text = "\(progressWorkingTimeInPercent)%"
                                self.todayChangesOfWorkingProgress.text = "\(decrease.rounded(toPlaces: 1)) % Decrease"
                                log.debug("Today working progress is decrease.")
                            }
                        }
                    }
                    self.chartFill.halfPieChartFill(halfPieChartView: self.codingDailyAverageHalfPieChartView,
                                              itemsList: dailyProgressListInPercent)
                    log.debug("Daily Coding Avarage Chart is filled successfully.")
                } else {
                    guard statusForSummary != nil, statusForStatistic != nil else {
                        let alert = self.alertSetUp.showAlert(alertTitle: "Unexpected error",
                                                alertMessage: "Please, try again later.")
                        self.present(alert, animated: true, completion: nil)
                        log.error("Unexpected error without status code.")
                        log.debug("Alert with unexpected error shown successfully.")
                        return
                    }
                        
                    self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: statusForSummary!)
                    log.debug("Alert according to status code shown successfully.")
                    log.error("Unexpected error with statistic request with status code: \(statusForSummary!)")
                }
            })
        })
    }
}

extension WakaTimeChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value) % months.count]
    }
}
