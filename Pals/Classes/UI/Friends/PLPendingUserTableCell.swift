//
//  PLPendingUserTableCell.swift
//  Pals
//
//  Created by ruckef on 25.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLPendingUserTableCell: PLUserTableCell {
    
    lazy var acceptButton: PLCheckmarkButton = {
        let ab = PLCheckmarkButton()
        ab.translatesAutoresizingMaskIntoConstraints = false
        return ab
    }()
    
    lazy var declineButton: PLCancelButton = {
        let cb = PLCancelButton()
        cb.translatesAutoresizingMaskIntoConstraints = false
        return cb
    }()
    
    override func initialize() {
        super.initialize()
    }
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(acceptButton)
        contentView.addSubview(declineButton)
    }
    
    override func setupLayoutConstraints() {
        super.setupLayoutConstraints()
        
        let views = ["accept" : acceptButton, "decline" : declineButton]
        let metrics = ["side" : 50, "offsetV" : 5, "offsetH" : 15]
        let strings = ["[accept(side)]-(offsetH)-|",
                       "[decline(side)]-(offsetH)-|",
                       "V:|-(offsetV)-[accept(side)]",
                       "V:[decline(side)]-(offsetV)-|"]
        contentView.addConstraints(strings, views: views, metrics: metrics)
    }
    
    override class func identifier() -> String {
        return "PLPendingUserTableCell"
    }
    
    override class func nibName() -> String {
        return "PLPendingUserTableCell"
    }
    
}
