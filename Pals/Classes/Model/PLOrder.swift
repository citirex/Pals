//
//  PLOrder.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLOrder: PLUniqueObject {
    let QRcode: String
    let accessCode: String
    let user: PLUser
    let place: PLPlace
    var drinks = [PLDrink]()
    let isVIP: Bool
    let message: String
    
    required init?(jsonDic: [String : AnyObject]) {
        QRcode = ""
        accessCode = ""
        user = PLUser(jsonDic: [:])!
        place = PLPlace(jsonDic: [:])!
        isVIP = false
        message = ""
        super.init(jsonDic: jsonDic)
    }
    
    override func serialize() -> [String : AnyObject] {
        return [:]
    }
}
