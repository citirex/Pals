//
//  PLTextField.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLTextField: UITextField {
    
    let separatorWidth: CGFloat = 2
    let separatorColor: UIColor = .lightGrayColor()
    let placeHolderColor: UIColor = .lightGrayColor()
    var padding: UIEdgeInsets!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        padding = UIEdgeInsets(top: CGRectGetHeight(frame) / 2, left: 0, bottom: 0, right: 0)
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "",
                               attributes: [NSForegroundColorAttributeName : placeHolderColor])
    }
    
    
    override func drawRect(rect: CGRect) {
        let startingPoint = CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMaxY(rect))
        let endingPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))
        
        let path = UIBezierPath()
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        path.lineWidth = separatorWidth
        separatorColor.setStroke()
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

