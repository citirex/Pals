//
//  AppDelegate.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isUserLoggedIn = true // for testing, remove


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Appearance
        UITabBar.appearance().tintColor = .whiteColor()

        let initialViewController = isUserLoggedIn ? UIStoryboard.tabBarController() : UIStoryboard.loginViewController()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        return true 
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
       
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }
    
}

