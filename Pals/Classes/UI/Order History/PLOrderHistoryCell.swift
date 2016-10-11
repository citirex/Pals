//
//  PLOrderHistoryCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLOrderHistoryCell: UITableViewCell {

    static let reuseIdentifier = "OrderHistoryCell"
    
    var drink: PLDrink! {
        didSet {
            textLabel?.text = drink.name
            detailTextLabel?.text = String(format: "$%0.2f", drink.price)
        }
    }

}
