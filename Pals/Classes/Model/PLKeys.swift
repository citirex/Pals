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
    case fbid
    case name
    case price
    case type
    case picture
    case picture_url
    case additional
    case url
    case email
    case email_unique
    case balance
    case user
    case username
    case user_id
    case info
    case response
    case friends
    case friend_id
    case filter
    case invited
    case invitefriends
    case places
    case orders
    case order_drinks
    case order_covers
    case login
    case password
    case facebook
    case genres
    case address
    case phone
    case date
    case data
    case location
    case events
    case device_token = "registration_id"
    case drink
    case drinks
    case vip_drinks
    case close_time
    case covers
    case cover
    case count
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
    case badges
    var string : String {
        return rawValue
    }
}
