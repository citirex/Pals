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
    var isUserLoggedIn = false // for testing, remove


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let mainStoryboardIpad = UIStoryboard(name: "Main", bundle: nil)
        let viewControllerIdentifier = (isUserLoggedIn == true) ? "TabBarController" : "Login" // fix to show login or tabbar
        let initialViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier(viewControllerIdentifier) as UIViewController
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        
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

