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
    
    
    override func drawRect(rect: CGRect) {
        let startingPoint = CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMaxY(rect))
        let endingPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))
        
        let path = UIBezierPath()
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        path.lineWidth = 2
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustFontToIPhoneSize()
    }
    
    
    private func adjustFontToIPhoneSize() {
        switch UIDevice.currentDevice().type {
        case .iPhone4S, .iPhone5, .iPhone5C, .iPhone5S:
            font = UIFont.systemFontOfSize(15.0)
        case .iPhone6, .iPhone6S:
            font = UIFont.systemFontOfSize(17.0)
        case .iPhone6plus:
            font = UIFont.systemFontOfSize(19.0)
        default:
            break
        }
    }

    
}

