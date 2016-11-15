//
//  PLCoverSet.swift
//  Pals
//
//  Created by ruckef on 15.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLCoverSet: PLCountableItem {
    var cover: PLEvent
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let coverDic = jsonDic[.cover] as? Dictionary<String,AnyObject>,
            let cover = PLEvent(jsonDic: coverDic)
        else {
            return nil
        }
        self.cover = cover
        super.init(jsonDic: jsonDic)
    }
    
    init(cover: PLEvent, andCount count: UInt64) {
        self.cover = cover
        super.init(count: count)
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = super.serialize()
        dic[.cover] = String(cover.id)
        return dic
    }
    
    var cellData: PLCoverSetCellData {
        return PLCoverSetCellData(quantity: quantity, cover: cover)
    }
}

struct PLCoverSetCellData {
    var quantity: UInt64
    var cover: PLEvent
}
