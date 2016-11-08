//
//  PLUniqueObject.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLUniqueObject: NSObject, PLSerializable, PLDeserializable {
    
    var id: UInt64 = 0
    
    required init?(jsonDic: [String : AnyObject]) {
        if let id = jsonDic[PLKeys.id.string] as? NSNumber {
            self.id = id.unsignedLongLongValue
        }
    }
    
    func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.id.string] = String(id)
        return dic
    }
}

protocol PLFilterable {
    static func filter(objc: AnyObject, text: String) -> Bool
}

protocol PLDeserializable {
    init?(jsonDic: [String:AnyObject])
}

protocol PLSerializable {
    func serialize() -> [String : AnyObject]
}

protocol PLCellRepresentable {
    associatedtype EntityType
    var cellData: EntityType {get}
}