//
//  PLRoundedButton.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/16/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLRoundedButton: UIButton {
        

    override func layoutSubviews() {
        super.layoutSubviews()
        
        rounded = true
    }

}
