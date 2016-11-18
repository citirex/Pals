//
//  PLDrinkset.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCountableItem: PLUniqueObject {
    var quantity: Int
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let aQuantity = jsonDic[.quantity] as? NSNumber
        else {
            return nil
        }
        self.quantity = aQuantity.integerValue
        super.init(jsonDic: jsonDic)
    }
    
    init(count: Int) {
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
    var expires: NSDate?
    var expired: Bool {
        if expires == nil {
            return false
        }
        return expires!.compare(NSDate()) == .OrderedAscending
    }
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let itemDic = jsonDic[T.itemKey] as? Dictionary<String,AnyObject>,
            let item = T(jsonDic: itemDic)
        else {
            return nil
        }
        self.item = item
        if let expires = jsonDic[.expires] as? NSTimeInterval {
            self.expires = NSDate(timeIntervalSince1970: expires)
        }
        super.init(jsonDic: jsonDic)
    }
    
    init(item: T, andCount count: Int) {
        self.item = item
        super.init(count: count)
    }
    
    func serializeWithKey(key: PLKey) -> [String : AnyObject] {
        var dic = super.serialize()
        dic[key.string] = String(item.id)
        return dic
    }
}