//
//  AppDelegate.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        PLFacade.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        IQKeyboardManager.sharedManager().enable = true

        var initialViewController: UIViewController?
        if PLFacade.hasValidToken() {
            PLFacade.restoreUserProfile()
            initialViewController = UIStoryboard.tabBarController()
        } else {
            initialViewController = UIStoryboard.loginViewController()
        }
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        return true 
    }

    func applicationWillResignActive(application: UIApplication) {
        PLFacade.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        PLFacade.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(application: UIApplication) {
       
    }

    func applicationDidBecomeActive(application: UIApplication) {
        PLFacade.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return PLFacade.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
//    - (BOOL)application:(UIApplication *)app
//    openURL:(NSURL *)url
//    options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
//    
//    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
//    openURL:url
//    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
//    ];
//    // Add any custom logic here.
//    return handled;
//    }
    
}

