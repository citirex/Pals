//
//  PLSettingsManager.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLSettingsManager : NSObject {
    
    var dict = [String:AnyObject]()
    var useFakeFeeds: Bool {
        let use = dict["UseFakeFeeds"] as! Bool
        return use
    }
    var fakeFeedLoadDelay: NSTimeInterval {
        let delay = dict["FakeFeedLoadDelay"] as! NSTimeInterval
        return delay
    }
    var loggingEnabled: Bool {
        let enabled = dict["LoggingEnabled"] as! Bool
        return enabled
    }
    
    var logLevel: Int {
        let level = dict["LogLevel"] as! NSNumber
        return level.integerValue
    }
    
    var ud: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    var token: String? {
        didSet {
            ud.setObject(token, forKey: PLKeys.token.string)
            ud.synchronize()
        }
    }
    
    override init() {
        super.init()
        if let path = NSBundle.mainBundle().pathForResource("config", ofType: "plist") {
            dict = NSDictionary(contentsOfFile: path) as! [String : AnyObject]
        }
        token = ud.stringForKey(PLKeys.token.string)
    }
}