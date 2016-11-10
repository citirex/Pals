//
//  PLEvent.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLEvent : PLDatedObject, PLFilterable {
    let picture: NSURL
    let info: String
    let start: NSDate
    let end: NSDate
    
    required init?(jsonDic: [String : AnyObject]) {
        PLLog(jsonDic, type: .Deserialization)
        guard
            let ePicture = jsonDic[.picture] as? String,
            let eInfo = jsonDic[.info] as? String,
            let start = jsonDic[.starts] as? Double,
            let end = jsonDic[.ends] as? Double
        else {
            return nil
        }
        self.picture = NSURL(string: ePicture)!
        self.info = eInfo
        self.start = NSDate(timeIntervalSince1970: start)
        self.end = NSDate(timeIntervalSince1970: end)
        super.init(jsonDic: jsonDic)
    }
    
    static func filter(objc: AnyObject, text: String) -> Bool {return false}
    
    var cellData: PLEventCellData {
        return PLEventCellData(eventID: id, picture: picture, info: info, start: start, end: end)
    }
}

struct PLEventCellData {
    let eventID: UInt64
    let picture: NSURL
    let info: String
    let start: NSDate
    let end: NSDate
}

