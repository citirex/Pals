//
//  PLCheckoutOrder.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCheckoutOrder {
    var user: PLUser? = nil
    var place: PLPlace? = nil {
        didSet{
            clean()
        }
    }
    var drinks = [UInt64:PLDrinkset]()
    var covers = [UInt64:PLCoverSet]()
    var isSplitCovers = false
    var isSplitDrinks = false
    var isVIP = false
    var message: String?
    
    func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.user_id] = String(user!.id)
        dic[.place_id] = String(place!.id)
        
        var drinks = [[String : AnyObject]]()
        for (_, drinkset) in self.drinks {
            let drinkDic = drinkset.serialize()
            drinks.append(drinkDic)
        }
        if drinks.count > 0 {
            dic[.drinks] = drinks
            dic[.is_split_drinks] = String(isSplitDrinks)
        }
        
        var covers = [[String : AnyObject]]()
        for (_, cover) in self.covers {
            let coverDic = cover.serialize()
            covers.append(coverDic)
        }
        
        if covers.count > 0 {
            dic[.covers] = covers
            dic[.is_split_covers] = String(isSplitCovers)
        }
        dic[.is_vip] = String(isVIP)
        if message != nil && !message!.isEmpty {
            dic[.message] = message
        }
        return dic
    }
    
    func updateWithDrink(drink: PLDrink, andCount count: UInt64) {
        if count == 0 {
            drinks.removeValueForKey(drink.id)
        } else {
            if let drinkSet = drinks[drink.id] {
                drinkSet.quantity = count
            } else {
                let drinkSet = PLDrinkset(drink: drink, andCount: count)
                drinks.updateValue(drinkSet, forKey: drink.id)
            }
        }
    }
    
    func updateCoverSet(coverSet: PLCoverSet) {
        let id = coverSet.cover.id
        if coverSet.quantity == 0 {
            covers.removeValueForKey(id)
        } else {
            covers.updateValue(coverSet, forKey: id)
        }
    }
    
    func calculateTotalAmount() -> Float {
        var amount: Float = 0.0
        if drinks.count > 0 {
            for drinkSet in drinks.values {
                amount += Float(drinkSet.quantity) * drinkSet.drink.price
            }
        }
        if covers.count > 0 {
            for coverSet in covers.values {
                amount += Float(coverSet.quantity) * coverSet.cover.price
            }
        }
        return amount
    }
    
    func clean() {
        drinks.removeAll()
        covers.removeAll()
    }
    
}