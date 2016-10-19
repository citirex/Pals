//
//  PLFriendCell.swift
//  Pals
//
//  Created by Карпенко Михайло on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLAddFriendStatus : Int {
	case NotFriend
	case Friend
}

protocol PLFriendCellDelegate: class {
    func addFriendButtonPressed(sender: PLFriendCell)
}

class PLFriendCell: UITableViewCell{
	
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	var friendStatus: PLAddFriendStatus?
    var cellData: PLFriendCellData?
    
	lazy var addButton: UIButton = {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
		button.addTarget(self, action: #selector(addFriendAction(_:)), forControlEvents: .TouchUpInside)
		button.setImage(UIImage(named: "contact_add"), forState: .Normal)
		return button
	}()

	var currentUrl = ""
    
    weak var delegate : PLFriendCellDelegate?
	
    func setup(cellData: PLFriendCellData) {
        self.cellData = cellData
        _updateUI(cellData)
	}
    
    func updateUI() {
        if cellData != nil {
            _updateUI(cellData!)
        }
    }
    
    private func _updateUI(cellData: PLFriendCellData){
        if cellData.picture.absoluteString == "" {
            avatarImage.contentMode = .Center
            avatarImage.backgroundColor = UIColor.affairColor()
            avatarImage.image = UIImage(named: "user")
        } else {
            avatarImage.contentMode = .ScaleAspectFit
            avatarImage.backgroundColor = UIColor.clearColor()
            setCorrectImage(cellData.picture)
        }
        nameLabel.text = cellData.name
    }
	
    func setupInviteUI() {
        if let data = cellData {
            if accessoryView != addButton {
                accessoryView = addButton
            }
            let buttonImage = data.invited  == true ? UIImage(named: "check_mark") : UIImage(named: "contact_add")
            addButton.userInteractionEnabled = !data.invited
            if addButton.currentImage != buttonImage {
                addButton.setImage(buttonImage, forState: .Normal)
            }
        }
    }
    
	override func awakeFromNib() {
		selectionStyle = UITableViewCellSelectionStyle.None
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
					if self.avatarImage.image == UIImage(named: "user") {
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
	
	func addFriendAction(sender: PLFriendCell) {
		delegate?.addFriendButtonPressed(self)
	}
}
