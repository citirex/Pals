//
//  PLUser.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

class PLUser: PLUniqueObject, PLCellRepresentable {
    var name: String
    var email: String
    var picture: NSURL
    var balance = Float(0)
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let name = jsonDic[PLKeys.name.string] as? String,
            let email = jsonDic[PLKeys.email.string] as? String,
            let picture = jsonDic[PLKeys.picture.string] as? String
        else {
            return nil
        }
        self.name = name
        self.email = email
        self.picture = NSURL(string: picture)!
        if let balance = jsonDic[PLKeys.balance.string] as? Float {
            self.balance = balance
        }
        super.init(jsonDic: jsonDic)
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.name.string] = name
        dic[PLKeys.email.string] = email
        dic[PLKeys.picture.string] = picture.absoluteString
        dic[PLKeys.balance.string] = String(balance)
        dic.append(super.serialize())
        return dic
    }
    
    var cellData: PLFriendCellData {
        let data = PLFriendCellData(id: id, picture: picture, name: name)
        return data
    }
    
    var userData: PLUserData {
        return PLUserData(id: id, name: name, email: email, phone: "", picture: picture)
    }
    
}
