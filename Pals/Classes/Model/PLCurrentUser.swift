//
//  PLCurrentUser.swift
//  Pals
//
//  Created by ruckef on 20.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCurrentUser: PLUser {
    func hasEnoughMoneyToPayFor(order: PLCheckoutOrder) -> Bool {
        guard PLFacade.instance.settingsManager.balanceCheckEnabled else {
            return true
        }
        let totalAmount = order.calculateTotalAmount()
        return balance >= totalAmount
    }
    
    override var cellData: PLFriendCellData {
        var data = super.cellData
        data.me = true
        return data
    }
}
