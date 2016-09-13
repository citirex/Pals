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
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            let separator = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: borderWidth))
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.backgroundColor = separatorColor
            addSubview(separator)
            
            let views = ["line" : separator]
            let metrics = ["lineWidth" : borderWidth]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    
    @IBInspectable var separatorColor: UIColor? {
        didSet {
            layer.borderColor = separatorColor?.CGColor
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName : placeHolderColor!])
        }
    }

}

