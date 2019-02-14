//
//  WakaTimeChartViewController.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 23.01.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//
import UIKit
import ObjectMapper
import Charts

class WakaTimeChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var todayChangesOfWorkingProgress: UILabel!
    @IBOutlet weak var todayWorkingProgressInPercent: UILabel!
    @IBOutlet weak var todayWorkingTimeLabel: UILabel!
    @IBOutlet weak var dailyAverageTimeLabel: UILabel!
    @IBOutlet weak var timeOfCodingForLast7DaysLabel: UILabel!
    @IBOutlet weak var codingTimePerDayInPercentLabel: UILabel!
    @IBOutlet weak var buildingTimePerDayInPercentLabel: UILabel!
    @IBOutlet weak var timeOfBuildingForLast7DaysBreakdownOverPeriodLabel: UILabel!
    @IBOutlet weak var timeOfCodingForLast7DaysBreakdownOverPeriodLabel: UILabel!
    @IBOutlet weak var editorPieChartView: PieChartView!
    @IBOutlet weak var languagePieChartView: PieChartView!
    @IBOutlet weak var operatingSystemPieChartView: PieChartView!
    @IBOutlet weak var codingActivityForLast7DaysByDaysCombinedChartView: CombinedChartView!
    @IBOutlet weak var codingDailyAverageHalfPieChartView: PieChartView!
    @IBOutlet weak var workingBreakdownOverActivityHorizontalBarChartView: HorizontalBarChartView!
    @IBOutlet weak var workingBreakdownOverActivityByDayMultipleBarChartView: BarChartView!
    
