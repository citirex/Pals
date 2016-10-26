//
//  PLFacade.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

typealias PLErrorCompletion = (error: NSError?) -> ()
typealias PLCheckoutOrderCompletion = (order: PLOrder?, error: NSError?) -> ()

protocol PLFacadeInterface {
    static func login(userName:String, password: String, completion: PLErrorCompletion)
    static func loginFB(completion: PLErrorCompletion)
    static func logout(completion: PLErrorCompletion)
    static func signUp(data: PLSignUpData, completion: PLErrorCompletion)
    static func sendOrder(order: PLCheckoutOrder, completion: PLCheckoutOrderCompletion)
    static func updateProfile(data: PLEditUserData, completion: PLErrorCompletion)
    static func unfriend(user: PLUser, completion: PLErrorCompletion)
    static func addFriend(user: PLUser, completion: PLErrorCompletion)
    static func sendPassword(email: String, completion: PLErrorCompletion)
    static func fetchNearRegion(completion: PLLocationRegionCompletion)
    static func fetchNearRegion(size: CGSize, completion: PLLocationRegionCompletion)
    static var profile: PLCurrentUser? {get}
}

protocol PLFacadePushes {
    static func didRegisterPushSettings(application: UIApplication, settings: UIUserNotificationSettings)
    static func didFailToRegisterPushSettings(error: NSError)
    static func didReceiveDeviceToken(token: NSData)
    static func didReceiveRemoteNotification(info: [NSObject : AnyObject])
}


protocol PLFacadeRepresentable {
    static func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool
    static func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool
    static func applicationWillResignActive(application: UIApplication)
    static func applicationDidBecomeActive(application: UIApplication)
    static func applicationDidEnterBackground(application: UIApplication)
}



class PLFacade : PLFacadeInterface,PLFacadeRepresentable {
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
    
    class func login(userName:String, password: String, completion: PLErrorCompletion) {
        instance._login(userName, password: password, completion: completion)
    }
    
    class func loginFB(completion: PLErrorCompletion) {
        instance._loginFB(completion)
    }
    
    class func logout(completion: PLErrorCompletion) {
        instance._logout(completion)
    }
    
    class func signUp(data: PLSignUpData, completion: PLErrorCompletion) {
        instance._signUp(data, completion: completion)
    }
    
    class func sendPassword(email: String, completion: PLErrorCompletion) {
        instance._sendPassword(email, completion: completion)
    }
    
    class func updateProfile(data: PLEditUserData, completion: PLErrorCompletion) {
        instance._updateProfile(data, completion: completion)
    }
    
    class func unfriend(user: PLUser, completion: PLErrorCompletion) {
        instance._unfriend(user, completion: completion)
    }
    
    class func addFriend(user: PLUser, completion: PLErrorCompletion) {
        instance._addFriend(user, completion: completion)
    }
    
    class func sendOrder(order: PLCheckoutOrder, completion: PLCheckoutOrderCompletion) {
        instance._sendOrder(order, completion: completion)
    }
    
    class func fetchNearRegion(size: CGSize, completion: PLLocationRegionCompletion) {
        instance._fetchNearRegion(size, completion: completion)
    }
    
    class func fetchNearRegion(completion: PLLocationRegionCompletion) {
        instance._fetchNearRegion(completion)
    }
    
    //MARK: AppDelegate
    class func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        PLFacade.instance.pushManager.registerPushNotifications(application)
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
        let profileManager  = PLProfileManager()
        let pushManager = PLPushManager()
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
    class func didReceiveRemoteNotification(info: [NSObject : AnyObject]) {
        PLFacade.instance.pushManager.didReceiveRemoteNotification(info)
    }
}

extension PLFacade._PLFacade {
    
    func _signUp(data: PLSignUpData, completion: PLErrorCompletion) {
        let params = data.params
        let attachment = PLUploadAttachment.pngImage(data.picture)
        PLNetworkManager.post(.SignUp, parameters: params, attachment: attachment) { (dic, error) in
            self.handleUserLogin(error, dic: dic, completion: completion)
        }
    }
    
    func _login(userName:String, password: String, completion: PLErrorCompletion) {
        let params = [PLKeys.login.string : userName, PLKeys.password.string : password]
        PLNetworkManager.get(.Login, parameters: params) { (dic, error) in
            self.handleUserLogin(error, dic: dic, completion: completion)
        }
    }
    
    func _loginFB(completion: PLErrorCompletion) {
        profileManager.loginFB { (data, error) in
            if data != nil {
                let params = data!.params
                PLNetworkManager.postWithAttributes(.LoginFB, attributes: params) { (dic, error) in
                    self.handleUserLogin(error, dic: dic, completion: completion)
                }
            } else {
                completion(error: error)
            }
        }
    }
    
    func _logout(completion: PLErrorCompletion) {
        PLNetworkManager.get(PLAPIService.Logout, parameters: nil) { (dic, error) in
            if let success = dic[PLKeys.dinosaur.string] as? Bool {
                if success {
                    self.profileManager.resetProfileAndToken()
                    completion(error: nil)
                    return
                }
            }
            completion(error: error)
        }
    }
    
    func _sendPassword(email: String, completion: PLErrorCompletion) {
        let params = [PLKeys.email.string : email]
        PLNetworkManager.postWithAttributes(.SendPassword, attributes: params) { (dic, error) in
            PLNetworkManager.handleFullResponse(dic, error: error, completion: completion)
        }
    }
    
    func _updateProfile(data: PLEditUserData, completion: PLErrorCompletion) {
        let params = data.params
        let attachment = data.attachment
        PLNetworkManager.post(PLAPIService.UpdateProfile, parameters: params, attachment: attachment) { (dic, error) in
            self.handleUpdateProfile(error, dic: dic, completion: completion)
        }
    }
    
    func _unfriend(user: PLUser, completion: PLErrorCompletion) {
        let params = [PLKeys.friend_id.string : NSNumber(unsignedLongLong: user.id)]
        PLNetworkManager.postWithAttributes(PLAPIService.Unfriend, attributes: params) { (dic, error) in
            PLNetworkManager.handleSuccessResponse(dic, completion: { (error) in
                if error == nil {
                    user.invited = false
                }
                completion(error: error)
            })
        }
    }
    
    func _addFriend(user: PLUser, completion: PLErrorCompletion) {
        user.inviting = true
        let params = [PLKeys.friend_id.string : NSNumber(unsignedLongLong: user.id)]
        PLNetworkManager.postWithAttributes(PLAPIService.AddFriend, attributes: params) { (dic, error) in
            user.inviting = false
            PLNetworkManager.handleSuccessResponse(dic, completion: { (error) in
                if error == nil {
                    user.invited = true
                }
                completion(error: error)
            })
        }
    }
    
    func _sendOrder(order: PLCheckoutOrder, completion: PLCheckoutOrderCompletion) {
        let params = order.serialize()
        

        PLNetworkManager.postWithAttributes(PLAPIService.Orders, attributes: params) { (dic, error) in
            self.handleCheckoutOrder(error, dic: dic, completion: completion)
        }
    }
    
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
            if let response = dic[PLKeys.response.string] as? [String : AnyObject] {
                if let userDic = response[PLKeys.user.string] as? [String : AnyObject] {
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
            if let response = dic[PLKeys.response.string] as? [String : AnyObject] {
                if let userDic = response[PLKeys.user.string] as? [String : AnyObject] {
                    let token = response[PLKeys.token.string] as? [String : AnyObject]
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
                completion(order: nil, error: PLError(domain: .User, type: kPLErrorTypeCheckoutFailed))
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