//
//  PLColor.swift
//  Pals
//
//  Created by ruckef on 13.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let divider = CGFloat(255)
        self.init(red: r/divider, green: g/divider, blue: b/divider, alpha: a/divider)
    }
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 255)
    }
    
    convenience init(white: CGFloat) {
        self.init(r: white, g: white, b: white, a: 255)
    }
    
    static func rand() -> UIColor {
        let r = CGFloat(arc4random()%255)
        let g = CGFloat(arc4random()%255)
        let b = CGFloat(arc4random()%255)
        let color = UIColor(r: r, g: g, b: b)
        return color
    }
}
