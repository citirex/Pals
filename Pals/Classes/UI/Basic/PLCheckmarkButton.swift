//
//  PLCheckmarkButton.swift
//  Pals
//
//  Created by Vitaliy Delidov on 11/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLHighlightedButton : PLRoundedButton {
    
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
    
    @IBInspectable var fillColor: UIColor = .chamrockColor()
    @IBInspectable var strokeColor: UIColor = .whiteColor()
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    
    override func drawRect(rect: CGRect) {
        fillColor.set()
        let circlePath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.width / 2.0)
        circlePath.fill()

        let checkmarkPath = UIBezierPath()
        checkmarkPath.moveToPoint(CGPointMake(CGRectGetWidth(bounds) * 0.27, CGRectGetHeight(bounds) * 0.54))
        checkmarkPath.addLineToPoint(CGPointMake(CGRectGetWidth(bounds) * 0.42, CGRectGetHeight(bounds) * 0.69))
        checkmarkPath.addLineToPoint(CGPointMake(CGRectGetWidth(bounds) * 0.75, CGRectGetHeight(bounds) * 0.35))
        checkmarkPath.lineCapStyle = .Square
        
        let checkmarkLayer = CAShapeLayer()
        checkmarkLayer.fillColor = nil
        checkmarkLayer.path = checkmarkPath.CGPath
        checkmarkLayer.strokeColor = strokeColor.CGColor
        checkmarkLayer.lineWidth   = lineWidth
        layer.addSublayer(checkmarkLayer)
    }
    
}
