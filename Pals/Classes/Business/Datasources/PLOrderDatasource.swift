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
                collection.appendParams([PLKeys.id.string : String(id)])
            }
        }
    }
    
    var orderType: PLOrderType
    
    override init(url: String, params: PLURLParams?, offsetById: Bool, sectioned: Bool) {
        orderType = .All
        super.init(url: url, params: params, offsetById: offsetById, sectioned: sectioned)
    }
    
    convenience init() {
        self.init(orderType: .All)
    }
    
    convenience init(orderType: PLOrderType) {
        self.init(orderType: orderType, sectioned: false)
    }
    
    convenience init(orderType: PLOrderType, sectioned: Bool) {
        self.init(url: PLAPIService.Orders.string, offsetById: false, sectioned: sectioned)
        collection.appendPath([PLKeys.orders.string])
        collection.appendParams([PLKeys.type.string : orderType.number])
        self.orderType = orderType
    }
    
    override func fakeFeedFilenameKey() -> String {
        return (orderType == .Covers ? PLKeys.order_covers : PLKeys.order_drinks).string
    }
    
    func drinkCountInSection(section: Int) -> Int {
        if collection.isSectioned {
            let ordersInSection = objectsInSection(section)
            var count = 0
            for order in ordersInSection {
                count += order.drinkSets.count
            }
            return count
        }
        return 0
    }
    
    func ordersCountInSection(section: Int) -> Int {
        if collection.isSectioned {
            let count = objectsInSection(section).count
            return count
        }
        return 0
    }
    
}
