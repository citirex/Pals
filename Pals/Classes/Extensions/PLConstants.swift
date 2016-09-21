//
//  PLConstants.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLCollectionSectionType {
    case Covers
    case Drinks
}

enum TabBarControllerTabs: Int {
    case TabProfile = 0
    case TabLocation
    case TabOrder
    case TabFriends
    var int: Int {return rawValue}
}

var kPalsPurpleColor: UIColor {
    return UIColor(red:0.49, green:0.30, blue:0.62, alpha:1.0)
}

var kPalsGoldColor: UIColor {
    return UIColor(red:0.85, green:0.73, blue:0.19, alpha:1.0)
}


//MARK: - Order
//D9BA30 VIP card color
var kPalsOrderCardVIPColor: UIColor {
    return kPalsGoldColor
}

//322C58 liquor card color
var kPalsOrderCardDrinkStrongColor: UIColor {
    return UIColor(red:0.20, green:0.17, blue:0.35, alpha:1.0)
}

//00999E beer card color
var kPalsOrderCardDrinkLightColor: UIColor {
    return UIColor(red:0.00, green:0.60, blue:0.62, alpha:1.0)
}

//2be089 undefined drink color MY CUSTOM nod design color
var kPalsOrderCardDrinkUndefinedColor: UIColor {
    return UIColor(red:0.17, green:0.88, blue:0.54, alpha:1.0)
}

//823051 myself card color
var kPalsOrderCardMyselfColor: UIColor {
    return UIColor(red:0.51, green:0.19, blue:0.32, alpha:1.0)
}

//3CB17A cover background color
var kPalsOrderCoverItemColor: UIColor {
    return UIColor(red:0.24, green:0.69, blue:0.48, alpha:1.0)
}


let mainColor = UIColor(r: 125, g: 76, b: 158)