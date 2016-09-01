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
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = bottomBorderColor?.CGColor
            border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: frame.size.height)
            border.borderWidth = width
            layer.addSublayer(border)
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName : placeHolderColor!])
        }
    }

}

