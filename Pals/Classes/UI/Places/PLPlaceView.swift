//
//  PLPlaceView.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/21/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLPlaceView: UIView {

    let tableView = UITableView()
    
    func configure() {
        backgroundColor = .affairColor()
        tableView.frame = bounds
        addSubview(tableView)
    }
    
}
