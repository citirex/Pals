//
//  PLFakeFeed.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

typealias PLFakeFeedCompletion = (dict: [String : AnyObject]) -> ()

class PLFakeFeed {
    class func load(name: String, completion: PLFakeFeedCompletion) {
        let delay: NSTimeInterval = PLFacade.instance.settingsManager.fakeFeedLoadDelay
        let after = Int64(delay * NSTimeInterval(NSEC_PER_SEC))
        let time = dispatch_time(DISPATCH_TIME_NOW, after)
        dispatch_after(time, dispatch_get_main_queue(), {
            let filename = name
            if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
                let data = NSData(contentsOfFile: path)!
                let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String : AnyObject]
                print("Loaded fake feed: \(filename).json")
                completion(dict: dict)
            } else {
                completion(dict: [:])
            }
        })
    }
}
