//
//  PLCover.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/16/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

class PLCover: PLUniqueObject, PLCellRepresentable {
    
    var name: String = ""
    var price: Float = 0

    required init?(jsonDic: [String : AnyObject]) {
////        guard
//            let coverName = jsonDic[PLKeys.name.string] as? String,
//            let coverPrice = jsonDic[PLKeys.price.string] as? Float
//            else {
//                return nil
//        }
//        
//        self.name = coverName
//        self.price = coverPrice
        super.init(jsonDic: jsonDic)
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.name.string] = name
        dic[PLKeys.price.string] = price
        dic.append(super.serialize())
        return dic
    }
    
    var cellData: PLCoverCellData {
        return PLCoverCellData(coverID: id, name: name, price: price)
    }
    
}

struct PLCoverCellData {
    var coverID: UInt64
    var name: String
    var price: Float
}
