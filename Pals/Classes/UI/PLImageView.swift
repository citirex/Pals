//
//  PLImageView.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/4/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLImageView: UIImageView {

    @IBInspectable var rounded: Bool = false {
        didSet {
            layer.cornerRadius = rounded ? frame.width / 2 : 0
            layer.masksToBounds = rounded ? true : false
        }
    }


}
