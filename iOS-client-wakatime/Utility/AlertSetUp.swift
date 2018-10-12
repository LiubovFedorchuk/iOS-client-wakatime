//
//  AlertSetUp.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 10.08.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import Foundation
import UIKit

class AlertSetUp {
    
    func showAlertAccordingToStatusCode(fromController controller: UIViewController,
                                        statusCode: Int) {
        switch(statusCode) {
        case 401:
            let alert = showAlert(alertTitle: "Invalid API key",
                           alertMessage: "Your API key was incorrect. Please, check your API key and enter it again.")
            controller.present(alert, animated: true, completion: nil)
            log.warning("Invalid API key")
        case 403:
            let alert = showAlert(alertTitle: "Access is denied",
                           alertMessage: "You are authenticated, but do not have permission to access the resource.")
            controller.present(alert, animated: true, completion: nil)
            log.warning("Access is denied")
        case 500...526:
            let alert = showAlert(alertTitle: "Service unavailable",
                                  alertMessage: "Please, try again later.")
            controller.present(alert, animated: true, completion: nil)
            log.warning("Service unavailable")
        default:
            let alert = showAlert(alertTitle: "Unexpected error",
                                  alertMessage: "Please, try again later.")
            controller.present(alert, animated: true, completion: nil)
            log.error("Unexpected error with status code: \(statusCode)")
        }
    }
    
    func showAlert(alertTitle: String,
                   alertMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            UserDefaults.standard.set(true, forKey: "AcctionOkPressed")
            log.debug("Ok pressed")
        }
        alert.addAction(okAction)
        return alert
    }
}
