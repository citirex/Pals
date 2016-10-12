//
//  PLAttributedString.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/11/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    convenience init?(string text: String?, font: UIFont!, color: UIColor!) {
        self.init(string: text!, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color])
    }
    
    convenience init?(string text: String?, font: UIFont!) {
        self.init(string: text!, attributes: [NSFontAttributeName: font])
    }

}