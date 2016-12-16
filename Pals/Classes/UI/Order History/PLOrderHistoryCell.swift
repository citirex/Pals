//
//  PLOrderHistoryCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

enum Condition: String {
    case Avaiable
    case Expired
    case Used
}

class PLOrderHistoryCell: UITableViewCell {

    static let reuseIdentifier = "OrderHistoryCell"
    
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var conditionLabel: PLVerticalLabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var condition: Condition! {
        didSet {
            setCondition()
            conditionLabel.text = condition.rawValue
        }
    }
    
    
    func setCondition() {
        guard let condition = condition else { return }
        
        switch condition {
        case .Avaiable:
            conditionLabel.backgroundColor = .greenColor()
            conditionLabel.textColor = .whiteColor()
        case .Used:
            conditionLabel.backgroundColor = .yellowColor()
            conditionLabel.textColor = .whiteColor()
        case .Expired:
            conditionLabel.backgroundColor = .redColor()
            conditionLabel.textColor = .whiteColor()
        }
        conditionLabel.text = condition.rawValue
    }

    
    var itemSet: PLItemSet<PLDrink>! {
        didSet {
            drinkNameLabel?.text = itemSet.item.name
            amountLabel.text = String(itemSet.quantity)
            priceLabel?.text = String(format: "$%0.2f", itemSet.item.price * Float(itemSet.quantity))
            if itemSet.expired {
                condition = .Expired
            }
        }
    }
    
    var order: PLOrder! {
        didSet {
            condition = order.used ? .Used : .Avaiable
        }
    }
        
}
