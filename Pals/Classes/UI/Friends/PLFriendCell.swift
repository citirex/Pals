//
//  PLFriendCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 12/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLFriendCell: UITableViewCell {
    
    static let nibName = "PLFriendCell"
    static let reuseIdentifier = "FriendCell"
    
    @IBOutlet weak var userImageView: PLCircularImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    
    
    var user: PLUser? {
        didSet {
            usernameLabel.text = user?.name ?? "<Error>"
            let placeholderImage = UIImage(named: "user_placeholder")
            userImageView.setImageWithURL(user!.picture, placeholderImage: placeholderImage)
            
            guard let user = user else { return pendingLabel.hidden = true }
            pendingLabel.hidden = !user.pending
        }
    }
    
}