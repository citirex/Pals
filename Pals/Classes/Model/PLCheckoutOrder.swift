//
//  PLCheckoutOrder.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

protocol PLCheckoutDelegate: class {
    func newPlaceWasSet()
}

class PLCheckoutOrder {
    
    weak var delegate: PLCheckoutDelegate?
    
    var QRcode = ""
    var accessCode = ""
    var user: PLUser? = nil
    var place: PLPlace? = nil {
        didSet{
            if place != nil {
                delegate?.newPlaceWasSet()
            }
        }
    }
    var drinks = [UInt64:PLDrinkset]()
    var covers = [String]()
    var isVIP = false
    var message = ""
    
    func checkout() -> Bool {
        guard
        let _ = user,
        let _ = place
        else {
            return false
        }
        
        let dict = serialize()
        print(dict.description)
        clean()
        
        return true
    }
    
    private func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.qr_code.string] = QRcode
        dic[PLKeys.access_code.string] = accessCode
        dic[PLKeys.user_id.string] = String(user!.id)
        dic[PLKeys.place_id.string] = String(place!.id)        
        dic[PLKeys.drinks.string] = Array(drinks.values).map({ [String($0.drink.id):String($0.quantity)] })//FIXME: check the result
        dic[PLKeys.covers.string] = covers
        dic[PLKeys.is_vip.string] = isVIP.hashValue
        dic[PLKeys.message.string] = message
    
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
    
    func updateWithCoverID(coverID: UInt64, inCell coverCell: PLOrderCoverCell) {
        if let index = covers.indexOf(String(coverID)) {
            covers.removeAtIndex(index)
            coverCell.setDimmed(false, animated: true)
        } else {
            covers.append(String(coverID))
            coverCell.setDimmed(true, animated: true)
        }
    }
    
    func clean() {
        drinks.removeAll()
        covers.removeAll()
        message = ""
    }
    
}