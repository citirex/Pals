//
//  PLEditTextField.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/12/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLEditTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTarget(self, action: #selector(textFieldTextDidChange), forControlEvents: .EditingChanged)
    }
    
    func textFieldTextDidChange(textField: UITextField) {
        textField.invalidateIntrinsicContentSize()
    }
    
    override func intrinsicContentSize() -> CGSize {
        if editing {
            let textSize = NSString(string: ((text ?? "" == "") ? placeholder : text) ?? "").sizeWithAttributes(typingAttributes)
            return CGSize(width: textSize.width + (leftView?.bounds.size.width ?? 0) + (rightView?.bounds.size.width ?? 0) + 2, height: textSize.height)
        } else {
            return super.intrinsicContentSize()
        }
    }

}
