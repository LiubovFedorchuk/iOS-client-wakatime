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
    
    @IBOutlet weak var editorPieChartView: PieChartView!;
    @IBOutlet weak var languagePieChartView: PieChartView!;
    @IBOutlet weak var operatingSystemPieChartView: PieChartView!;
    
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
                                  title: "Languages",
                                  itemsList: (statistic?.usedLanguages)!);
                self.pieChartFill(pieChartView: self.editorPieChartView,
                                    title: "Editors",
                                    itemsList: (statistic?.usedEditors)!);
                self.pieChartFill(pieChartView: self.operatingSystemPieChartView,
                                  title: "Operating Systems",
                                  itemsList: (statistic?.usedOperatingSystems)!);
            } else {
                switch(status!) {
                case 401:
                    self.showAlert(alertTitle: "Invalid API key",
                                   alertMessage: "Your API key was incorrect. Please, check your API key and enter it again.");
                case 403:
                    self.showAlert(alertTitle: "Access is denied",
                                   alertMessage: "You are authenticated, but do not have permission to access the resource.");
                case 500...526:
                    self.showAlert(alertTitle: "Service unavailable",
                                   alertMessage: "Please, try again later.");
                default:
                    log.error("Unexpected error with status code: \(status!)");
                }
            }
        });
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
    
    func pieChartFill(pieChartView: PieChartView, title: String, itemsList: [EntrySummary]) {
        pieChartView.chartDescription?.text = title;
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
    
    func setUpPieChartView(pieChartView: PieChartView) {
        pieChartView.drawHoleEnabled = false;
        pieChartView.noDataText = "The data is loading"
        pieChartView.notifyDataSetChanged();
        pieChartView.isUserInteractionEnabled = true;

        pieChartView.backgroundColor = UIColor.darkGray;
        pieChartView.chartDescription?.textColor = UIColor.white;
        pieChartView.legend.textColor = UIColor.lightGray;

        pieChartView.legend.font = UIFont(name: "PingFangSC-Light", size: 12)!;
        pieChartView.chartDescription?.font = UIFont(name: "PingFangSC-Light", size: 18)!;

        pieChartView.chartDescription?.xOffset = pieChartView.frame.width * (0.53);
        pieChartView.chartDescription?.yOffset = pieChartView.frame.height * (0.69);
    }
}