//    lazy var dateManager = DateManager()
    lazy var chartFilling = ChartFilling()
    lazy var markerDataManager = MarkerDataManager()
    let statisticController = StatisticController()
    let summaryController = SummaryController()
    let alertSetUp = AlertSetUp()
    var isAuthenticated = false
    let tagForCombinedChartView = 001
    let tagForMultipleBarChartView = 002
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if !Connectivity.isConnectedToInternet {
            let alert = alertSetUp.showAlert(alertTitle: "No Internet Connection", alertMessage: "Turn on cellural data or use Wi-Fi to access data.")
            self.present(alert, animated: true, completion: nil)
            log.debug("Alert with no internet connection error prsented successfully.")
        } else {
            let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey")
            if !hasLogin {
                self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self)
                log.debug("Unregistered user logout worked out successfully.")
            } else {
                self.codingActivityForLast7DaysByDaysCombinedChartView.tag = tagForCombinedChartView
                self.workingBreakdownOverActivityByDayMultipleBarChartView.tag = tagForMultipleBarChartView
                workingBreakdownOverActivityByDayMultipleBarChartView.delegate = self
                codingActivityForLast7DaysByDaysCombinedChartView.delegate = self
                
                getStatisticForLast7DaysForFillingPieChartsView()
                getSummaryForLast7DaysForFillingLabelsWithWorkingTime()
                getDailyProgressForDailyCodingAvarageChart()
                getSummaryForLast7DaysForWeeklyBreakdownOverActivity()
                getSummaryForLast7DaysForWeeklyBreakdownOverActivityByDay()
                getSummaryOfCodingActivityForLast7DaysByDays()
                fillingLabelWithCurrentDailyWorkingTime()
            }
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        isAuthenticated = true
    }
    
    @IBAction func logoutWakaTimeButtonTapped(_ sender: Any) {
        self.logoutUserFromWakaTime()
    }
    
    //MARK: Chart delegate methods
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let position = Int(highlight.x)
        if chartView.tag == tagForMultipleBarChartView {
            log.debug("Selecting the column of Weekly Breakdown Over Activity By Day MultipleBarChartView was successful.")
            if markerDataManager.buildingTimeInPercentForWeeklyBreakdownOverActivityByDays.count == 7 {
                buildingTimePerDayInPercentLabel.text = markerDataManager.buildingTimeInPercentForWeeklyBreakdownOverActivityByDays[position]
                codingTimePerDayInPercentLabel.text = markerDataManager.codingTimeInPercentForWeeklyBreakdownOverActivityByDays[position]
                let marker = createBalloonMarkerForWorkingBreakdownOverActivity(
                    date: markerDataManager.daysOfGivenTimePeriodArray[position],
                    coding: "Coding:  \(markerDataManager.codingTimeForWeeklyBreakdownOverActivityByDay[position])\n",
                    building: "Building: \(markerDataManager.buildingTimeForWeeklyBreakdownOverActivityByDay[position])")
                marker.chartView = chartView
                chartView.marker = marker
            
                log.debug("Coding and Building Time Per Day In Percent Labels are filled successfully.")
            } else {
                buildingTimePerDayInPercentLabel.isHidden = true
                codingTimePerDayInPercentLabel.text = markerDataManager.codingTimeInPercentForWeeklyBreakdownOverActivityByDays[position]
                let marker = createBalloonMarkerForWorkingBreakdownOverActivity(
                    date: markerDataManager.daysOfGivenTimePeriodArray[position],
                    coding: "Coding: \(markerDataManager.codingTimeForWeeklyBreakdownOverActivityByDay[position])",
                    building: "")
                marker.chartView = chartView
                chartView.marker = marker
                log.debug("Coding Time Per Day In Percent Labels are filled successfully.")
            }
        } else {
            log.debug("Selecting the column of Coding Activity For Last 7 Days By Days Combined Chart View was successful.")
            let marker = createBalloonMarkerForCodingActivity(
                date: markerDataManager.daysOfGivenTimePeriodArray[position],
                total: markerDataManager.totalCodingActivityPerDay[position],
                projectNameByDay: markerDataManager.projectNameByDay[position]!,
                projectWorkingTimePerDay: markerDataManager.projectWorkingTimePerDay[position]!)
            marker.chartView = chartView
            chartView.marker = marker
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if chartView.tag == tagForMultipleBarChartView {
            log.debug("Deselecting the column of Weekly Breakdown Over Activity By Day MultipleBarChartView was successful.")
        } else {
            log.debug("Deselecting the column of Coding Activity For Last 7 Days By Days Combined Chart View was successful.")
        }
    }
    
    func logoutUserFromWakaTime() {
        UserDefaults.standard.set(false, forKey: "hasUserSecretAPIkey")
        self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self)
        log.debug("User Logout worked out successfully.")
        let keychainManager = KeychainManager()
        keychainManager.deleteUserSecretAPIkeyFromKeychain()  
    }
    
    func getStatisticForLast7DaysForFillingPieChartsView() {
        statisticController.getUserStatisticsForGivenTimeRange(completionHandler: { statistic, status in
            if(statistic != nil && status == 200) {
                self.chartFilling.pieChartFilling(pieChartView: self.languagePieChartView,
                                  statisticItemsList: (statistic?.usedLanguages)!)
                log.debug("Language Pie Chart View is filled successfully.")
                self.chartFilling.pieChartFilling(pieChartView: self.editorPieChartView,
                                    statisticItemsList: (statistic?.usedEditors)!)
                log.debug("Editor Pie Chart View is filled successfully.")
                self.chartFilling.pieChartFilling(pieChartView: self.operatingSystemPieChartView,
                                  statisticItemsList: (statistic?.usedOperatingSystems)!)
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
    

    //change this "if else"
    func getSummaryForLast7DaysForFillingLabelsWithWorkingTime() {
        let start = Date().dateAsStringSevenDaysAgoFromNow()
        let end = Date().stringFromDate()
        
        summaryController.getUserSummaryForGivenTimeRange(startDate: start,
                                                          endDate: end,
                                                          completionHandler: { summary, status in
            if (summary != nil && status == 200) {
                log.debug("Request for Summary for the last 7 days passed successfully.")
                var totalCodingSecondsForLast7Days = 0
                var totalBuildingSecondsForLast7Days = 0
                var hideTimeOfBuildingForLast7DaysBreakdownOverPeriodLabel = false
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
                if totalBuildingSecondsForLast7Days == 0 {
                    hideTimeOfBuildingForLast7DaysBreakdownOverPeriodLabel = true
                }
                self.timeOfBuildingForLast7DaysBreakdownOverPeriodLabel.isHidden = hideTimeOfBuildingForLast7DaysBreakdownOverPeriodLabel

                let totalCodingHoursForLast7Days = totalCodingSecondsForLast7Days.secondsToHours()
                let totalCodingMinutesForLast7Days = totalCodingSecondsForLast7Days.secondsToMinutes()
                
                let totalBuildingHoursForLast7Days = totalBuildingSecondsForLast7Days.secondsToHours()
                let totalBuildingMinutesForLast7Days = totalBuildingSecondsForLast7Days.secondsToMinutes()
                
                if(totalCodingSecondsForLast7Days != 0 && totalCodingHoursForLast7Days != 0 && totalCodingMinutesForLast7Days != 0) {
                    self.timeOfCodingForLast7DaysLabel.text = "\(totalCodingHoursForLast7Days) hrs \(totalCodingMinutesForLast7Days) mins in the Last 7 Days"
                    self.timeOfCodingForLast7DaysBreakdownOverPeriodLabel.text = "Coding\n\(totalCodingHoursForLast7Days)h \(totalCodingMinutesForLast7Days)m"
                } else if (totalCodingHoursForLast7Days == 0 && totalCodingMinutesForLast7Days != 0) {
                    self.timeOfCodingForLast7DaysLabel.text = "\(totalCodingMinutesForLast7Days) mins in the Last 7 Days"
                    self.timeOfCodingForLast7DaysBreakdownOverPeriodLabel.text = "Coding\n\(totalCodingMinutesForLast7Days)m"
                } else if (totalCodingMinutesForLast7Days == 0 && totalCodingHoursForLast7Days != 0) {
                    self.timeOfCodingForLast7DaysLabel.text = "\(totalCodingHoursForLast7Days) hrs in the Last 7 Days"
                    self.timeOfCodingForLast7DaysBreakdownOverPeriodLabel.text = "Coding\n\(totalCodingHoursForLast7Days)h"
                } else {
                    self.timeOfCodingForLast7DaysBreakdownOverPeriodLabel.text = "0 h 0 m"
                    self.timeOfCodingForLast7DaysLabel.text = "0 hrs 0 mins in the Last 7 Days"
                }
                if (totalBuildingHoursForLast7Days != 0 && totalBuildingMinutesForLast7Days != 0) {
                    self.timeOfBuildingForLast7DaysBreakdownOverPeriodLabel.text = "Building\n\(totalBuildingHoursForLast7Days)h \(totalBuildingMinutesForLast7Days)m"
                } else if (totalBuildingHoursForLast7Days == 0) {
                    self.timeOfBuildingForLast7DaysBreakdownOverPeriodLabel.text = "Building\n\(totalBuildingMinutesForLast7Days)m"
                } else if (totalBuildingMinutesForLast7Days == 0) {
                    self.timeOfBuildingForLast7DaysBreakdownOverPeriodLabel.text = "Building\n\(totalBuildingHoursForLast7Days)h"
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
    
    //TODO: needed refactoring THIS function
    //less loops
    func getSummaryOfCodingActivityForLast7DaysByDays() {
        let start = Date().dateAsStringSevenDaysAgoFromNow()
        let end = Date().stringFromDate()
        
        var projectsDictionary = [String:[Double]]()
        var daysOfGivenTimePeriodArray = [String]()
        var counter = 0
        var projectWorkingTimePerDay = [Int:[String]]()
        var projectNameByDays = [Int:[String]]()
        
        summaryController.getUserSummaryForGivenTimeRange(startDate: start,
                                                          endDate: end,
                                                          completionHandler: {summary, status in
            if(summary != nil && status == 200) {
                log.debug("Request for Summary Of coding activity for last 7 days by days passed successfully.")
                for summaryItem in summary! {
                    var projectNames = [String]()
                    var workingTimePerProjects = [String]()
                    
                    guard let projects = summaryItem.project else {
                        //TODO: add some warning or error
                        return
                    }
                    
                    if(projects.isEmpty && !projectsDictionary.isEmpty) {
                        projectNames.append("")
                        workingTimePerProjects.append("")
                        
                        for key in projectsDictionary.keys {
                            projectsDictionary[key]?.insert(0, at: counter)
                        }
                        
                   } else {
                        
                        for projectItem in projects {
                            guard let projectName = projectItem.entryName, let workingTimePerProject = projectItem.workingTimeAsText else {
                                //TODO: add some warning or error
                                return
                            }
                            
                            let totalCodingTimeHoursPortionPerProjectByDay = projectItem.workingTimeHoursPortion
                            let totalCodingTimeMinutesPortionPerProjectByDay = projectItem.workingTimeMinutesPortion
                            let totalCodingTimePerProjectByDay = Double(totalCodingTimeHoursPortionPerProjectByDay!) + (Double(totalCodingTimeMinutesPortionPerProjectByDay!) * 0.01)
                            projectNames.append(projectName + ": ")
                            workingTimePerProjects.append(workingTimePerProject)
                            
                            if !projectsDictionary.keys.contains(projectName) {
                                var array = [Double]()
                                array = Array(repeating: 0, count: counter)
                                array.insert(totalCodingTimePerProjectByDay, at: counter)
                                projectsDictionary[projectName] = array
                            } else {
                                if projects.count < projectsDictionary.keys.count {
                                    if projectsDictionary[projectName]?.count == summary?.count {
                                    //something
                                    } else {
                                        for key in projectsDictionary.keys {
                                            if(projectsDictionary[key]?.count != counter + 1) {
                                                 projectsDictionary[key]?.insert(0, at: counter)
                                            }
                                        }
                                    }
                                    projectsDictionary[projectName]?.remove(at: counter)
                                    projectsDictionary[projectName]?.insert(totalCodingTimePerProjectByDay, at: counter)
                                } else {
                                    projectsDictionary[projectName]?.insert(totalCodingTimePerProjectByDay, at: counter)
                                }
                            }
                        }
                    }
                    projectNameByDays[counter] = projectNames
                    projectWorkingTimePerDay[counter] = workingTimePerProjects
                    counter += 1
                    let date = summaryItem.dateOfCurrentRange!.convertDateAsStringToAnotherFormat()
                    daysOfGivenTimePeriodArray.append(date)
                    guard let totalCodingTimeAsString = summaryItem.grandTotalTimeOfCodindAsText else {
                        return
                    }
                    self.markerDataManager.totalCodingActivityPerDay.append(totalCodingTimeAsString)
                }
                self.markerDataManager.projectNameByDay = projectNameByDays
                self.markerDataManager.projectWorkingTimePerDay = projectWorkingTimePerDay
                
                self.chartFilling.combinedChartFilling(combinedChartView: self.codingActivityForLast7DaysByDaysCombinedChartView,
                                                 codingTimePerProjectsByDaysForBarChart: Array(projectsDictionary.values),
                                                 projectNameArray: Array(projectsDictionary.keys),
                                                 daysOfGivenTimePeriodArray: daysOfGivenTimePeriodArray)
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
        let start = Date().dateAsStringSevenDaysAgoFromNow()
        let end = Date().stringFromDate()
        
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
                if weeklyBuildingTimeInPercent != 0.0 {
                    weeklyWorkingTimeListInPercentAsString.append(weeklyBuildingTimeInPercentAsString)
                    weeklyWorkingTimeListInPercent.append(weeklyBuildingTimeInPercent)
                }
                weeklyCodingTimeInPercent = Double((weeklyCodingTimeInSeconds * 100) / weeklyWorkingTime).rounded(toPlaces: 2)
                let weeklyCodingTimeInPercentAsString = "\(weeklyCodingTimeInPercent) %"
                weeklyWorkingTimeListInPercentAsString.append(weeklyCodingTimeInPercentAsString)
                weeklyWorkingTimeListInPercent.append(weeklyCodingTimeInPercent)
                self.chartFilling.horizontalBarChartFilling(horizontalBarChartView: self.workingBreakdownOverActivityHorizontalBarChartView, workingTimeAsPercentage: weeklyWorkingTimeListInPercent, workingTimeAsPercentageAsString: weeklyWorkingTimeListInPercentAsString)
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
    
    //TODO: add alerts
    func getSummaryForLast7DaysForWeeklyBreakdownOverActivityByDay() {
        let start = Date().dateAsStringSevenDaysAgoFromNow()
        let end = Date().stringFromDate()
        
        summaryController.getUserSummaryForGivenTimeRange(startDate: start,
                                                          endDate: end,
                                                          completionHandler: { summary, status in
            if (summary != nil && status == 200) {
                log.debug("Request for Summary for weekly breakdown over activity passed successfully.")
                var codingTimePerDay = [Double]()
                var buildingTimePerDay = [Double]()
                var daysOfGivenTimePeriodArray = [String]()
                
                for summaryItem in summary! {
                    if(summaryItem.category != nil && summaryItem.category?.isEmpty == false) {
                        for categoryItem in summaryItem.category! {
                            if(categoryItem.entryName == "Coding" && categoryItem.workingTimeMinutesPortion != nil) {
                                let totalCodingTimeAsDouble = Double(categoryItem.workingTimeHoursPortion!) + Double(categoryItem.workingTimeMinutesPortion!) / 100
                                codingTimePerDay.append(totalCodingTimeAsDouble.rounded(toPlaces: 2))
                                guard let workingTime = categoryItem.workingTimeAsText,
                                    let workingTimeInPercent = categoryItem.workingTimeInPercent else {
                                    return
                                }
                                self.markerDataManager.codingTimeInPercentForWeeklyBreakdownOverActivityByDays.append("\(workingTimeInPercent)%")
                                self.markerDataManager.codingTimeForWeeklyBreakdownOverActivityByDay.append(workingTime)
                                
                            } else if(categoryItem.entryName == "Building" && categoryItem.workingTimeMinutesPortion != nil) {
                                let totalBuilingTimeAsDouble = Double(categoryItem.workingTimeHoursPortion!) + Double(categoryItem.workingTimeMinutesPortion!) / 100
                                buildingTimePerDay.append(totalBuilingTimeAsDouble.rounded(toPlaces: 2))
                                
                                guard let buildingTime = categoryItem.workingTimeAsText,
                                    let workingTimeInPercent = categoryItem.workingTimeInPercent else {
                                        return
                                }
                                
                                self.markerDataManager.buildingTimeInPercentForWeeklyBreakdownOverActivityByDays.append("\(workingTimeInPercent)%")
                                self.markerDataManager.buildingTimeForWeeklyBreakdownOverActivityByDay.append(buildingTime)
                            }
                        }
                    } else if summaryItem.category?.isEmpty == true {
                        codingTimePerDay.append(0)
                        buildingTimePerDay.append(0)
                        self.markerDataManager.codingTimeInPercentForWeeklyBreakdownOverActivityByDays.append("0%")
                        self.markerDataManager.buildingTimeInPercentForWeeklyBreakdownOverActivityByDays.append("0%")
                        
                        self.markerDataManager.codingTimeForWeeklyBreakdownOverActivityByDay.append("0m")
                        self.markerDataManager.buildingTimeForWeeklyBreakdownOverActivityByDay.append("0m")
                    }
                    let date = summaryItem.dateOfCurrentRange!.convertDateAsStringToAnotherFormat()
                    daysOfGivenTimePeriodArray.append(date)
                    self.markerDataManager.daysOfGivenTimePeriodArray = daysOfGivenTimePeriodArray
                }
                if buildingTimePerDay.count != daysOfGivenTimePeriodArray.count {
                    self.chartFilling.multipleBarChartFilling(multipleBarChartView: self.workingBreakdownOverActivityByDayMultipleBarChartView, codingTimePerDay: codingTimePerDay, buildingTimePerDay: nil, daysOfGivenTimePeriodArray: daysOfGivenTimePeriodArray)
                    log.debug("Weekly Breakdown Over Activity Multiple Bar Chart is filled successfully.")
                } else {
                    self.chartFilling.multipleBarChartFilling(multipleBarChartView: self.workingBreakdownOverActivityByDayMultipleBarChartView, codingTimePerDay: codingTimePerDay, buildingTimePerDay: buildingTimePerDay, daysOfGivenTimePeriodArray: daysOfGivenTimePeriodArray)
                    log.debug("Weekly Breakdown Over Activity Multiple Bar Chart is filled successfully.")
                }
            }
        })
    }
    
    func fillingLabelWithCurrentDailyWorkingTime() {
        let currentDate = Date().stringFromDate()
        
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
        let currentDate = Date().stringFromDate()
        statisticController.getUserStatisticsForGivenTimeRange(completionHandler: { statistic, statusForStatistic in
            self.summaryController.getUserSummaryForGivenTimeRange(startDate: currentDate,
                                                                     endDate: currentDate,
                                                                     completionHandler:{ summary,
                                                                        statusForSummary in
                if ((statistic != nil && statusForStatistic == 200) || (summary != nil && statusForSummary == 200)) {
                    log.debug("Request for Statistics and Summary for given time range passed successfully.")
                    var dailyProgressListInPercent = [Double]()
                    for summaryItem in summary! {
                        let dailyAverageWorkingTimeInSeconds = (statistic?.dailyAverageWorkingTime!)!
                        let currentWorkingTimeInSecodns = summaryItem.grandTotalTimeOfCodingInSeconds!
                        let progressTime = currentWorkingTimeInSecodns * 100
                        if dailyAverageWorkingTimeInSeconds == 0 {
                            self.todayWorkingProgressInPercent.text = "0.0%"
                            self.todayChangesOfWorkingProgress.text = "No Change"
                            log.debug("Today working progress is empty.")
                        } else {
                            let progressWorkingTimeInPercent: Double = Double(progressTime /
                                dailyAverageWorkingTimeInSeconds).rounded(toPlaces: 1)
                            dailyProgressListInPercent.append(progressWorkingTimeInPercent)
                            if progressWorkingTimeInPercent > 100.0 {
                                let increase = progressWorkingTimeInPercent - 100.0
                                let progressWorkingTimeInPercentForDisplaying = progressWorkingTimeInPercent - increase
                                self.todayWorkingProgressInPercent.text = "\(progressWorkingTimeInPercentForDisplaying.rounded(toPlaces: 1))%"
                                self.todayChangesOfWorkingProgress.text = "\(increase.rounded(toPlaces: 1))% Increase"
                                log.debug("Today working progress is increase.")
                            } else {
                                let decrease = 100.0 - progressWorkingTimeInPercent
                                dailyProgressListInPercent.append(decrease)
                                self.todayWorkingProgressInPercent.text = "\(progressWorkingTimeInPercent)%"
                                self.todayChangesOfWorkingProgress.text = "\(decrease.rounded(toPlaces: 1))% Decrease"
                                log.debug("Today working progress is decrease.")
                            }
                        }
                    }
                    self.chartFilling.halfPieChartFilling(halfPieChartView: self.codingDailyAverageHalfPieChartView,
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
    
    func createBalloonMarkerForWorkingBreakdownOverActivity(date: String, coding: String, building: String) -> BalloonMarkerForWorkingBreakdownOverActivity {
        let marker : BalloonMarkerForWorkingBreakdownOverActivity = BalloonMarkerForWorkingBreakdownOverActivity(color: UIColor.darkGray.withAlphaComponent(0.75), font: UIFont(name: "PingFangSC-Light", size: 11)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0), date: date, coding: coding, building: building)
        if building == "" {
            marker.minimumSize = CGSize(width: CGFloat(90), height: CGFloat(55))
        } else {
            marker.minimumSize = CGSize(width: CGFloat(90), height: CGFloat(65))
        }
        return marker
    }
    
    func createBalloonMarkerForCodingActivity(date: String, total: String, projectNameByDay: [String], projectWorkingTimePerDay: [String]) -> BalloonMarkerForCodingActivity {
        let marker : BalloonMarkerForCodingActivity = BalloonMarkerForCodingActivity(color: UIColor.darkGray.withAlphaComponent(0.75), font: UIFont(name: "PingFangSC-Light", size: 11)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0), date: date, total: total, projectNameByDay: projectNameByDay, projectWorkingTimePerDay: projectWorkingTimePerDay)
        
         marker.minimumSize = CGSize(width: CGFloat(90), height: CGFloat(0))
        
        return marker
    }
}
