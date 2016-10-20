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
    var covers = [UInt64:PLCover]()
    var isVIP = false
    var message: String?
    
    func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.user_id.string] = String(user!.id)
        dic[PLKeys.place_id.string] = String(place!.id)
        let aDrinks = Array(drinks.values).toDictionary { item in ["\(item.drink.id)":"\(item.quantity)"] }
        dic[PLKeys.drinks.string] = aDrinks
        let aCovers = Array(covers.values).map({ "\($0.id)" })
        dic[PLKeys.covers.string] = aCovers
        dic[PLKeys.is_vip.string] = isVIP.hashValue
        if message != nil && !message!.isEmpty {
            dic[PLKeys.message.string] = message
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
                drinks.updateValue(PLDrinkset(aDrink: drink, andCount: count)!, forKey: drink.id)
            }
        }
    }
    
    func updateWithCoverID(cover: PLCover, inCell coverCell: PLOrderCoverCell) {
        if covers[cover.id] != nil {
            covers.removeValueForKey(cover.id)
            coverCell.setDimmed(false, animated: true)
        } else {
            covers.updateValue(cover, forKey: cover.id)
            coverCell.setDimmed(true, animated: true)
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
            for aCover in covers.values {
                amount += aCover.price
            }
        }
        return amount
    }
    
    private func clean() {
        drinks.removeAll()
        covers.removeAll()
    }
    
}