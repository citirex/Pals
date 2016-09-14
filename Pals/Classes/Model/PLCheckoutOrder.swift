//
//  PLCheckoutOrder.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

class PLCheckoutOrder {
    
    let QRcode: String
    let accessCode: String
    let user: PLUser
    let place: PLPlace
    var drinks = [UInt64: Int]()
    let isVIP: Bool
    let message: String
    
    init(qrCode: String, accessCode aCCcode: String, user aUser: PLUser, place aPlace: PLPlace, drinks aDrinks:[UInt64: Int],isVip aIsVip: Bool, message aMessage: String?) {
        QRcode = qrCode
        accessCode = aCCcode
        user = aUser
        place = aPlace
        drinks = aDrinks
        isVIP = aIsVip
        message = aMessage ?? ""
    }
    
    func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.qr_code.string] = QRcode
        dic[PLKeys.access_code.string] = accessCode
        dic[PLKeys.user_id.string] = String(user.id)
        dic[PLKeys.place_id.string] = String(place.id)
        dic[PLKeys.drinks.string] = serializeDrinks(drinks)
        dic[PLKeys.is_vip.string] = isVIP.hashValue
        dic[PLKeys.message.string] = message
    
        return dic
    }
    
    func serializeDrinks(dic: [UInt64: Int]) -> [String: String] {
        let convertedDict: [String: String] = dic.mapPairs { (key, value) in
            (String(key), String(value))
        }
        return convertedDict
    }
}

extension Dictionary {
    //    Since Dictionary conforms to CollectionType, and its Element typealias is a (key, value) tuple, that means you ought to be able to do something like this:
    //
    //    result = dict.map { (key, value) in (key, value.uppercaseString) }
    //
    //    However, that won't actually assign to a Dictionary-typed variable. THE MAP METHOD IS DEFINED TO ALWAYS RETURN AN ARRAY (THE [T]), even for other types like dictionaries. If you write a constructor that'll turn an array of two-tuples into a Dictionary and all will be right with the world:
    //  Now you can do this:
    //    result = Dictionary(dict.map { (key, value) in (key, value.uppercaseString) })
    //
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
    //    You may even want to write a Dictionary-specific version of map just to avoid explicitly calling the constructor. Here I've also included an implementation of filter:
    //    let testarr = ["foo" : 1, "bar" : 2]
    //    let result = testarr.mapPairs { (key, value) in (key, value * 2) }
    //    result["bar"]
    func mapPairs<OutKey: Hashable, OutValue>(@noescape transform: Element throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
}