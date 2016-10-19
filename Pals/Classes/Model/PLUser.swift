//
//  PLUser.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLUser: PLDatedObject, PLCellRepresentable, PLFilterable {
    var name: String
    var email: String
    var picture: NSURL
    var balance = Float(0)
    var additional: String?
    // by default we assume that a given user is a friend of a current one
    var invited: Bool = true
    
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
        if let additional = jsonDic[PLKeys.additional.string] as? String {
            self.additional = additional
        }
        if let invited = jsonDic[PLKeys.invited.string] as? Bool {
            self.invited = invited
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
    
    static func filter(objc: AnyObject, text: String) -> Bool {
        if let user = objc as? PLUser {
            return user.name.lowercaseString.containsString(text.lowercaseString)
        }
        return false
    }
    
    var cellData: PLFriendCellData {
        return PLFriendCellData(id: id, name: name, email: email, phone: "(123) 123 1234", picture: picture, additional: additional, invited: invited)
    }
}

struct PLFriendCellData {
    let id: UInt64
    let name: String
    let email: String
    let phone: String
    let picture: NSURL
    let additional: String?
    let invited: Bool
}
