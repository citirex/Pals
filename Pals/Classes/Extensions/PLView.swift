//
//  PLView.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/13/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

extension UIView {
    
    @IBInspectable var rounded: Bool {
        get {
            return layer.cornerRadius > 0
        }
        set {
            layer.cornerRadius = newValue ? frame.width / 2 : 0
            layer.masksToBounds = newValue ? true : false
        }
    }
    
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(CGColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }

    
    func round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        layer.mask = mask
        return mask
    }
    
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.addAnimation(animation, forKey: "shake")
    }
    
    func addShadow(shadowColor: CGColor = UIColor.blackColor().CGColor,
                   shadowOffset: CGSize = CGSizeMake(0.0, 0.5),
                   shadowRadius: CGFloat = 1,
                   shadowOpacity: Float = 1) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
        layer.shouldRasterize = true
    }

}
