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
    
    
    /// Navigation bar color #6F4097
    
    class func affairColor() -> UIColor {
        return UIColor(red:0.44, green:0.25, blue:0.59, alpha:1.0)
    }
    
	
    /// Add Funds  back barButtonItem
    
    class func eminenceColor() -> UIColor {
        return UIColor(r: 104.0, g: 50.0, b: 144.0)
    }
    
    
    /// Add Funds  refill button
    
    class func caribeanGreenColor() -> UIColor {
        return UIColor(r: 56.0, g: 206.0, b: 130.0)
    }
    
    
    
    
 
    /// Friends  search icon
    
    class func vividViolet() -> UIColor {
        return UIColor(r: 136.0, g: 41.0, b: 152.0)
    }
	
	/// Friends  navigation bar
	
	class func miracleColor() -> UIColor {
		return UIColor(r: 251.0, g: 251.0, b: 251.0)
	}
    
    
    //////////////////////////////////////////////////
    
    /// Sign Up screen 
    
    // TextField placeholder color
    class func chatelleColor() -> UIColor {
        return UIColor(r: 189.0, g: 177.0, b: 200.0)
    }
    
    /// Edit Profile
    
    // Line border for label
    class func darkGray() -> UIColor {
        return UIColor(r: 151, g: 151.0, b: 151.0)
    }
    
    // navigation bar tint color for imagePicker
    class func crayonPurple() -> UIColor {
        return UIColor(r: 111.0, g: 64.0, b: 151.0)
    }
    
    // description label text color
    class func doveGray() -> UIColor {
        return UIColor(r: 92.0, g: 92.0, b: 92.0)
    }
    
    /// Card Info
    
    // complete button tint color
    class func mediumOrchidColor() -> UIColor {
        return UIColor(r: 189.0, g: 16.0, b: 224.0)
    }
    
}
