//
//  PLFacade.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

protocol PLFacadeLocations {
    static func fetchNearRegion(completion: PLLocationRegionCompletion)
    static func fetchNearRegion(size: CGSize, completion: PLLocationRegionCompletion)
}

protocol PLFacadePushes {
    static func didRegisterPushSettings(application: UIApplication, settings: UIUserNotificationSettings)
    static func didFailToRegisterPushSettings(error: NSError)
    static func didReceiveDeviceToken(token: NSData)
    static func didReceiveRemoteNotification(userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
}

protocol PLFacadeRepresentable {
    static func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool
    static func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool
    static func applicationWillResignActive(application: UIApplication)
    static func applicationDidBecomeActive(application: UIApplication)
    static func applicationDidEnterBackground(application: UIApplication)
}

class PLFacade : PLFacadeRepresentable {
    static let instance = _PLFacade()
    static var profile: PLCurrentUser? {
        return instance.profileManager.profile
    }
    
    class func hasValidToken() -> Bool {
        return instance.profileManager.hasValidToken()
    }
    
    class func restoreUserProfile() {
        instance.profileManager.restoreProfile()
    }
    
    //MARK: AppDelegate
    class func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        PLFacade.instance.paymentManager.configure()
        PLFacade.instance.pushManager.registerPushNotifications(application)
        PLFacade.instance.pushManager.processLaunchOptions(launchOptions)
        return PLFacade.instance._application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        
        return PLFacade.instance._application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    class func applicationWillResignActive(application: UIApplication) {
        PLFacade.instance._applicationWillResignActive(application)
    }
    class func applicationDidBecomeActive(application: UIApplication) {
        PLFacade.instance._applicationDidBecomeActive(application)
    }
    class func applicationDidEnterBackground(application: UIApplication) {
        PLFacade.instance._applicationDidEnterBackground(application)
    }
    
    class _PLFacade {
        let settingsManager = PLSettingsManager()
        let locationManager = PLLocationManager()
        let paymentManager = PLPaymentManager()
        let tokenListen = PLTokenListener()
        let profileManager = PLProfileManager()
        let pushManager = PLPushManager()
        
        init() {
            tokenListen.listen(profileManager, tokenType: .UserToken)
            tokenListen.listen(pushManager, tokenType: .DeviceToken)
            pushManager.simulatePushes(settingsManager.pushSettings)
        }
    }
}

extension PLFacade: PLFacadeLocations {
    class func fetchNearRegion(size: CGSize, completion: PLLocationRegionCompletion) {
        instance._fetchNearRegion(size, completion: completion)
    }
    
    class func fetchNearRegion(completion: PLLocationRegionCompletion) {
        instance._fetchNearRegion(completion)
    }
}

extension PLFacade: PLFacadePushes {
    class func didRegisterPushSettings(application: UIApplication, settings: UIUserNotificationSettings) {
        PLFacade.instance.pushManager.didRegisterPushSettings(application, settings: settings)
    }
    class func didFailToRegisterPushSettings(error: NSError) {
        PLFacade.instance.pushManager.didFailToRegisterPushSettings(error)
    }
    class func didReceiveDeviceToken(token: NSData) {
        PLFacade.instance.pushManager.didReceiveDeviceToken(token)
    }
    class func didReceiveRemoteNotification(userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        PLFacade.instance.pushManager.didReceiveRemoteNotification(userInfo, fetchCompletionHandler: completionHandler)
    }
}

extension PLFacade._PLFacade {
    
    func handleErrorCompletion(error: NSError?, errorCompletion: PLErrorCompletion, completion: () -> NSError? ) {
        if error != nil {
            errorCompletion(error: error)
        } else {
            if var error = completion() {
                if error.domain ==  PLErrorDomain.Unknown.string {
                    error = PLError(domain: .User, type: kPLErrorTypeBadResponse)
                }
                errorCompletion(error: error)
            }
        }
    }
    
    func handleUpdateProfile(error: NSError?, dic: [String:AnyObject], completion: PLErrorCompletion) {
        handleErrorCompletion(error, errorCompletion: completion) { () -> NSError? in
            if let response = dic[.response] as? [String : AnyObject] {
                if let userDic = response[.user] as? [String : AnyObject] {
                    if self.profileManager.saveProfile(userDic) {
                        completion(error: nil)
                        return nil
                    }
                }
            }
            return NSError(domain: PLErrorDomain.Unknown.string, code: 0, userInfo: nil)
        }
    }
    
    func handleUserLogin(error: NSError?, dic: [String:AnyObject], completion: PLErrorCompletion) {
        handleErrorCompletion(error, errorCompletion: completion) { () -> NSError? in
            if let response = dic[.response] as? [String : AnyObject] {
                if let userDic = response[.user] as? [String : AnyObject] {
                    let token = response[.token] as? [String : AnyObject]
                    if self.profileManager.saveProfile(userDic) {
                        self.profileManager.saveToken(token)
                        completion(error: nil)
                        return nil
                    }
                }
            }
            return NSError(domain: PLErrorDomain.Unknown.string, code: 0, userInfo: nil)
        }
    }
    
    func handleCheckoutOrder(error: NSError?, dic: [String:AnyObject], completion: PLCheckoutOrderCompletion) {
        if error != nil {
            completion(order: nil, error: error!)
        } else {
            if let order = PLOrder(jsonDic: dic) {
                completion(order: order, error: nil)
            } else {
                completion(order: nil, error: PLError(domain: .Order, type: kPLErrorTypeNewOrderDeserializationFailed))
            }
        }
    }
    
    func _fetchNearRegion(size: CGSize, completion: PLLocationRegionCompletion) {
        locationManager.fetchNearRegion(size, completion: completion)
    }
    func _fetchNearRegion(completion: PLLocationRegionCompletion) {
        locationManager.fetchNearRegion(completion)
    }
    
    func _application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return false
    }
    func _application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)

        return handled
    }
    func _applicationWillResignActive(application: UIApplication) { }
    func _applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    func _applicationDidEnterBackground(application: UIApplication) { }
}