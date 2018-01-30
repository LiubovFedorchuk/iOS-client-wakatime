//
//  WakaTimeDiagramViewController.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 23.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import UIKit
import SwiftyBeaver
import ObjectMapper

class WakaTimeDiagramViewController: UIViewController {
    
    var isAuthenticated = false;
    let statisticController = StatisticController();
    let summaryController = SummaryController();
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Something happened", message: "Please.", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
        }));
        self.present(alert, animated: true, completion: nil);
    }
    

    override func viewDidAppear(_ animated: Bool) {
        let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey");
        if (!hasLogin) {
         self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self);
        } else {
            statisticController.getUserStatisticsForGivenTimeRange(completionHandler: { statistic, status in
                if (statistic != nil && status == 200) {
                    log.debug(statistic!);
                    let statisticJSON = Mapper<Statistic>().toJSONString(statistic!, prettyPrint: true);
                    log.debug(statisticJSON!);
                } else {
                    //TODO: create specific alerts for all status code
                    switch(status) {
                    //TODO: 401 - Unauthorized: The request requires authentication, or your authentication was invalid.
                    case 401:
                        self.showAlert();
                    default:
                        log.debug("something else");
                    }
                }
            });
            
            summaryController.getUserSummariesForGivenTimeRange(completionHandler: {summary, status in
                if (summary != nil && status == 200) {
                    log.debug(summary!);
                    let summaryJSON = Mapper<Summary>().toJSONString(summary!, prettyPrint: true);
                    log.debug(summaryJSON!);
                    
//                    let summJSON = Mapper<Summary>().toJSONString([summary], prettyPrint: true)
//                    let summJSON = Mapper<Summary>().toJSONString(summary!, prettyPrint: true);
//                    log.debug(summJSON!);
                   
                } else {
                    //TODO: create specific alerts for all status code
                    switch(status) {
                    //TODO: 401 - Unauthorized: The request requires authentication, or your authentication was invalid.
                    case 401:
                        self.showAlert();
                    default:
                        log.debug(status);
                        log.debug("something goes wrong.");
                    }
                }
            })
            
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
}

