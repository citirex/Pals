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
    private var drinks = [UInt64:PLItemSet<PLPricedItem>]()
    private var covers = [UInt64:PLItemSet<PLPricedItem>]()
    var isSplitCovers = false
    var isSplitDrinks = false
    var isVIP = false
    var message: String?
    
    var coverSetCount : Int { return covers.count }
    var drinkSetCount : Int { return drinks.count }
    
    var hasAtLeastTwoDrinks: Bool {
        return hasAtLeastTwoItemsInDic(drinks)
    }
    
    var hasAtLeastTwoCovers: Bool {
        return hasAtLeastTwoItemsInDic(covers)
    }
    
    private func hasAtLeastTwoItemsInDic(dic: [UInt64:PLItemSet<PLPricedItem>]) -> Bool {
        var itemCount = 0
        for (_, value) in dic {
            itemCount += value.quantity
            if itemCount > 1 {
                return true
            }
        }
        return false
    }
    
    func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.user_id] = String(user!.id)
        dic[.place_id] = String(place!.id)
        
        var drinks = [[String : AnyObject]]()
        for (_, drinkset) in self.drinks {
            let drinkDic = drinkset.serializeWithKey(PLDrink.itemKey)
            drinks.append(drinkDic)
        }
        if drinks.count > 0 {
            dic[.drinks] = drinks
            dic[.is_split_drinks] = String(isSplitDrinks)
        }
        
        var covers = [[String : AnyObject]]()
        for (_, cover) in self.covers {
            let coverDic = cover.serializeWithKey(PLEvent.itemKey)
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
    
    func updateWithDrink(drink: PLDrink, andCount count: Int) {
        updateItem(drink, withCount: count, section: .Drinks)
    }
    
    func updateWithCover(event: PLEvent, andCount count: Int) {
        updateItem(event, withCount: count, section: .Covers)
    }
    
    func updateItem(item: PLPricedItem, withCount count: Int, section: PLOrderSection) {
        var dic = (section == .Drinks) ? drinks : covers
        let id = item.id
        if count == 0 {
            dic.removeValueForKey(id)
        } else {
            let itemSet = PLItemSet<PLPricedItem>(item: item, andCount: count)
            dic.updateValue(itemSet, forKey: id)
        }
        if section == .Drinks {
            drinks = dic
        } else {
            covers = dic
        }
    }
    
    func itemById(id: UInt64, inSection section: PLOrderSection) -> PLItemSet<PLPricedItem>? {
        var dic = (section == .Drinks) ? drinks : covers
        let obj = dic[id]
        return obj
    }
    
    func appendCover(event: PLEvent) {
        var newCount = 1
        if let coverSet = covers[event.id] {
            newCount += coverSet.quantity
        }
        updateWithCover(event, andCount: newCount)
    }
    
    func calculateTotalAmount() -> Float {
        var amount: Float = 0.0
        if drinks.count > 0 {
            for drinkSet in drinks.values {
                amount += Float(drinkSet.quantity) * drinkSet.item.price
            }
        }
        if covers.count > 0 {
            for coverSet in covers.values {
                amount += Float(coverSet.quantity) * coverSet.item.price
            }
        }
        return amount
    }
    
    func clean() {
        drinks.removeAll()
        covers.removeAll()
    }
    
}