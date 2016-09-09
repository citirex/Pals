//
//  PLKey.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

// https://api.pals.com/login?login=username&password=12345
// https://api.pals.com/friends?id=666&page=0&per_page=20
// https://api.pals.com/places?lat=50.448042&long=30.497832&dlat=0.105235&dlong=0.120532

enum PLKeys : String {
    case id
    case name
    case picture
    case email
    case balance
    case user
    case response
    case friends
    case places
    case login
    case password
    case genres
    case address
    case phone
    case location
    case close_time
    case events
    case drink
    case rect
    case success
    case per_page
    case since
    case page
    case lat
    case long
    case dlat // delta latitude
    case dlong // delta longitude
    var string : String {
        return rawValue
    }
}
