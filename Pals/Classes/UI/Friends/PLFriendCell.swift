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
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	var friend: PLUser? {
		didSet {
			let FriendCellData = friend!.cellData
			avatarImage.setImageWithURL(FriendCellData.picture)
			nameLabel.text = FriendCellData.name
		}
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
