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
    
    
    /// Place screen navigation bar color
    
    class func affairColor() -> UIColor {
        return UIColor(r: 91.0, g: 43.0, b: 133.0)
    }
    
	
    /// Add Funds  back barButtonItem
    
    class func eminenceColor() -> UIColor {
        return UIColor(r: 104.0, g: 50.0, b: 144.0)
    }
    
    
    /// Add Funds  refill button
    
    class func caribeanGreenColor() -> UIColor {
        return UIColor(r: 56.0, g: 206.0, b: 130.0)
    }
    
    
    /// Card Info  complete button
    
    class func mediumOrchidColor() -> UIColor {
        return UIColor(r: 184.0, g: 9.0, b: 222.0)
    }
    
 
    /// Friends  search icon
    
    class func vividViolet() -> UIColor {
        return UIColor(r: 136.0, g: 41.0, b: 152.0)
    }
	
	/// Friends  navigation bar
	
	class func miracleColor() -> UIColor {
		return UIColor(r: 251.0, g: 251.0, b: 251.0)
	}
    
}
