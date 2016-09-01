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
    case login
    case password
    var string : String {
        return rawValue
    }
}

class PLUniqueObject: PLSerializable {
    
    var id: String
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let id = jsonDic[PLKeys.id.string] as? String
        else {
            return nil
        }
        self.id = id
    }
    
    func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.id.string] = id
        return dic
    }
    
}

protocol PLSerializable {
    init?(jsonDic: [String:AnyObject])
    func serialize() -> [String : AnyObject]
}