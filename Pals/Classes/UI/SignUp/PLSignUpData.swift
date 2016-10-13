//
//  PLSignUpHelpers.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

struct PLSignUpData {
    var username: String
    var email: String
    var password: String
    var picture: UIImage?
    
    var params: [String : AnyObject] {
        let params = [PLKeys.username.string : username,
                      PLKeys.email_unique.string : email,
                      PLKeys.password.string : password]
        return params
    }
}
