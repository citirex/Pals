//
//  PLCover.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/16/16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLItemKeyable {
    static var itemKey: PLKey {get}
}

class PLPricedItem: PLDatedObject, PLItemKeyable {
    var name: String
    var price = Float(0)
    var expiryDate: NSDate
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let name = jsonDic[.name] as? String
        else {
            return nil
        }
        self.name = name
        if let price = jsonDic[.price] as? Float {
            self.price = price
        }
        
        guard let duration = jsonDic[.duration] as? Int else { return nil }
        let dateComponents = NSDateComponents()
        dateComponents.second = duration
        
        let calendar = NSCalendar.currentCalendar()
        self.expiryDate = calendar.dateByAddingComponents(dateComponents, toDate: NSDate(), options: [])!

        super.init(jsonDic: jsonDic)
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.name] = name
        dic[.price] = price
        dic.append(super.serialize())
        return dic
    }
    
    class var itemKey: PLKey {return .any}
}
