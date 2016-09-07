//
//  PLUniqueObject.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

enum PLKeys : String {
    case id
    case name
    case picture
    case email
    case balance
    case user
    case response
    case login
    case password
    case success
    case per_page
    case since
    case page
    var string : String {
        return rawValue
    }
}

class PLUniqueObject: PLSerializable {
    
    var id: UInt64
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let id = jsonDic[PLKeys.id.string] as? NSNumber
        else {
            return nil
        }
        self.id = id.unsignedLongLongValue
    }
    
    func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.id.string] = String(id)
        return dic
    }
    
}

protocol PLSerializable {
    init?(jsonDic: [String:AnyObject])
    func serialize() -> [String : AnyObject]
}