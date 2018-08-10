//
//  AlertSetUp.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 10.08.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import Foundation
import UIKit

class AlertSetUp: UIAlertController {
    
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
}
