//
//  PLDrink.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum DrinkType: Int {
    case Undefined = 0
    case Light
    case Strong
}

class PLDrink : PLUniqueObject, PLCellRepresentable {
    
    var name: String
    var price: Float
    var type: DrinkType
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let drinkName = jsonDic[PLKeys.name.string] as? String,
            let drinkPrice = jsonDic[PLKeys.price.string] as? Float,
            let drinkType = jsonDic[PLKeys.type.string] as? Int
            else {
                return nil
        }
        
        self.name = drinkName
        self.price = drinkPrice
        self.type = DrinkType(rawValue: drinkType)!
        super.init(jsonDic: jsonDic)
    }
    
    override func serialize() -> [String : AnyObject] {
        return [:]
    }
    
    var cellData: PLDrinkCellData {
        return PLDrinkCellData(drinkId: id, name: name, price: price, type: type)
    }
    
}
