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
    var drinks = [PLDrinkset]()
    var covers = [String]()
    let isVIP: Bool
    let message: String
    
    init(qrCode: String, accessCode aCCcode: String, user aUser: PLUser, place aPlace: PLPlace, drinks aDrinks:[PLDrinkset],covers aCovers: [String],isVip aIsVip: Bool, message aMessage: String?) {
        QRcode = qrCode
        accessCode = aCCcode
        user = aUser
        place = aPlace
        drinks = aDrinks
        covers = aCovers
        isVIP = aIsVip
        message = aMessage ?? ""
    }
    
    func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.qr_code.string] = QRcode
        dic[PLKeys.access_code.string] = accessCode
        dic[PLKeys.user_id.string] = String(user.id)
        dic[PLKeys.place_id.string] = String(place.id)
        dic[PLKeys.drinks.string] = drinks //FIXME: actual drinks data
        dic[PLKeys.covers.string] = covers
        dic[PLKeys.is_vip.string] = isVIP.hashValue
        dic[PLKeys.message.string] = message
    
        return dic
    }
    
}