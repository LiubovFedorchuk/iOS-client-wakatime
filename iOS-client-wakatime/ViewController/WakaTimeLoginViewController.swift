//
//  WakaTimeLoginViewController.swift
//  iOS-client-wakatime
//
//  Created by dorovska on 17.01.2018.
//  Copyright © 2018 dorovska. All rights reserved.
//

import UIKit
import ObjectMapper

class WakaTimeLoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var userSecretAPIkeyTextField: UITextField!;
    @IBOutlet weak var loginButton: UIButton!;
    @IBOutlet weak var userPasswordTextField: UITextField!;
    @IBOutlet weak var userEmailTextField: UITextField!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.userSecretAPIkeyTextField.delegate = self;
        loginButtonSetUp(button: loginButton);
        let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey");
        if (hasLogin) {
            performSegue(withIdentifier: "dismissWakaTimeLoginView", sender: self);
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func loginButtonSetUp(button: UIButton) {
        button.layer.cornerRadius = 7;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor(red: 48.0/255.0,
                                           green: 79.0/255.0,
                                           blue: 100.0/255.0,
                                           alpha: 1.0).cgColor;
    }
    
    //TODO: implement API key validation before moving to another view.
    @IBAction func loginWakaTimeButtonTapped(_ sender: Any) {
        let newUserSecretAPIkey = userSecretAPIkeyTextField.text;
        if(newUserSecretAPIkey?.isEmpty)! {
            let alert = UIAlertController(title: "Text field is empty", message: "Please, enter your secret API key.", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            }));
            self.present(alert, animated: true, completion: nil);
        } else {
            do {
                // This is a new account, create a new keychain item.
                let userSecretAPIKeyItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
                // Save the userSecretAPIkey for the new item.
                try userSecretAPIKeyItem.savePassword(newUserSecretAPIkey!);
            } catch {
                fatalError("Error updating keychain - \(error)");
            }
            UserDefaults.standard.set(true, forKey: "hasUserSecretAPIkey");
            performSegue(withIdentifier: "dismissWakaTimeLoginView", sender: self);
        }
    }
}

