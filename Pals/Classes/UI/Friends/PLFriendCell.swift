//
//  PLFriendCell.swift
//  Pals
//
//  Created by Карпенко Михайло on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//
import UIKit

class PLFriendCell: UITableViewCell{
	
	@IBOutlet weak var avatarImage: PLImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var addButton: UIButton!
    
	@IBAction func addFriend(sender: AnyObject) {
	}
	
	var friend: PLUser? {
		didSet {
            if let aFriend = friend {
                let friendCellData = aFriend.cellData
                avatarImage.setImageWithURL(friendCellData.picture)
                nameLabel.text = friendCellData.name
            } else {
                print("Friend Cell Data is empty!")
            }
		}
	}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
    }
}


class PLFriendSearchCell: PLFriendCell{
	
	override func addFriend(sender: AnyObject) {
		addButton.setImage(UIImage(named: "success"), forState: .Normal)
	}
}