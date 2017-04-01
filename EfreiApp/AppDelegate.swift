//
//  AppDelegate.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 18/01/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    override init() {
        super.init()
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
}
