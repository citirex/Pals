//
//  PLOrderHistorySectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLOrderHistorySectionHeader: UITableViewCell {

    static let reuseIdentifier = "SectionHeader"
    
    @IBOutlet weak var dateLabel: UILabel!
        
    var orderCellData: PLOrderCellData! {
        didSet {
            dateLabel.text = orderCellData.date.since
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBorder(.Top, color: .lightGrayColor(), width: 0.5)
    }
    
}
