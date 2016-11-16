//
//  PLOrder.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLOrder: PLDatedObject, PLFilterable {
    let user: PLUser
    let place: PLPlace
    var drinkSets = [PLItemSet<PLDrink>]()
    var coverSets = [PLItemSet<PLEvent>]()
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
                if let drinkSet = PLItemSet<PLDrink>(jsonDic: drinkSetDic) {
                    drinkSets.append(drinkSet)
                }
            }
        }
        if let coversArray = jsonDic[.covers] as? [Dictionary<String,AnyObject>] {
            for coverDic in coversArray {
                if let cover = PLItemSet<PLEvent>(jsonDic: coverDic) {
                    coverSets.append(cover)
                }
            }
        }
        super.init(jsonDic: jsonDic)
    }
     
    override func serialize() -> [String : AnyObject] {
        return [:]
    }
    
    static func filter(objc: AnyObject, text: String) -> Bool {return false}
    
}