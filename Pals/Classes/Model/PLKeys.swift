//
//  PLKey.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLKey : String {
    case any
    case access_code
    case additional
    case address
    case auth_data
    case address_zip
    case answer
    
    case badges
    
    case close_time
    case covers
    case cover
    case cover_sale_start
    case count
    case customer
    
    case date
    case data
    case drink
    case drinks
    case dinosaur
    case dlat // delta latitude
    case dlong // delta longitude
    case device_token = "registration_id"
    case duration
    
    case email
    case email_unique
    case ends
    case events
    case expires
    case exp_month
    case exp_year
    
    case fbid
    case friends
    case friend_id
    case filter
    case facebook
    
    case genres
    
    case id
    case info
    case invited
    case invitefriends
    case is_split_covers
    case is_split_drinks
    case is_vip
    case is_used
    
    case login
    case location
    case lat
    case long
    case last4
    
    case message
    
    case name
    
    case offset
    case order
    case orders
    case order_drinks
    case order_covers
    case order_id
    
    case place_id
    case price
    case picture
    case picture_url
    case place
    case places
    case password
    case phone
    case per_page
    case pending
    
    case quantity
    case qr_code
    
    case response
    case rect
    
    case success
    case since
    case source
    case starts
    
    case type
    case token
    
    case url
    case user
    case username
    case user_id
    
    case vip_drinks
    case vip_covers
    
    var string : String {
        return rawValue
    }
}
