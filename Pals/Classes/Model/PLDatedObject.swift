//
//  PLDatedObject.swift
//  Pals
//
//  Created by ruckef on 29.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLDatedObject: PLUniqueObject {
    var date: NSDate?
    
    required init?(jsonDic: [String : AnyObject]) {
        if let timestamp = jsonDic[PLKeys.date.string] as? NSTimeInterval {
            date = NSDate(timeIntervalSince1970: timestamp)
            PLLog("\(self.dynamicType) \(date!)", type: .Initialization)
        }
        super.init(jsonDic: jsonDic)
    }
}
