//
//  PLOrderHistorySectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLOrderHistorySectionHeader: UITableViewHeaderFooterView {

    static let nibName         = "PLOrderHistorySectionHeader"
    static let reuseIdentifier = "SectionHeader"
    
    @IBOutlet weak var dateLabel: UILabel! 
        
    var orderCellData: PLOrderCellData! {
        didSet {
            if let date = orderCellData.date {
                dateLabel.text = date.since
            } else {
                dateLabel.text = String()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBorder(.Top, color: .lightGrayColor(), width: 0.5)
    }
    
}
