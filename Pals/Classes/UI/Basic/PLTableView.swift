//
//  PLTableView.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/24/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLTableView: UIView {

    let tableView = UITableView()
    
    func configure() {
        tableView.frame = bounds
        addSubview(tableView)
    }

}


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