//
//  PLDrinkset.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCountableItem: PLUniqueObject {
    var quantity: UInt64
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let aQuantity = jsonDic[.quantity] as? NSNumber
        else {
            return nil
        }
        self.quantity = aQuantity.unsignedLongLongValue
        super.init(jsonDic: jsonDic)
    }
    
    init(count: UInt64) {
        quantity = count
        super.init(jsonDic: [:])!
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.quantity] = String(quantity)
        return dic
    }
}

class PLItemSet<T: PLPricedItem> : PLCountableItem {
    
    let item: T
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let itemDic = jsonDic[T.itemKey] as? Dictionary<String,AnyObject>,
            let item = T(jsonDic: itemDic)
        else {
            return nil
        }
        self.item = item
        super.init(jsonDic: jsonDic)
    }
    
    init(item: T, andCount count: UInt64) {
        self.item = item
        super.init(count: count)
    }
    
    func serializeWithKey(key: PLKey) -> [String : AnyObject] {
        var dic = super.serialize()
        dic[key.string] = String(item.id)
        return dic
    }
}