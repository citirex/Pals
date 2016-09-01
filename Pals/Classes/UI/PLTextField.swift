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
            let line = UIView(frame: CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: 1.0))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = bottomBorderColor
            addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": 1.0]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[line]|", options: [], metrics: nil, views: views))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName : placeHolderColor!])
        }
    }

}

