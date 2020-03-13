//
//  AppDelegate.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/15/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow()
        MWI.sh.setup(window: self.window)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CDM.sh.saveContext()
    }
}

