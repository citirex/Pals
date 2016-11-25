//
//  PLSettingsManager.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLSettingKey: String {
    case FakeFeeds
    case Logs
    case Server
    case DefaultUser
    
    case Enabled
    case LoadDelay
    case Level
    case Login
    case Password
    case ActiveServer
    case EnableBalanceCheck
    case PushSimulation
    case Interval
    
    case Location
    case ShouldFetchLocation
    
    var str: String {return rawValue}
}

struct PLDefaultUser {
    var login: String
    var password: String
}

struct PLPushSettings {
    let simulationEnabled: Bool
    let simulationInterval: NSTimeInterval
}

class PLSettingsManager {
    
    var dict = [String:AnyObject]()
    
    var useFakeFeeds: Bool {
        var use = false
        if let fakeFeedsDic = self[.FakeFeeds] {
            use = fakeFeedsDic[PLSettingKey.Enabled.str] as! Bool
        }
        return use
    }
    
    var fakeFeedLoadDelay: NSTimeInterval {
        var delay = 0.0
        if let fakeFeedsDic = self[.FakeFeeds] {
            delay = fakeFeedsDic[PLSettingKey.LoadDelay.str] as! NSTimeInterval
        }
        return delay
    }
    
    var loggingEnabled: Bool {
        var enabled = false
        if let logsDic = self[.Logs] {
            enabled = logsDic[PLSettingKey.Enabled.str] as! Bool
        }
        return enabled
    }
    
    var logLevel: Int {
        var level = NSNumber(integer: 0)
        if let logsDic = self[.Logs] {
            level = logsDic[PLSettingKey.Level.str] as! NSNumber
        }
        return level.integerValue
    }
    
    var balanceCheckEnabled: Bool {
        var enabled = false
        if let dic = self[.DefaultUser] {
            enabled = dic[PLSettingKey.EnableBalanceCheck.str] as! Bool
        }
        return enabled
    }
    
    var server: String {
        if let serverDic = self[.Server] {
            if let servers = serverDic[PLSettingKey.ActiveServer.str] as? [String : Bool] {
                for (name, enabled) in servers {
                    if enabled {
                        return name
                    }
                }
                return servers.first!.0
            }
        }
        return ""
    }
    
    var defaultUser: PLDefaultUser? {
        if let userDic = self[.DefaultUser] {
            if let enabled = userDic[PLSettingKey.Enabled.str] as? Bool {
                if enabled {
                    let login = userDic[PLSettingKey.Login.str] as? String
                    let pass = userDic[PLSettingKey.Password.str] as? String
                    if login != nil && pass != nil {
                        return PLDefaultUser(login: login!, password: pass!)
                    }
                }
            }
        }
        return nil
    }
    
    var pushSettings: PLPushSettings {
        var enabled = false
        var interval: NSTimeInterval = 0
        if let settings = self[.PushSimulation] {
            if let en = settings[PLSettingKey.Enabled.str] as? Bool {
                enabled = en
            }
            if let inv = settings[PLSettingKey.Interval.str] as? NSNumber {
                interval = inv.doubleValue
            }
        }
        return PLPushSettings(simulationEnabled: enabled, simulationInterval: interval)
    }
    
    var shouldFetchLocation: Bool {
        if let locationDic = self[.Location] {
            if let should = locationDic[PLSettingKey.ShouldFetchLocation.str] as? Bool {
                return should
            }
        }
        return true
    }
    
    subscript(key: PLSettingKey) -> [String : AnyObject]? {
        return dict[key.str] as? [String : AnyObject]
    }
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("config", ofType: "plist") {
            dict = NSDictionary(contentsOfFile: path) as! [String : AnyObject]
        }
    }
    
}