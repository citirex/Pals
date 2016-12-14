//
//  PLOrderHistorySectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

@IBDesignable
class PLOrderHistorySectionHeader: UITableViewHeaderFooterView {

    static let nibName         = "PLOrderHistorySectionHeader"
    static let reuseIdentifier = "SectionHeader"
    
    @IBOutlet weak var dateLabel: UILabel! 
        
    var order: PLOrder? {
        didSet {
            dateLabel.text = ""
            if let order = order {
                if let date = order.date {
                    dateLabel.text = date.since
                }
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBorder([.Top], color: .lightGrayColor(), width: 0.5)
    }
    
}
