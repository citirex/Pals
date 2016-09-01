//
//  PLImageView.swift
//  Pals
//
//  Created by Vitaliy Delidov on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLImageView: UIImageView {
    
  
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            layer.cornerRadius = rounded ? frame.width / 2 : 0
            layer.masksToBounds = rounded ? true : false
        }
    }

}
