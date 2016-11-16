//
//  PLEvent.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLEvent : PLPricedItem, PLFilterable {
    let picture: NSURL?
    let info: String
    let saleStart: NSDate
    let start: NSDate
    let end: NSDate
    
    required init?(jsonDic: [String : AnyObject]) {
        PLLog(jsonDic, type: .Deserialization)
        guard
            let info = jsonDic[.info] as? String,
            let picture = jsonDic[.picture] as? String,
            let saleStart = jsonDic[.cover_sale_start] as? Double,
            let start = jsonDic[.starts] as? Double,
            let end = jsonDic[.ends] as? Double
        else {
            return nil
        }
        self.info = info
        self.picture = NSURL(string: picture)
        self.saleStart = NSDate(timeIntervalSince1970: saleStart)
        self.start = NSDate(timeIntervalSince1970: start)
        self.end = NSDate(timeIntervalSince1970: end)
        super.init(jsonDic: jsonDic)
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.cover] = String(id)
        dic[.quantity] = String(1) //TODO: - remove it. // added for test
        return dic
    }
    
    static func filter(objc: AnyObject, text: String) -> Bool {return false}
    
    var cellData: PLEventCellData {
        return PLEventCellData(eventID: id, picture: picture, name: name, info: info, saleStart: saleStart, start: start, end: end, price: price)
    }
}

struct PLEventCellData {
    let eventID: UInt64
    let picture: NSURL?
    let name: String
    let info: String
    let saleStart: NSDate
    let start: NSDate
    let end: NSDate
    var price: Float
    
    var available: Bool {
        let availableForSale = NSDate().compare(self.saleStart) == .OrderedDescending
        let ended = isEnded
        return availableForSale && !ended
    }
    
    var isEnded: Bool {
        return NSDate().compare(self.end) == .OrderedDescending
    }
}

