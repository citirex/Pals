//
//  PLTextField.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLTextField: UITextField {
    
    private var padding: UIEdgeInsets {
        return UIEdgeInsets(top: CGRectGetHeight(frame) / 3, left: 0, bottom: 0, right: 0)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        font = UIFont.customFontOfSize(15)
    }
    
    override func drawRect(rect: CGRect) {
        let startingPoint = CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMaxY(rect))
        let endingPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))
        
        let path = UIBezierPath()
        path.lineWidth = 2
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        UIColor.chatelleColor().setStroke()
        path.stroke()
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}

