//
//  PLFormTextField.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/7/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLFormTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        addBorder(.Bottom, color: .chatelleColor(), width: 1.0)
    }
}
