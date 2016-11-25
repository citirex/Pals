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
    
    private var maxLengths = [UITextField: Int]()
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else { return Int.max }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: .limitLength, forControlEvents: .EditingChanged)
        }
    }
    
    
    func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text
            where prospectiveText.characters.count > maxLength else { return }
        
        let selection = selectedTextRange
        text = prospectiveText.substringWithRange(
            Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.startIndex.advancedBy(maxLength))
        )
        selectedTextRange = selection
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addBorder(.Bottom, color: .textUnderlineColor, width: 1.0)
    }
}