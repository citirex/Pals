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
                collection.appendParams([PLKey.id.string : String(id)])
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
        collection.appendPath([PLKey.orders.string])
        collection.appendParams([PLKey.type.string : orderType.number])
        self.orderType = orderType
    }
    
    override func fakeFeedFilenameKey() -> String {
        return (orderType == .Covers ? PLKey.order_covers : PLKey.order_drinks).string
    }
    
}

// MARK: Order History extension

enum PLOrderHistoryCellType {
    case Place
    case Drink
}

extension PLOrderDatasource {
    func indexPathsFromObjects(objects: [AnyObject], lastIdxPath: NSIndexPath?, mergedSection: Bool) -> [NSIndexPath] {
        var paths = [NSIndexPath]()
        var sectionIdx = 0
        var rowIdx = 0
        if lastIdxPath != nil {
            sectionIdx = mergedSection ? lastIdxPath!.section : lastIdxPath!.section+1
            if mergedSection {
                rowIdx = lastIdxPath!.row+1
            }
        }
        for i in 0..<objects.count {
            if let section = objects[i] as? [PLOrder] {
                var rowsInSection = 0
                for order in section {
                    // +1 row for a place name
                    let rowsForOrder = order.drinkSets.count+1
                    rowsInSection += rowsForOrder
                }
                for i in 0..<rowsInSection {
                    paths.append(NSIndexPath(forRow: rowIdx+i, inSection: sectionIdx))
                }
                rowIdx = 0
            }
            sectionIdx += 1
        }
        return paths
    }
    
    func cellCountInSection(section: Int) -> Int {
        return drinkCountInSection(section) + ordersCountInSection(section)
    }
    
    func orderCellTypeFromHistoryObject(object: AnyObject) -> PLOrderHistoryCellType {
        return object is PLPlace ? .Place : .Drink
    }
    
    func historyObjectForIndPath(idxPath: NSIndexPath) -> AnyObject {
        let drinksets = drinksetsRepesentationInSection(idxPath.section)
        let object = drinksets[idxPath.row]
        return object
    }
    
    private func drinkCountInSection(section: Int) -> Int {
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
    
    private func ordersCountInSection(section: Int) -> Int {
        if collection.isSectioned {
            let count = objectsInSection(section).count
            return count
        }
        return 0
    }
    
    private func drinksetsRepesentationInSection(section: Int) -> [AnyObject] {
        var drinksets = [AnyObject]()
        let orders = objectsInSection(section)
        for order in orders {
            drinksets.append(order.place)
            drinksets.appendContentsOf(order.drinkSets as [AnyObject])
        }
        return drinksets
    }
}
