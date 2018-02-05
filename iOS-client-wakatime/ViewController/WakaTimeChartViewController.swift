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
    
    var editorsList: [EntrySummary]?;
    let statisticController = StatisticController();
    let summaryController = SummaryController();
    var isAuthenticated = false;
    
    @IBOutlet weak var editorPieChartView: PieChartView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                                                    accessGroup: KeychainConfiguration.accessGroup)
            try userSecretAPIKeyItem.deleteItem();
            UserDefaults.standard.set(false, forKey: "hasUserSecretAPIkey");
            self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self);
        }
        catch {
            fatalError("Error deleting keychain item - \(error)")
        }
    }
    
    func getStatisticForLast7Days() {
        statisticController.getUserStatisticsForGivenTimeRange(completionHandler: { statistic, status in
            if (statistic != nil && status == 200) {
                self.editorsList = statistic?.usedEditors!;
                self.editorPieChartUpdate();
            } else {
                switch(status!) {
                case 401:
                    self.showUnauthorizedAlert();
                case 403:
                    self.showForbiddenAlert();
                case 500...526:
                    self.showServerErrorAlert();
                default:
                    log.debug("Something else.");
                }
            }
        });
    }
    
    func showUnauthorizedAlert() {
        let alert = UIAlertController(title: "Invalid API key",
                                      message: "Your API key was incorrect. Please, check your API key and enter it again.",
                                      preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .`default`,
                                      handler: { _ in
        }));
        self.present(alert, animated: true, completion: nil);
    }
    
    func showServerErrorAlert() {
        let alert = UIAlertController(title: "Service unavailable",
                                      message: "Please, try again later.",
                                      preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .`default`,
                                      handler: { _ in
        }));
        self.present(alert, animated: true, completion: nil);
    }
    
    func showForbiddenAlert() {
        let alert = UIAlertController(title: "Access is denied",
                                      message: "You are authenticated, but do not have permission to access the resource.",
                                      preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .`default`,
                                      handler: { _ in
        }));
        self.present(alert, animated: true, completion: nil);
    }
    
    func editorPieChartUpdate() {
        editorPieChartView.chartDescription?.text = "Editors";
        for editor in editorsList! {
            let editorWorkingTimeItem = PieChartDataEntry(value: Double(editor.workingTimeInPercent!),
                                                          label: "\(editor.entryName!)");
            let dataSet = PieChartDataSet(values: [editorWorkingTimeItem],
                                          label: "(\(String(describing: editor.workingTimeInPercent!)) %)");
            let data = PieChartData(dataSet: dataSet);
            editorPieChartView.data = data;
            dataSet.colors = ChartColorTemplates.material();
            setUpEditorPieChartView(pieChartView: editorPieChartView);
        }
    }
    
    func setUpEditorPieChartView(pieChartView: PieChartView) {
        pieChartView.drawHoleEnabled = false;
        pieChartView.noDataText = "The data is loading"
        pieChartView.notifyDataSetChanged();
        pieChartView.isUserInteractionEnabled = true;

        pieChartView.backgroundColor = UIColor.darkGray;
        pieChartView.chartDescription?.textColor = UIColor.white;
        pieChartView.legend.textColor = UIColor.lightGray;

        pieChartView.legend.font = UIFont(name: "Futura", size: 12)!;
        pieChartView.chartDescription?.font = UIFont(name: "Futura", size: 18)!;

        pieChartView.chartDescription?.xOffset = editorPieChartView.frame.width * (0.79);
        pieChartView.chartDescription?.yOffset = editorPieChartView.frame.height * (0.69);
        pieChartView.chartDescription?.textAlign = NSTextAlignment.center;
    }
}
