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
	@IBOutlet weak var addButtonOutlet: UIButton!
    
	@IBAction func addButtonClicked(sender: AnyObject) {
		addButtonOutlet.setImage(UIImage(named: "success"), forState: .Normal)
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
