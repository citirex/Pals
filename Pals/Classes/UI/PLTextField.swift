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
    
    @IBInspectable var bottomBorderColor: UIColor? {
        didSet {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0.0, frame.size.height - 1, frame.size.width, 1.0)
            bottomBorder.backgroundColor = bottomBorderColor!.CGColor
            layer.addSublayer(bottomBorder)
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName : placeHolderColor!])
        }
    }
    
}

