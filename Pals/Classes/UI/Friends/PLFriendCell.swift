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
	
	var friendStatus: PLAddFriendStatus = .NotFriend
	
	lazy var addButton: UIButton = {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
		button.addTarget(self, action: #selector(addFriendAction(_:)), forControlEvents: .TouchUpInside)
		button.setImage(UIImage(named: "plus"), forState: .Normal)
		return button
	}()

	var currentUrl = ""
	
	var friend: PLUser? {
		didSet { setup() }
	}
	
	func setup() {
		if let aFriend = friend {
			avatarImage.backgroundColor = UIColor.affairColor()
			let friendCellData = aFriend.cellData
			setCorrectImage(friendCellData.picture)
			nameLabel.text = friendCellData.name
			
		} else {
			print("Friend Cell Data is empty!")
		}
	}
	
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = UIImage(named: "icon_user_placeholder")
		addButton.imageView?.image = UIImage(named: "plus")
    }
	
	func setCorrectImage(url: NSURL) {
		avatarImage.backgroundColor = UIColor.affairColor()
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
	
	
	func addFriendAction(sender: UIButton){
		
		if friendStatus == .NotFriend{
			print("sendYES")
			friendStatus = .Friend
		addButton.setImage(UIImage(named: "success"), forState: .Normal)
		} else {
			print("sendNO")
		}
		
		
	}
}
