//
//  AppDelegate.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 18.03.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.statusBarStyle = .lightContent
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SheepDataService.saveContext()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        HandlerAppDelegate.sharedInstance.appDidBecomeActive()
    }

}

