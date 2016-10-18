//
//  PLTableView.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/17/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

extension UITableView {
    
    func hideSearchBar() {
        if let bar = tableHeaderView as? UISearchBar {
            let height = CGRectGetHeight(bar.frame)
            let offset = contentOffset.y
            if offset < height {
                contentOffset = CGPointMake(0, height)
            }
        }
    }
}