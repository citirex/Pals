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
    
    var drinkCellData: PLDrinkCellData! {
        didSet {
            textLabel?.text = drinkCellData.name
            detailTextLabel?.text = String(format: "$%0.2f", drinkCellData.price)
        }
    }

}
