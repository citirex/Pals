//
//  PLOrder.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLOrder: PLUniqueObject, PLCellRepresentable, PLFilterable {
    let QRcode: String
    let accessCode: String
    let user: PLUser
    let place: PLPlace
    var drinkSets = [PLDrinkset]()
    var covers = [PLCover]()
    let isVIP: Bool
    let message: String
    let date: NSDate
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let userDic = jsonDic[PLKeys.user.string] as? Dictionary<String,AnyObject>,
            let placeDic = jsonDic[PLKeys.place.string] as? Dictionary<String,AnyObject>,
            let message = jsonDic[PLKeys.message.string] as? String,
            let isVIP = jsonDic[PLKeys.is_vip.string] as? Bool,
            let accessCode = jsonDic[PLKeys.access_code.string] as? String,
            let QRcode = jsonDic[PLKeys.qr_code.string] as? String,
            let timestamp = jsonDic[PLKeys.date.string] as? NSTimeInterval
        else {
            return nil
        }
        guard
            let user = PLUser(jsonDic: userDic),
            let place = PLPlace(jsonDic: placeDic)
        else {
            return nil
        }
        self.user = user
        self.place = place
        self.message = message
        self.isVIP = isVIP
        self.accessCode = accessCode
        self.QRcode = QRcode
        self.date = NSDate(timeIntervalSince1970: timestamp)
        print(self.date)
        
        if let drinkSetsArray = jsonDic[PLKeys.drinks.string] as? [Dictionary<String,AnyObject>] {
            for drinkSetDic in drinkSetsArray {
                if let drinkSet = PLDrinkset(jsonDic: drinkSetDic) {
                    drinkSets.append(drinkSet)
                }
            }
        }
        if let coversArray = jsonDic[PLKeys.covers.string] as? [Dictionary<String,AnyObject>] {
            for coverDic in coversArray {
                if let cover = PLCover(jsonDic: coverDic) {
                    covers.append(cover)
                }
            }
        }
        
        super.init(jsonDic: jsonDic)
    }
    
    init(withUser user: PLUser, place: PLPlace, isVip vip: Bool, message: String?, qrCode:String, accessCode: String) {
        self.user = user
        self.place = place
        self.message = message ?? ""
        self.isVIP = vip
        self.accessCode = accessCode
        self.QRcode = qrCode
        self.date = NSDate()
        super.init(jsonDic: [:])!
    }
    
    override func serialize() -> [String : AnyObject] {
        return [:]
    }
    
    static func filter(objc: AnyObject, text: String) -> Bool {return false}
    
    var cellData: PLOrderCellData {
        return PLOrderCellData(user: user, place: place, isVIP: isVIP, message: message, QRcode: QRcode, accessCode: accessCode, date: date)
    }
}

struct PLOrderCellData {
    let user: PLUser
    let place: PLPlace
    let isVIP: Bool
    let message: String
    let QRcode: String
    let accessCode: String
    let date: NSDate
}

