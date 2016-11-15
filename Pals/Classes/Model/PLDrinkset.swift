//
//  PLDrinkset.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCountableItem: PLUniqueObject {
    var quantity: UInt64
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let aQuantity = jsonDic[.quantity] as? NSNumber
        else {
            return nil
        }
        self.quantity = aQuantity.unsignedLongLongValue
        super.init(jsonDic: jsonDic)
    }
    
    init(count: UInt64) {
        quantity = count
        super.init(jsonDic: [:])!
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.quantity] = String(quantity)
        return dic
    }
}

class PLDrinkset : PLCountableItem, PLCellRepresentable {
    var drink: PLDrink
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let drinkDic = jsonDic[.drink] as? Dictionary<String,AnyObject>,
            let drink = PLDrink(jsonDic: drinkDic)
        else {
            return nil
        }
        self.drink = drink
        super.init(jsonDic: jsonDic)
    }
    
    init(drink: PLDrink, andCount count: UInt64) {
        self.drink = drink
        super.init(count: count)
    }

    override func serialize() -> [String : AnyObject] {
        var dic = super.serialize()
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