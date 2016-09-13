//
//  PLTextField.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLTextField: UITextField {
    
    @IBInspectable var separatorWidth: CGFloat = 0
    @IBInspectable var separatorColor: UIColor = .clearColor()
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            attributedPlaceholder =
                NSAttributedString(string: placeholder != nil ? placeholder! : "",
                attributes: [NSForegroundColorAttributeName : placeHolderColor!])
        }
    }
    
    override func drawRect(rect: CGRect) {
        let startingPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        path.lineWidth = separatorWidth
        separatorColor.setStroke()
        path.stroke()
    }

}

