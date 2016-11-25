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
        return UIImage(named: iconName)!
    }
    
    var iconName: String {
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
        return name
    }
    
    var color: UIColor {
        var color: UIColor!
        switch self {
        case .Beer:
            color = .beerColor
        case .Spirit:
            color = .spiritColor
        case .Cocktail:
            color = .cocktailColor
        case .Wine:
            color = .wineColor
        case .NonAlcohol:
            color = .nonAlcoholColor
        case .Unknown:
            color = .unknownColor
        }
        return color
    }
}

class PLDrink : PLPricedItem, PLFilterable {
    
    var type: PLDrinkType = .Unknown
    var duration: Int?
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let number = jsonDic[.type] as? Int
        else {
            return nil
        }
        if let duration = jsonDic[.duration] as? Int {
            self.duration = duration
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