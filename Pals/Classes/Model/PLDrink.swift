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
    
    var cardType: PLCardType {
        switch self {
        case .Light:
            return .Beer
        case .Strong:
            return .Liquor
        case .Undefined:
            return .Unknown
        }
    }
}

class PLDrink : PLPricedItem, PLFilterable {
    
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
    
    override class var itemKey: PLKey {return .drink}
}