//
//  PLUserData.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/23/16.
//  Copyright © 2016 citirex. All rights reserved.
//

struct PLUserData {
    var name: String
    var email: String
    var phone: String
    var picture: NSURL
    
    init(user: PLUser) {
        name = user.name
        email = user.email
        phone = ""
        picture = user.picture
    }
}
