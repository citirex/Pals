//
//  PLCurrentUser.swift
//  Pals
//
//  Created by ruckef on 20.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCurrentUser: PLUser {
    override var cellData: PLFriendCellData {
        var data = super.cellData
        data.me = true
        return data
    }
    
    var hasPaymentCard: Bool {
        return customer?.paymentSource != nil
    }
}
