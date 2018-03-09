//
//  WakaTimeChartViewController.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 23.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBeaver
import ObjectMapper
import Charts

class WakaTimeChartViewController: UIViewController {
    
    let statisticController = StatisticController();
    let summaryController = SummaryController();
    var isAuthenticated = false;
    

    @IBOutlet weak var todayWorkingTimeLabel: UILabel!
    @IBOutlet weak var dailyAverageTimeLabel: UILabel!
    @IBOutlet weak var timeOfCodingLast7DaysLabel: UILabel!;
    @IBOutlet weak var editorPieChartView: PieChartView!;
    @IBOutlet weak var languagePieChartView: PieChartView!;
    @IBOutlet weak var operatingSystemPieChartView: PieChartView!;
    @IBOutlet weak var codingActivityCombinedChartView: CombinedChartView!;
    @IBOutlet weak var codingDailyAverageHalfPieChartView: PieChartView!;
    @IBOutlet weak var codingActivityCurrentlyHorizontalBarChartView: HorizontalBarChartView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }

    override func viewDidAppear(_ animated: Bool) {
        let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey");
        if (!hasLogin) {
            self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self);
        } else {
            getStatisticForLast7Days();
            getSummaryForLast7Days();
            getDailyProgress();
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        isAuthenticated = true;
    }
    
    @IBAction func logoutWakaTimeButtonTapped(_ sender: Any) {
        do {
            let userSecretAPIKeyItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                            accessGroup: KeychainConfiguration.accessGroup);
            try userSecretAPIKeyItem.deleteItem();
            UserDefaults.standard.set(false, forKey: "hasUserSecretAPIkey");
            self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self);
        }
        catch {
            log.error("Error deleting keychain item from query - \(error)");
            fatalError(error as! String);
        }
    }
    
    func getStatisticForLast7Days() {
        statisticController.getUserStatisticsForGivenTimeRange(completionHandler: { statistic, status in
            if (statistic != nil && status == 200) {
                self.pieChartFill(pieChartView: self.languagePieChartView,
                                  itemsList: (statistic?.usedLanguages)!);
                self.pieChartFill(pieChartView: self.editorPieChartView,
                                    itemsList: (statistic?.usedEditors)!);
                self.pieChartFill(pieChartView: self.operatingSystemPieChartView,
                                  itemsList: (statistic?.usedOperatingSystems)!);
                self.dailyAverageTimeLabel.text = statistic?.humanReadableDailyAverage!;
            } else {
                guard status != nil else {
                    self.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.");
                    log.error("Unexpected error without status code.");
                    return
                }
                
                self.showAlertAccordingToStatusCode(statusCode: status!);
            }
        });
    }
    
    func getSummaryForLast7Days() {
        summaryController.getUserSummariesForGivenTimeRange(completionHandler: { summary, status in
            if (summary != nil && status == 200) {
                var totalWorkingHoursForLast7Days = 0;
                var totalWorkingMinutesForLast7Days = 0;
                for summaryItem in summary! {
                    totalWorkingHoursForLast7Days += summaryItem.grandTotalHoursOfCoding!;
                    totalWorkingMinutesForLast7Days += summaryItem.grandTotalMinutesOfCoding!;
                }
                self.timeOfCodingLast7DaysLabel.text = "\(totalWorkingHoursForLast7Days) hrs \(totalWorkingMinutesForLast7Days) mins in the Last 7 Days";

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
                    self.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.");
                    log.error("Unexpected error without status code.");
                    return
                }
                
                self.showAlertAccordingToStatusCode(statusCode: status!);
            }
        });
    }
    
    func fillLabelWithDailyWorkingTime() {
        summaryController.getUserSummariesForCurrentDay(completionHandler: { summary, status in
            if (summary != nil && status == 200) {
                guard summary?.grandTotalTimeOfCodindAsText != nil else {
                    self.todayWorkingTimeLabel.text = "0 secs";
                    return
                }
                self.todayWorkingTimeLabel.text = summary?.grandTotalTimeOfCodindAsText!;
            } else {
                guard status != nil else {
                    self.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.");
                    log.error("Unexpected error without status code.");
                    return
                }
                
                self.showAlertAccordingToStatusCode(statusCode: status!);
            }
        });
    }
    
    func getDailyProgress() {
        statisticController.getUserStatisticsForGivenTimeRange(completionHandler:  { statistic, statusForStatistic in
            self.summaryController.getUserSummariesForCurrentDay(completionHandler: { summary, statusForSummary in
                if (statistic != nil && statusForStatistic == 200) {
                    if (summary != nil && statusForSummary == 200) {
                        log.debug(summary!)
                        var dailyProgressList = [Double]();
                        let dailyAverageWorkingTimeInSeconds = (statistic?.dailyAverageWorkingTime!)!;
                        let currentWorkingTimeInSecodns = (summary?.grandTotalTimeOfCodingInSeconds!)!;
                        let progressWorkingTimeInPercent = (currentWorkingTimeInSecodns / dailyAverageWorkingTimeInSeconds) * 100;
                        dailyProgressList.append(Double(progressWorkingTimeInPercent));
                        if (progressWorkingTimeInPercent > 100) {
                            let increase = progressWorkingTimeInPercent - 100;
                        } else {
                            let decrease = 100 - progressWorkingTimeInPercent;
                            dailyProgressList.append(Double(decrease));
                        }
                        self.halfPieChartFill(halfPieChartView: self.codingDailyAverageHalfPieChartView,
                                              itemsList: dailyProgressList);
                    } else {
                        guard statusForSummary != nil else {
                            self.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.");
                            log.error("Unexpected error without status code.");
                            return
                        }
                        
                        self.showAlertAccordingToStatusCode(statusCode: statusForSummary!);
                        log.error("Unexpected error with statistic request with status code: \(statusForSummary!)");
                    }
                } else {
                    guard statusForStatistic != nil else {
                        self.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.");
                        log.error("Unexpected error without status code.");
                        return
                    }
                    
                    self.showAlertAccordingToStatusCode(statusCode: statusForStatistic!);
                    log.error("Unexpected error with statistic request with status code: \(statusForStatistic!)");
                }
            });
        });
        
    }
    
    func showAlertAccordingToStatusCode(statusCode: Int) {
        switch(statusCode) {
        case 401:
            self.showAlert(alertTitle: "Invalid API key",
                           alertMessage: "Your API key was incorrect. Please, check your API key and enter it again.");
            log.warning("Invalid API key");
        case 403:
            self.showAlert(alertTitle: "Access is denied",
                           alertMessage: "You are authenticated, but do not have permission to access the resource.");
            log.warning("Access is denied");
        case 500...526:
            self.showAlert(alertTitle: "Service unavailable",
                           alertMessage: "Please, try again later.");
            log.warning("Service unavailable");
        default:
            self.showAlert(alertTitle: "Unexpected error", alertMessage: "Please, try again later.")
            log.error("Unexpected error with status code: \(statusCode)");
        }
    }
    
    func showAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .`default`,
                                      handler: { _ in
        }));
        self.present(alert, animated: true, completion: nil);
    }
    

