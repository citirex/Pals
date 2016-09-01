//
//  PLAddButton.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLAddButton: UIButton {

    private var fillColor: UIColor = .whiteColor()
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        path.fill()
   
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        let plusPath = UIBezierPath()
        plusPath.lineWidth = plusHeight
        plusPath.moveToPoint(CGPoint(x: bounds.width / 2 - plusWidth / 5 + 0.5, y: bounds.height / 2 + 0.5))
        plusPath.addLineToPoint(CGPoint(x: bounds.width / 2 + plusWidth / 5 + 0.5, y: bounds.height / 2 + 0.5))
        plusPath.moveToPoint(CGPoint(x: bounds.width / 2 + 0.5, y: bounds.height / 2 - plusWidth / 5 + 0.5))
        plusPath.addLineToPoint(CGPoint(x: bounds.width / 2 + 0.5, y: bounds.height / 2 + plusWidth / 5 + 0.5))
       
        UIColor.blackColor().setStroke()
        plusPath.stroke()
    }
    
}

