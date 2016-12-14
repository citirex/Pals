//
//  PLSearchBar.swift
//  Pals
//
//  Created by Vitaliy Delidov on 12/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation


extension UISearchBar {
    
    var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else { return nil
        }
        return textField
    }
    
}