//    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
//        var yValuesForLineChart = [ChartDataEntry]()
//        var yValuesForBarChart = [BarChartDataEntry]()
//        for i in 0..<yValuesLineChart.count {
//            yValuesForLineChart.append(ChartDataEntry(x: Double(i), y: yValuesLineChart[i]));
//            yValuesForBarChart.append(BarChartDataEntry(x: Double(i), y: yValuesBarChart[i]));
//        }
//
//        let lineChartSet = LineChartDataSet(values: yValuesForLineChart, label: "Line Data")
//        let barChartSet: BarChartDataSet = BarChartDataSet(values: yValuesForBarChart, label: "Bar Data")
//
//        let data: CombinedChartData = CombinedChartData();
//        data.barData = BarChartData(dataSets: [barChartSet]);
//        data.lineData = LineChartData(dataSets: [lineChartSet]);
//        codingActivityCombinedChartView.data = data;
//        codingActivityCombinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues);
//        codingActivityCombinedChartView.xAxis.granularity = 1;
//        setUpCombinedChartView(combinedChartView: codingActivityCombinedChartView);
//    }
    
    func pieChartFill(pieChartView: PieChartView, itemsList: [EntrySummary]) {
        var entryWorkingTimeItem = [PieChartDataEntry]();
        for item in itemsList {
            let entry = PieChartDataEntry(value: Double(item.workingTimeInPercent!),
                                          label: "\(item.entryName!)");
            entryWorkingTimeItem.append(entry);
            let dataSet = PieChartDataSet(values: entryWorkingTimeItem,
                                          label: "(\(String(describing: item.workingTimeInPercent!)) %)");
            dataSet.colors = ChartColorTemplates.material();
            let data = PieChartData(dataSet: dataSet);
            pieChartView.data = data;
        }
        if (entryWorkingTimeItem.count > 2) {
            pieChartView.drawEntryLabelsEnabled = false;
        }
        setUpPieChartView(pieChartView: pieChartView);
    }
    
    func halfPieChartFill(halfPieChartView: PieChartView, itemsList: [Double]) {
        var entryWorkingTimeItem = [PieChartDataEntry]();
        for item in itemsList {
            let entry = PieChartDataEntry(value: item,
                                          label: "");
            entryWorkingTimeItem.append(entry);
            let dataSet = PieChartDataSet(values: entryWorkingTimeItem,
                                          label: "");
//            if (itemsList.count == 2) {
//                if (itemsList.first! < 20.0 && itemsList.first! > 0) {
//                    dataSet.colors = [UIColor()]
//                }
//
//            } else {
//                if (itemsList.first == 0) {
//                    dataSet.setColors(UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0));
//                } else {
//                    dataSet.setColors(UIColor(red: 96.0/255.0, green: 176.0/255.0, blue: 68.0/255.0, alpha: 1.0));
//                }
//            }
            dataSet.colors = ChartColorTemplates.material();
            let data = PieChartData(dataSet: dataSet);
            halfPieChartView.data = data;
        }
        setUpPieChartView(pieChartView: halfPieChartView);
        setUpHalfPieChartView(halfPieChartView: halfPieChartView);
    }
