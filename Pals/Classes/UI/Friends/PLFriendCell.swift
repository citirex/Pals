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
		button.setImage(UIImage(named: "contact_add"), forState: .Normal)
		return button
	}()

	var currentUrl = ""
	
	var friend: PLUser? {
		didSet { setup() }
	}
	
	func setup() {
		if let aFriend = friend {
			let friendCellData = aFriend.cellData
			if friendCellData.picture.absoluteString == "" {
				avatarImage.contentMode = .Center
				avatarImage.backgroundColor = UIColor.affairColor()
				avatarImage.image = UIImage(named: "user")
			} else {
				avatarImage.contentMode = .ScaleAspectFit
				avatarImage.backgroundColor = UIColor.clearColor()
				setCorrectImage(friendCellData.picture)
			}
			nameLabel.text = friendCellData.name
			
		} else {
			PLLog("Friend Cell Data is empty!")
		}
	}
	
	override func awakeFromNib() {
		selectionStyle = UITableViewCellSelectionStyle.None
	}
	
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
		addButton.imageView?.image = UIImage(named: "contact_add")
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
					if self.avatarImage.image == UIImage(named: "user"){
						return
					} else {
						self.avatarImage.image = image
					}
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
			PLLog("sendYES")
			friendStatus = .Friend
		addButton.setImage(UIImage(named: "check_mark"), forState: .Normal)
			
		} else {
			PLLog("sendNO")
		}
		
		
	}
}
