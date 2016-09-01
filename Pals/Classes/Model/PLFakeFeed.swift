//
//  PLFakeFeed.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

typealias PLFakeFeedCompletion = (dict: [String : AnyObject]) -> ()

class PLFakeFeed {
    let service: PLAPIService
    var delay: NSTimeInterval = PLFacade.instance.settingsManager.fakeFeedLoadDelay
    
    init(service: PLAPIService) {
        self.service = service
    }
    
    func load (completion: PLFakeFeedCompletion) {
        let after = Int64(delay * NSTimeInterval(NSEC_PER_SEC))
        let time = dispatch_time(DISPATCH_TIME_NOW, after)
        dispatch_after(time, dispatch_get_main_queue(), {
            let filename = self.service.string
            if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
                let data = NSData(contentsOfFile: path)!
                let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String : AnyObject]
                completion(dict: dict)
            } else {
                completion(dict: [:])
            }
        })
    }
}