//    func setUpCombinedChartView(combinedChartView: CombinedChartView) {
//        combinedChartView.noDataText = "No data to show";
//        combinedChartView.pinchZoomEnabled = false;
//        combinedChartView.isUserInteractionEnabled = true;
//        combinedChartView.legend.enabled = false;
//        combinedChartView.chartDescription?.enabled = false;
//        combinedChartView.drawBordersEnabled = false;
//        combinedChartView.rightAxis.enabled = false;
//        combinedChartView.backgroundColor = UIColor.darkGray;
//        combinedChartView.gridBackgroundColor = UIColor.darkGray;
//        combinedChartView.xAxis.drawGridLinesEnabled = false;
//        combinedChartView.xAxis.labelPosition = .bottom;
//        combinedChartView.leftAxis.drawGridLinesEnabled = false;
//        combinedChartView.leftAxis.drawZeroLineEnabled = true;
//        combinedChartView.xAxis.axisLineColor = .black;
//        combinedChartView.xAxis.labelTextColor = .lightGray;
//        combinedChartView.xAxis.labelFont = UIFont(name: "PingFangSC-Light", size: 12)!;
//        combinedChartView.leftAxis.axisLineColor = .black;
//        combinedChartView.leftAxis.labelTextColor = .lightGray;
//        combinedChartView.leftAxis.minWidth = 0.0;
//        combinedChartView.leftAxis.maxWidth = 24.0;
//        combinedChartView.notifyDataSetChanged();
//    }
    
    func setUpPieChartView(pieChartView: PieChartView) {
        pieChartView.chartDescription?.enabled = false;
        pieChartView.drawHoleEnabled = false;
        pieChartView.noDataText = "No data to show";
        pieChartView.isUserInteractionEnabled = true;
        pieChartView.backgroundColor = UIColor(red: 45.0/255.0, green: 53.0/255.0, blue: 60.0/255.0, alpha: 1.0);
        pieChartView.legend.textColor = UIColor(red: 123.0/255.0, green: 128.0/255.0, blue: 131.0/255.0, alpha: 1.0);
        pieChartView.legend.font = UIFont(name: "PingFangSC-Light", size: 12)!;
        pieChartView.legend.orientation = .vertical
        pieChartView.legend.verticalAlignment = .center;
        pieChartView.legend.horizontalAlignment = .right;
        pieChartView.notifyDataSetChanged();
    }
    
    func setUpHalfPieChartView(halfPieChartView: PieChartView) {
        halfPieChartView.maxAngle = 180;
        halfPieChartView.rotationAngle = 180;
        halfPieChartView.rotationEnabled = false;
        halfPieChartView.holeColor = UIColor(red: 45.0/255.0, green: 53.0/255.0, blue: 60.0/255.0, alpha: 1.0);
        halfPieChartView.holeRadiusPercent = 0.6;
        halfPieChartView.legend.drawInside = false;
        halfPieChartView.drawEntryLabelsEnabled = false;
    }
}
