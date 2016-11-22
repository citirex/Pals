//
//  PLDrink.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLDrinkType: Int {
    case Beer
    case Spirit
    case Cocktail
    case Wine
    case NonAlcohol
    case Unknown
    
    init(number: Int) {
        var n = number
        if n >= 5 {
            n = 5
        }
        self.init(rawValue: n)!
    }
    
    var image: UIImage {
        var name = ""
        switch self {
        case .Beer:
            name = "beer_icon"
        case .Spirit:
            name = "spirit_icon"
        case .Cocktail:
            name = "cocktail_icon"
        case .Wine:
            name = "wine_icon"
        case .NonAlcohol:
            name = "non_alcohol_icon"
        case .Unknown:
            name = "question_icon"
        }
        return UIImage(named: name)!
    }
    
    var cardType: PLCardType {
        switch self {
        case .Beer:
            return .Beer
        case .Spirit:
            return .Liquor
        default:
            return .Unknown
        }
    }
}

class PLDrink : PLPricedItem, PLFilterable {
    
    var type: PLDrinkType = .Unknown
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let number = jsonDic[.type] as? Int
        else {
            return nil
        }
        self.type = PLDrinkType(number: number)
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