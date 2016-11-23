//
//  PLColor.swift
//  Pals
//
//  Created by ruckef on 13.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

extension UIColor {

    convenience init(r: UInt, g: UInt, b: UInt, a: UInt) {
        let divider = CGFloat(255)
        let color: (CGFloat,CGFloat,CGFloat,CGFloat) = (CGFloat(r)/divider, CGFloat(g)/divider, CGFloat(b)/divider, CGFloat(a)/divider)
        self.init(red: color.0, green: color.1, blue: color.2, alpha: color.3 )
    }
    convenience init(r: UInt, g: UInt, b: UInt) {
        self.init(r: r, g: g, b: b, a: 255)
    }
    
    convenience init(_ r: UInt, _ g: UInt, _ b: UInt) {
        self.init(r: r, g: g, b: b)
    }
    
    convenience init(rgb: (UInt,UInt,UInt)) {
        self.init(r: rgb.0, g: rgb.1, b: rgb.2)
    }
    
    convenience init(white: UInt) {
        self.init(r: white, g: white, b: white)
    }
    
    static func rand() -> UIColor {
        let r = UInt(arc4random()%255)
        let g = UInt(arc4random()%255)
        let b = UInt(arc4random()%255)
        let color = UIColor(r: r, g: g, b: b)
        return color
    }
    
    
    // NavigationBar tintColor
    class func affairColor() -> UIColor {
        return UIColor(r: 111, g: 64, b: 151)
    }
    
    /// Sign Up screen 
    
    // TextField placeholder color
    class func chatelleColor() -> UIColor {
        return UIColor(r: 189, g: 177, b: 20)
    }
    
    /// Edit Profile
    
    // Line border for label
    class func darkGray() -> UIColor {
        return UIColor(r: 151, g: 151, b: 151)
    }
    
    // navigation bar tint color for imagePicker
    class func crayonPurple() -> UIColor {
        return UIColor(r: 111, g: 64, b: 151)
    }
    
    // description label text color
    class func doveGray() -> UIColor {
        return UIColor(r: 92, g: 92, b: 92)
    }
    
    // invite pals button background
    class func chamrockColor() -> UIColor {
        return UIColor(r: 59, g: 204, b: 136)
    }
    
    // background for error label on scan view
    class func maroonColor() -> UIColor {
        return UIColor(r: 120, g: 14, b: 14)
    }
    
    /// Card Info
    
    // complete button tint color
    class func mediumOrchidColor() -> UIColor {
        return UIColor(r: 189, g: 16, b: 224)
    }
    
    
    class var beerColor: UIColor { return UIColor(241,197,0) }
    class var spiritColor: UIColor { return UIColor(147,80,0) }
    class var cocktailColor: UIColor { return UIColor(140,224,254) }
    class var wineColor: UIColor { return UIColor(131,0,14) }
    class var nonAlcoholColor: UIColor { return UIColor(130,200,83) }
    class var unknownColor: UIColor { return UIColor(white: 152) }
    
    class var coverColor: UIColor { return UIColor(100,66,147) }
    class var vipColor: UIColor { return UIColor(193,61,61) }
    class var myCardColor: UIColor { return UIColor(130,48,81) }
}