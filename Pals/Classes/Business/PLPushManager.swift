//
//  PLPushManager.swift
//  Pals
//
//  Created by ruckef on 24.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLBadge: PLDeserializable {
    var type: PLPushType
    var count = 0

    required init?(jsonDic: [String : AnyObject]) {
        guard
            let typeNum = jsonDic[.type] as? Int,
            let count = jsonDic[.count] as? Int
        else {
            return nil
        }
        guard
            let type = PLPushType(rawValue: typeNum)
        else {
            return nil
        }
        self.type = type
        self.count = count
    }
    
    init(type: PLPushType, count: Int) {
        self.type = type
        self.count = count
    }
}

class PLPush {
    var badge: PLBadge?
    var id: UInt64?
    var launchedByTap = false
    
    init(type: PLPushType?, id: UInt64, count: Int, byTap: Bool) {
        self.badge = PLBadge(type: type!, count: count)
        self.id = id
        self.launchedByTap = byTap
    }
    
    init(data: [String : AnyObject], launchedByTap: Bool) {
        self.launchedByTap = launchedByTap
        if let type = data[.type] as? Int {
            if let pushType = PLPushType(rawValue: type) {
                if let count = data[.count] as? Int {
                    self.badge = PLBadge(type: pushType, count: count)
                }
            }
        }
        if let id = data[.id] as? Int {
            self.id = UInt64(id)
        }

    }

    // for testing purposes
    class func random() -> PLPush {
        let type = Int((arc4random() % 2) + 1)
        let id = UInt64(arc4random() % 1000)
        let count = Int(arc4random() % 100)
        let byTap = Bool(Int(arc4random() % 2))
        return PLPush(type: PLPushType(rawValue: type), id: id, count: count, byTap: byTap)
    }
    
}

enum PLPushType: Int {
    case Order = 1
    case Friends

    
    var description: String {
        switch self {
        case .Order   : return "Order"
        case .Friends : return "Friends"
        }
    }
    
    var tabBarItem: Int {
        switch self {
        case .Order   : return PLTabBarItem.ProfileItem.rawValue
        case .Friends : return PLTabBarItem.FriendsItem.rawValue
        }
    }
}

let kPLPushManagerDidReceivePush = "kPLPushManagerDidReceivePush"

protocol PLPushSimulation {
    func simulatePushes(settings: PLPushSettings)
}

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
    
    func didReceiveRemoteNotification(userInfo: [NSObject : AnyObject], fetchCompletionHandler
        completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if let userInfo = userInfo as? [String:AnyObject] {
            processPushInfo(userInfo, launchedByTap: false)
        }
        completionHandler(.NewData)
    }
    
    func processLaunchOptions(options: [NSObject : AnyObject]?) {
        if options != nil {
            if let aps = options![UIApplicationLaunchOptionsRemoteNotificationKey] as? [String:AnyObject] {
                processPushInfo(aps, launchedByTap: true)
            }
        }
    }
    
    func processPushInfo(aps: [String:AnyObject], launchedByTap: Bool) {
        PLLog("Received remote notification: \n\(aps)", type: .Pushes)
        if UIApplication.sharedApplication().applicationState == .Active {
            PLShowAlert("Received remote notification", message: aps.description)
        }
        if let pushData = aps[.info] as? [String : AnyObject] {
            let push = PLPush(data: pushData, launchedByTap: launchedByTap)
            if push.badge != nil {
                notifyPush(push)
            }
        }
    }
    
    func notifyPush(push: PLPush) {
        NSNotificationCenter.defaultCenter().postNotificationName(kPLPushManagerDidReceivePush, object: nil)
    }
    
}

extension PLPushManager: PLPushSimulation {
    
    func simulatePushes(settings: PLPushSettings) {
        if settings.simulationEnabled {
            NSTimer.scheduledTimerWithTimeInterval(settings.simulationInterval, target: self, selector: #selector(pushSimulatorFired(_:)), userInfo: nil, repeats: true)
        }
    }
    
    func pushSimulatorFired(timer: NSTimer) {
        let push = PLPush.random()
        PLLog("Generated random push:\n\(push): type: \(push.badge?.type), count: \(push.badge?.count), byTap: \(push.launchedByTap)")
        notifyPush(push)
    }
    
}
