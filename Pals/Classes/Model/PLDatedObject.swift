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
        if let timestamp = jsonDic[.date] as? NSTimeInterval {
            date = NSDate(timeIntervalSince1970: timestamp)
            PLLog("\(self.dynamicType) \(date!)", type: .Initialization)
        }
        super.init(jsonDic: jsonDic)
    }
    
    func hasSameDateType(obj: PLDatedObject) -> Bool {
        return compareDateType(obj) == .OrderedSame
    }
    
    func compareDateType(obj: PLDatedObject) -> NSComparisonResult {
        let firstDT = date?.dateType
        let lastDT = obj.date?.dateType
        if firstDT == nil || lastDT == nil {
            return .OrderedSame
        }
        let first = firstDT!.rawValue
        let last = lastDT!.rawValue
        if first == last {
            return .OrderedSame
        } else if first < last {
            return .OrderedDescending
        } else {
            return .OrderedAscending
        }
    }
}
