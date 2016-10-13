//
//  PLKey.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLKeys : String {
    case id
    case place_id
    case name
    case price
    case type
    case picture
    case email
    case email_unique
    case balance
    case user
    case username
    case user_id
    case info
    case response
    case friends
    case invited
    case invitefriends
    case places
    case orders
    case order_drinks
    case order_covers
    case login
    case password
    case genres
    case address
    case phone
    case date
    case location
    case close_time
    case events
    case drink
    case drinks
    case vip_drinks
    case covers
    case vip_covers
    case rect
    case success
    case dinosaur
    case per_page
    case since
    case quantity
    case offset
    case lat
    case long
    case dlat // delta latitude
    case dlong // delta longitude
    case message
    case place
    case is_vip
    case access_code
    case qr_code
    case token
    case expires
    case auth_data
    var string : String {
        return rawValue
    }
}
