//
//  PLEvent.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLEvent : PLUniqueObject, PLFilterable {
    
    let placeID: UInt64
    let picture: NSURL
    let date: NSDate
    let info: String
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let ePlaceID = jsonDic[PLKeys.place_id.string] as? NSNumber,
            let ePicture = jsonDic[PLKeys.picture.string] as? String,
            let eDate = jsonDic[PLKeys.date.string] as? Double,
            let eInfo = jsonDic[PLKeys.info.string] as? String
            else {
                return nil
        }
        
        self.placeID = ePlaceID.unsignedLongLongValue
        self.picture = NSURL(string: ePicture)!
        self.date = NSDate(timeIntervalSince1970: eDate)
        self.info = eInfo
        super.init(jsonDic: jsonDic)
    }
    
    static func filter(objc: AnyObject, text: String) -> Bool {return false}
    
    var cellData: PLEventCellData {
        return PLEventCellData(eventID: id, placeID: placeID, picture: picture, date: date, info: info)
    }
    
}

struct PLEventCellData {
    let eventID: UInt64
    let placeID: UInt64
    let picture: NSURL
    let date: NSDate
    let info: String
}

