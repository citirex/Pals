//
//  PLEditableUser.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/30/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLEditableUser {
    
    var name = ""
    var contactMain = ""
    var contactSecondary = ""
    var picture: UIImage? = nil
    
    func params() -> [String : AnyObject] {
        var dic = [String : AnyObject]()
        dic[PLKeys.name.string] = name
        dic[PLKeys.email.string] = contactMain
        dic[PLKeys.phone.string] = contactSecondary
        
        return dic
    }
    
    var isChanged: Bool {
        if name.isEmpty && contactMain.isEmpty && contactSecondary.isEmpty && picture == nil {
            return false
        }
        return true
    }
    
    func clean() {
        name = ""
        contactMain = ""
        contactSecondary = ""
        picture = nil
    }
    
}
