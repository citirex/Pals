//
//  PLCover.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/16/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLPricedItem: PLDatedObject {
    var name: String
    var price = Float(0)
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let name = jsonDic[.name] as? String,
            let price = jsonDic[.price] as? Float
        else {
            return nil
        }
        self.name = name
        self.price = price
        super.init(jsonDic: jsonDic)
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.name] = name
        dic[.price] = price
        dic.append(super.serialize())
        return dic
    }
}

class PLCover: PLPricedItem, PLCellRepresentable, PLFilterable {

    static func filter(objc: AnyObject, text: String) -> Bool {return false}
    
    var cellData: PLCoverCellData {
        return PLCoverCellData(coverID: id, name: name, price: price)
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.cover] = String(id)
        return dic
    }
}

struct PLCoverCellData {
    var coverID: UInt64
    var name: String
    var price: Float
}
