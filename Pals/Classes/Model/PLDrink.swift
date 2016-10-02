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

class PLDrink : PLDatedObject, PLCellRepresentable, PLFilterable {
    
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
        var dic = [String : AnyObject]()
        dic[PLKeys.name.string] = name
        dic[PLKeys.price.string] = price
        dic[PLKeys.type.string] = type.rawValue
        dic.append(super.serialize())
        return dic
    }
    
    static func filter(objc: AnyObject, text: String) -> Bool {return false}
    
    var cellData: PLDrinkCellData {
        return PLDrinkCellData(drinkId: id, name: name, price: price, type: type)
    }
    
}

struct PLDrinkCellData {
    var drinkId: UInt64
    var name: String
    var price: Float
    var type: DrinkType
}
