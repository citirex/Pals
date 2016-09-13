//
//  PLConstants.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

enum CurrentTab {
    case Covers
    case Drinks
}

enum TabBarController: Int {
    case TabProfile = 0
    case TabLocation
    case TabOrder
    case TabFriends
    var int: Int {return rawValue}
}

var kPalsPurpleColor: UIColor {
    return UIColor(red:0.49, green:0.30, blue:0.62, alpha:1.0)
}

let mainColor = UIColor(r: 125, g: 76, b: 158)