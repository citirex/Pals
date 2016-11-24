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
    var additional: String?
    var customer: PLCustomer?
    // by default we assume that a given user is not a friend of a current one
    dynamic var invited: Bool = false
    dynamic var inviting: Bool = false
    var pending = false
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let name = jsonDic[.name] as? String,
            let email = jsonDic[.email] as? String,
            let picture = jsonDic[.picture] as? String
        else {
            return nil
        }
        self.name = name
        self.email = email
        self.picture = NSURL(string: picture)!
        if let additional = jsonDic[.additional] as? String {
            self.additional = additional
        }
        if let invited = jsonDic[.invited] as? Bool {
            self.invited = invited
        }
        if let customerDic = jsonDic[.customer] as? [String : AnyObject] {
            self.customer = PLCustomer(jsonDic: customerDic)!
        }
        if let pending = jsonDic[.pending] as? Bool {
            self.pending = pending
        }
        super.init(jsonDic: jsonDic)
    }
    
    override func serialize() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[.name] = name
        dic[.email] = email
        dic[.picture] = picture.absoluteString
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
        return PLFriendCellData(id: id, name: name, email: email, phone: "(123) 123 1234", picture: picture, additional: additional, invited: invited, inviting: inviting, me: false)
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
    let inviting: Bool
    var me: Bool
}
