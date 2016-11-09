//
//  PLDrinkset.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

class PLDrinkset : PLUniqueObject, PLCellRepresentable {
    
    var quantity: UInt64
    let drink: PLDrink
    
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let aQuantity = jsonDic[.quantity] as? NSNumber,
            let drinkDic = jsonDic[.drink] as? Dictionary<String,AnyObject>
            else {
                return nil
        }
        
        guard
            let aDrink = PLDrink(jsonDic: drinkDic)
            else {
                return nil
        }
        self.quantity = aQuantity.unsignedLongLongValue
        self.drink = aDrink

        super.init(jsonDic: jsonDic)
    }
    
    init?(aDrink: PLDrink, andCount count: UInt64) {
        drink = aDrink
        quantity = count
        super.init(jsonDic: [:])
    }

    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.quantity] = String(quantity)
        dic[.drink] = String(drink.id)
        return dic
    }
    
    var cellData: PLDrinksetCellData {
        return PLDrinksetCellData(quantity: quantity, drink: drink)
    }
    
}

struct PLDrinksetCellData {
    var quantity: UInt64
    var drink: PLDrink
}