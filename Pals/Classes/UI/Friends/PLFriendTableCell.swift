//
//  PLFriendTableCell.swift
//  Pals
//
//  Created by ruckef on 25.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLFriendTableCell: PLUserTableCell {

    lazy var pendingLabel: UILabel = {
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.font = UIFont(name: "HelveticaNeue-Italian", size: 13)
        pl.textColor = .violetColor
        pl.textAlignment = .Right
        pl.text = "pending"
        return pl
    }()
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(pendingLabel)
    }
    
    override func setupLayoutConstraints() {
        super.setupLayoutConstraints()
        let views = ["pending" : pendingLabel]
        let metrics = ["offset" : 15]
        let strings = ["|-(offset)-[pending]-(offset)-|",
                       "V:[pending(20)]-(offset)-|"]
        contentView.addConstraints(strings, views: views, metrics: metrics)
    }
    
    override var user: PLUser? {
        didSet {
            if let u = user {
                pendingLabel.hidden = !u.pending
            } else {
                pendingLabel.hidden = true
            }
        }
    }
}