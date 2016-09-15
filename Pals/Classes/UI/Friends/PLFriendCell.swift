//
//  PLFriendCell.swift
//  Pals
//
//  Created by Карпенко Михайло on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//
import UIKit

class PLFriendCell: UITableViewCell{
	
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var addButton: UIButton!
	
	var currentUrl = ""
	
	var friend: PLUser? {
		didSet { setup() }
	}
	
	private func setup() {
		if let aFriend = friend {
			let friendCellData = aFriend.cellData
			setCorrectImage(friendCellData.picture)
			nameLabel.text = friendCellData.name
			
		} else {
			print("Friend Cell Data is empty!")
		}
	}
	
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
    }
	
	func setCorrectImage(url: NSURL) {
		avatarImage.image = nil
		let urlString = url.absoluteString
		let request = NSURLRequest(URL: url)
		currentUrl = urlString
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if urlString != self.currentUrl {
				return
			}
			self.avatarImage.setImageWithURLRequest(request, placeholderImage: nil, success: {[unowned self] (request, response, image) in
				if urlString != self.currentUrl {
					return
				}
				dispatch_async(dispatch_get_main_queue(), { [unowned self] in
					self.avatarImage.image = image
					})
			}) {[unowned self] (request, response, error) in
				dispatch_async(dispatch_get_main_queue()) {
					self.avatarImage.image = nil
				}
			}
		}
	}
}


class PLFriendSearchCell: PLFriendCell{

//		addButton.setImage(UIImage(named: "success"), forState: .Normal)
}