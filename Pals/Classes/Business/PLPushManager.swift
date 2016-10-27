//
//  PLPushManager.swift
//  Pals
//
//  Created by ruckef on 24.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

struct PLPush {
    var type: PLPushType?
    var id: UInt64?
    var count = 0
    var launchedByTap = false
    
    init(data: [String : AnyObject], launchedByTap: Bool) {
        self.launchedByTap = launchedByTap
        if let type = data[PLKeys.type.string] as? String {
            if let pushType = PLPushType(rawValue: Int(type)!) {
                self.type = pushType
            }
        }
        if let id = data[PLKeys.id.string] as? String {
            self.id = UInt64(id)
        }
        if let countStr = data[PLKeys.count.string] as? String {
            if let count = Int(countStr) {
                self.count = count
            }
        }
    }
}

enum PLPushType : Int {
    case Order = 1
    case Friend
    var description: String {
        switch self {
        case .Order:
            return "Order"
        case .Friend:
            return "Friend"
        }
    }
}

let kPLPushManagerDidReceivePush = "kPLPushManagerDidReceivePush"

class PLPushManager: NSObject {

    dynamic var deviceToken: String?
    
    func registerPushNotifications(application: UIApplication) {
        let types: UIUserNotificationType = [.Badge, .Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    func didRegisterPushSettings(application: UIApplication, settings: UIUserNotificationSettings) {
        if settings.types != .None {
            application.registerForRemoteNotifications()
        } else {
            PLLog("User disallowed Pushes", type: .Pushes)
        }
    }
    
    func didFailToRegisterPushSettings(error: NSError) {
        PLLog(error.localizedDescription, type: .Pushes)
    }
    
    func didReceiveDeviceToken(token: NSData) {
        deviceToken = token.hexString()
        PLLog("Did receive device token: \(deviceToken!)", type: .Pushes)
    }
    
    func didReceiveRemoteNotification(info: [NSObject : AnyObject]) {
        if let anInfo = info as? [String:AnyObject] {
            processPushInfo(anInfo, launchedByTap: false)
        }
    }
    
    func processLauchOptions(options: [NSObject : AnyObject]?) {
        if options != nil {
            if let aps = options![UIApplicationLaunchOptionsRemoteNotificationKey] as? [String:AnyObject] {
                processPushInfo(aps, launchedByTap: true)
            }
        }
    }
    
    func processPushInfo(aps: [String:AnyObject], launchedByTap: Bool) {
        PLLog("Received remote notification: \n\(aps)", type: .Pushes)
        PLShowAlert("Received remote notification", message: aps.description)
        if let pushData = aps[PLKeys.info.string] as? [String : AnyObject] {
            let push = PLPush(data: pushData, launchedByTap: launchedByTap)
            if let type = push.type {
                PLLog("Push notification type: \(type.description)", type: .Pushes)
                NSNotificationCenter.defaultCenter().postNotificationName(kPLPushManagerDidReceivePush, object: push as? AnyObject, userInfo: nil)
            }
        }
    }
    
}