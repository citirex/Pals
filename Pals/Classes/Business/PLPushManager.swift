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
    init(data: [String : AnyObject]) {
        if let type = data[PLKeys.type.string] as? String {
            if let pushType = PLPushType(rawValue: Int(type)!) {
                self.type = pushType
            }
        }
        if let id = data[PLKeys.id.string] as? String {
            self.id = UInt64(id)
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
    var notificationName: String {
        switch self {
        case .Order:
            return "PLPushNotificationOrder"
        case .Friend:
            return "PLPushNotificationFriend"
        }
    }
}

class PLPushManager {

    var deviceToken: String?
    
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
            //TODO: show alert to go to Settings to activate pushes
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
        PLLog("Received remote notification: \n\(info)", type: .Pushes)
        PLShowAlert("Received remote notification", message: info.description)
        if let aps = info["aps"] as? [String : AnyObject]{
            if let pushData = aps[PLKeys.info.string] as? [String : AnyObject] {
                let push = PLPush(data: pushData)
                if let type = push.type {
                    PLLog("Push notification type: \(type.description)", type: .Pushes)
                    NSNotificationCenter.defaultCenter().postNotificationName(type.notificationName, object: push as? AnyObject, userInfo: nil)
                }
            }
            
        }
    }
}
