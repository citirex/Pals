//
//  PLOrder.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLOrder: PLDatedObject, PLCellRepresentable, PLFilterable {
    let user: PLUser
    let place: PLPlace
    var drinkSets = [PLDrinkset]()
    var covers = [PLEvent]()
    let isVIP: Bool
    let message: String
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let userDic = jsonDic[.user] as? Dictionary<String,AnyObject>,
            let placeDic = jsonDic[.place] as? Dictionary<String,AnyObject>,
            let message = jsonDic[.message] as? String,
            let isVIP = jsonDic[.is_vip] as? Bool
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
        
        if let drinkSetsArray = jsonDic[.drinks] as? [Dictionary<String,AnyObject>] {
            for drinkSetDic in drinkSetsArray {
                if let drinkSet = PLDrinkset(jsonDic: drinkSetDic) {
                    drinkSets.append(drinkSet)
                }
            }
        }
        if let coversArray = jsonDic[.covers] as? [Dictionary<String,AnyObject>] {
            for coverDic in coversArray {
                if let cover = PLEvent(jsonDic: coverDic) {
                    covers.append(cover)
                }
            }
        }
        super.init(jsonDic: jsonDic)
    }
     
    override func serialize() -> [String : AnyObject] {
        return [:]
    }
    
    static func filter(objc: AnyObject, text: String) -> Bool {return false}
    
    var cellData: PLOrderCellData {
        return PLOrderCellData(user: user, place: place, isVIP: isVIP, message: message, date: date, drinkSets: drinkSets, covers: covers)
    }
}

struct PLOrderCellData {
    let user: PLUser
    let place: PLPlace
    let isVIP: Bool
    let message: String
    let date: NSDate?
    let drinkSets: [PLDrinkset]?
    let covers: [PLEvent]?
}

