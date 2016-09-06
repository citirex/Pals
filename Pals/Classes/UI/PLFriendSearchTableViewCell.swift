//
//  PLFriendSearchTableViewCell.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLFriendSearchTableViewCell: UITableViewCell {

	@IBAction func addButtonClicked(sender: AnyObject) {
		addButtonOutlet.setImage(UIImage(named: "success"), forState: .Normal)
	}
	@IBOutlet weak var addButtonOutlet: UIButton!
	@IBOutlet weak var avatarImage: PLImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
