//
//  PLNewFriendNotificationCell.swift
//  Pals
//
//  Created by Карпенко Михайло on 15.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLNewFriendNotificationCell: UITableViewCell {
	
	static let nibName    = "PLNewFriendNotificationCell"
	static let identifier = "NewFriendNotificationCell"

	@IBOutlet var avatarNewFriend: PLCircularImageView!
	@IBOutlet var labelNewFriend: UILabel!
	@IBAction func confirmButton(sender: AnyObject) {
	}
	@IBAction func declineButton(sender: AnyObject) {
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
