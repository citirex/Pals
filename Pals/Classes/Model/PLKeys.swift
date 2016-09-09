//
//  PLKey.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

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
    case message
    case place
    case is_vip
    case access_code
    case qr_code
    var string : String {
        return rawValue
    }
}
