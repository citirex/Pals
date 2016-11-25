//
//  PLCurrentUser.swift
//  Pals
//
//  Created by ruckef on 20.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCurrentUser: PLUser {
    
    required init?(jsonDic: [String : AnyObject]) {
        super.init(jsonDic: jsonDic)
    }
    
    var hasPaymentCard: Bool {
        return customer?.paymentSource != nil
    }
}
