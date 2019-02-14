//
//  WakaTimeLoginViewController.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 17.01.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import UIKit

class WakaTimeLoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var userSecretAPIkeyTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let alertSetUp = AlertSetUp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Connectivity.isConnectedToInternet {
            let alert = alertSetUp.showAlert(alertTitle: "No Internet Conection", alertMessage: "Turn on cellural data or use Wi-Fi to access data.")
            self.present(alert, animated: true, completion: nil)
        } else {
            let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey")
            if (hasLogin) {
                performSegue(withIdentifier: "dismissWakaTimeLoginView", sender: self)
            }
            self.userSecretAPIkeyTextField.delegate = self
            loginButtonSetUp(button: loginButton)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func loginButtonSetUp(button: UIButton) {
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 48.0/255.0,
                                           green: 79.0/255.0,
                                           blue: 100.0/255.0,
                                           alpha: 1.0).cgColor
    }
    
    //TODO: implement API key validation before moving to another view.
    @IBAction func loginWakaTimeButtonTapped(_ sender: Any) {
        let newUserSecretAPIkey = userSecretAPIkeyTextField.text
        UserDefaults.standard.set(false, forKey: "hasUserSecretAPIkey")
        
        if((newUserSecretAPIkey?.isEmpty)!) {
            let alert = self.alertSetUp.showAlert(alertTitle: "Text field is empty",
                                  alertMessage: "Please, enter your secret API key.")
            self.present(alert, animated: true, completion: nil)
        } else {
            let userController = UserController()
            let keychainManager = KeychainManager()
            let headers = keychainManager.createAuthorizationHeadersForRequest(userApiKey: newUserSecretAPIkey)
            userController.getUser(headers: headers, completionHandler: { status in
                if (status == 200) {
                    do {
                        // This is a new account, create a new keychain item.
                        let userSecretAPIKeyItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
                        
                        // Save the userSecretAPIkey for the new item.
                        try userSecretAPIKeyItem.savePassword(newUserSecretAPIkey!)
                    } catch {
                        fatalError("Error updating keychain - \(error)")
                    }
                    UserDefaults.standard.set(true, forKey: "hasUserSecretAPIkey")
                    self.performSegue(withIdentifier: "dismissWakaTimeLoginView", sender: self)
//                    self.transition(Sender: self.loginButton)
                    log.debug("API key is valid")
                } else {
                    self.alertSetUp.showAlertAccordingToStatusCode(fromController: self, statusCode: status!)
                }
            })
        }
    }
}


