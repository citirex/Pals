//
//  PLOrderDatasource.swift
//  Pals
//
//  Created by ruckef on 09.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLOrderType : Int {
    case All
    case Drinks
    case Covers
    var number: NSNumber { return NSNumber(integer: rawValue) }
}

class PLOrderDatasource: PLDatasource<PLOrder> {
    
    var userId: UInt64? {
        didSet {
            if let id = userId {
                collection.preset[PLKeys.id.string] = String(id)
            }
        }
    }
    
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init() {
        self.init(orderType: .All)
    }
    
    convenience init(orderType: PLOrderType) {
        self.init(url: PLAPIService.Orders.string, offsetById: false)
        collection.appendPath([PLKeys.orders.string])
        collection.preset[PLKeys.type.string] = orderType.number
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLKeys.order_drinks.string
    }
    
}
