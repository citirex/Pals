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
    var used = false
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
        if let used = jsonDic[.is_used] as? Bool {
            self.used = used
        }
        if let drinkSetsArray = jsonDic[.drinks] as? [Dictionary<String,AnyObject>] {
            let sets = drinkSetsArray.flatMap({ (jsonDic) -> PLItemSet<PLDrink>? in
                return PLItemSet<PLDrink>(jsonDic: jsonDic)
            })
            drinkSets.appendContentsOf(sets)
        }
        if let coversArray = jsonDic[.covers] as? [Dictionary<String,AnyObject>] {
            let sets = coversArray.flatMap({ (jsonDic) -> PLItemSet<PLEvent>? in
                return PLItemSet<PLEvent>(jsonDic: jsonDic)
            })
            coverSets.appendContentsOf(sets)
        }
        super.init(jsonDic: jsonDic)
    }
    
    var allItems: [AnyObject] {
        var items = [AnyObject]()
        drinkSets.forEach { items.append($0) }
        coverSets.forEach { items.append($0) }
        return items
    }
    
    subscript(idx: Int) -> AnyObject {
        return allItems[idx]
    }
    
    var itemsCount: Int {
        return allItems.count
    }
    
    override func serialize() -> [String : AnyObject] { return [:] }
    static func filter(objc: AnyObject, text: String) -> Bool {return false}
}