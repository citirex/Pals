//
//  PLAddButton.swift
//  Pals
//
//  Created by Vitaliy Delidov on 12/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

@IBDesignable
class PLAddButton: PLHighlightedButton {
    
    @IBInspectable var fillColor: UIColor = .whiteColor()
    @IBInspectable var strokeColor: UIColor = .whiteColor()
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    
    override func drawRect(rect: CGRect) {
        
        let circlePath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.width / 2.0)
        fillColor.set()
        circlePath.fill()
        
        let plusHeight: CGFloat = lineWidth
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        let plusPath = UIBezierPath()
        plusPath.lineWidth = plusHeight
        plusPath.moveToPoint(CGPoint(x: bounds.width / 2 - plusWidth / 3 + 0.5, y: bounds.height / 2 + 0.5))
        plusPath.addLineToPoint(CGPoint(x: bounds.width / 2 + plusWidth / 3 + 0.5, y: bounds.height / 2 + 0.5))
        plusPath.moveToPoint(CGPoint(x: bounds.width / 2 + 0.5, y: bounds.height / 2 - plusWidth / 3 + 0.5))
        plusPath.addLineToPoint(CGPoint(x: bounds.width / 2 + 0.5, y: bounds.height / 2 + plusWidth / 3 + 0.5))
        plusPath.lineCapStyle = .Square
        
        let plusLayer = CAShapeLayer()
        plusLayer.fillColor = nil
        plusLayer.path = plusPath.CGPath
        plusLayer.strokeColor = strokeColor.CGColor
        plusLayer.lineWidth   = lineWidth
        layer.addSublayer(plusLayer)
        
//        strokeColor.setStroke()
//        plusPath.stroke()
    }
    
}