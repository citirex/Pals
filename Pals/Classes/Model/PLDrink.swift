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

class PLDrink : PLPricedItem, PLCellRepresentable, PLFilterable {
    
    var type: DrinkType = .Undefined
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let drinkType = jsonDic[.type] as? Int
        else {
            return nil
        }
        if let type = DrinkType(rawValue: drinkType) {
            self.type = type
        }
        super.init(jsonDic: jsonDic)
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.type] = type.rawValue
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
