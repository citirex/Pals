//
//  PLSettingsManager.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

class PLSettingsManager {
    
    var dict = [String:AnyObject]()
    var useFakeFeeds: Bool {
        let use = dict["UseFakeFeeds"] as! Bool
        return use
    }
    var fakeFeedLoadDelay: NSTimeInterval {
        let delay = dict["FakeFeedLoadDelay"] as! NSTimeInterval
        return delay
    }
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("config", ofType: "plist") {
            dict = NSDictionary(contentsOfFile: path) as! [String : AnyObject]
        }
    }
}