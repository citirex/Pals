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
        let data = PLFriendCellData(id: id, picture: picture, name: name)
        return data
    }
    
    var userData: PLUserData {
        return PLUserData(id: id, name: name, email: email, phone: "(123) 123 1234", picture: picture, additional: additional)
    }
}

struct PLUserData {
    
    var id: UInt64
    var name: String
    var email: String
    var phone: String
    var picture: NSURL
    var additional: String?
}

// Change profile info temporaty information store in struct below

struct PLUserEditedData {
    
    var userName: (initial: String,final: String?)
    var userEmail: (initial: String,final: String?)
    var userImage: (initial: UIImage?,final: UIImage?)
    
    init(aUserName: String, aUserEmail:String, aUserImage:UIImage?) {
        self.userName = (aUserName, nil)
        self.userEmail = (aUserEmail, nil)
        self.userImage = (aUserImage, nil)
    }
    
    
    //MARK: Getters
    func params() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        if let name = userName.final where (userName.initial != name && name.isEmpty == false) {
            dic[PLKeys.name.string] = name
        }
        if let email = userEmail.final where (userEmail.initial != email && email.isEmpty == false) {
            dic[PLKeys.email.string] = email
        }
        
        return dic
    }
    
    var isChanged: Bool {
        if (userName.final?.isEmpty == false && userName.final != userName.initial) ||
            (userEmail.final?.isEmpty == false && userEmail.final != userEmail.initial) ||
            (userImage.final != nil && userImage.final != userImage.initial) {
            return true
        }
        return false
    }
    
    var image: UIImage? {
        if let anImage = userImage.final where (userImage.initial != anImage) {
            return anImage
        }
        return nil
    }
    
    //MARK: Actions
    mutating func clean() {
        userName.final = nil
        userEmail.final = nil
        userImage.final = nil
    }
}
