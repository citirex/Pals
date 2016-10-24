//
//  PLPushManager.swift
//  Pals
//
//  Created by ruckef on 24.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

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
    }
}
