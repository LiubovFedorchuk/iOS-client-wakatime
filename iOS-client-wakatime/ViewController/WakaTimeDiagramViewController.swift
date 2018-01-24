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

class WakaTimeDiagramViewController: UIViewController {
    
    var isAuthenticated = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let hasLogin = UserDefaults.standard.bool(forKey: "hasUserSecretAPIkey");
        if (!hasLogin) {
         self.performSegue(withIdentifier: "showWakaTimeLoginView", sender: self);
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

