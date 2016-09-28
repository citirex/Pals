//
//  PLFont.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/26/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation


extension UIFont {

    class func customFontOfSize(size: CGFloat) -> UIFont {
        var fontSize = size
        
        switch UIDevice.currentDevice().type {
        case .iPhone4S, .iPhone5, .iPhone5C, .iPhone5S:
            break
        case .iPhone6, .iPhone6S:
            fontSize += 2
        case .iPhone6plus:
            fontSize += 3
        default:
            break
        }
        return .systemFontOfSize(fontSize)
    }
    
    
    class func customFontOfSize(size: CGFloat, weight: CGFloat) -> UIFont {
        return systemFontOfSize(customFontOfSize(size).pointSize, weight: weight)
    }
    
}