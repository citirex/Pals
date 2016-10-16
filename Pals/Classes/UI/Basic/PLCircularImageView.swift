//
//  PLCircularImageView.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/15/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLCircularImageView: UIImageView {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rounded = true
    }
    
}
