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
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: borderWidth))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = borderColor
            addSubview(line)
            
            let views = ["line" : line]
            let metrics = ["lineWidth" : borderWidth]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName : placeHolderColor!])
        }
    }

}

