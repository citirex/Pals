//
//  PLCheckmarkButton.swift
//  Pals
//
//  Created by Vitaliy Delidov on 11/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLHighlightedButton : UIButton {
    override var highlighted: Bool {
        didSet {
            if highlighted {
                alpha = 0.7
            } else {
                alpha = 1
            }
        }
    }
}

@IBDesignable
class PLCheckmarkButton: PLHighlightedButton {
    
    let lineWidth: CGFloat = 2.0
    let strokeColor = UIColor.whiteColor().CGColor
    
    override func drawRect(rect: CGRect) {
        UIColor.chamrockColor.set()
        UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.width / 2.0).fill()
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGRectGetWidth(bounds) * 0.27, CGRectGetHeight(bounds) * 0.54))
        path.addLineToPoint(CGPointMake(CGRectGetWidth(bounds) * 0.42, CGRectGetHeight(bounds) * 0.69))
        path.addLineToPoint(CGPointMake(CGRectGetWidth(bounds) * 0.75, CGRectGetHeight(bounds) * 0.35))
        path.lineCapStyle = .Square
        
        let checkmarkLayer = CAShapeLayer()
        checkmarkLayer.fillColor = nil
        checkmarkLayer.path = path.CGPath
        checkmarkLayer.strokeColor = strokeColor
        checkmarkLayer.lineWidth   = lineWidth
        layer.addSublayer(checkmarkLayer)
    }

}
