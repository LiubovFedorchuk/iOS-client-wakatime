//
//  AppDelegate.swift
//  iOS-client-wakatime
//
//  Created by Liubov Fedorchuk on 17.01.2018.
//  Copyright © 2018 Liubov Fedorchuk. All rights reserved.
//

import UIKit
import SwiftyBeaver

public let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        log.addDestination(console)
        return true
    }
}

