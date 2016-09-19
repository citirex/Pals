//
//  PLHistoryCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/19/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLHistoryCell: UITableViewCell {
    
    static let nibName = "PLHistoryCell"
    static let reuseIdentifier = "HistoryCell"
    
    
    var drink: PLDrink! {
        didSet {
            setup()
        }
    }

    func setup() {
        textLabel?.text = drink.name
        detailTextLabel?.text = String(format: "$%0.2f", drink.price)
    }
    
    
}
