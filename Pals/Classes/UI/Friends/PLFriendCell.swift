//
//  PLFriendCell.swift
//  Pals
//
//  Created by Карпенко Михайло on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLFriendCellDelegate: class {
    func addFriendButtonPressed(sender: PLFriendCell)
}

class PLFriendCell: UITableViewCell{
    
    static let nibName    = "PLFriendCell"
    static let identifier = "FriendCell"
	
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
    var cellData: PLFriendCellData?
    
	lazy var addButton: UIButton = {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
		button.addTarget(self, action: #selector(addFriendAction(_:)), forControlEvents: .TouchUpInside)
		button.setImage(UIImage(named: "contact_add"), forState: .Normal)
		return button
	}()
    
    lazy var loadingIndicatorView: PLLoadingIndicatorView = {
        return PLLoadingIndicatorView(frame:CGRectMake(0,0,33,33),indicatorStyle: .Gray)
    }()

    private var invitedUserID: UInt64 = 0
    
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
        if cellData.picture.absoluteString.hasSuffix("default_avatar.png") || cellData.picture.absoluteString.hasSuffix("blank_avatar_240x240.gif") || (cellData.picture.absoluteString == ""){
            avatarImage.contentMode = .Center
            avatarImage.backgroundColor = .affairColor()
            avatarImage.image = UIImage(named: "user")
        } else {
			avatarImage.contentMode = .ScaleAspectFill
            avatarImage.backgroundColor = .affairColor()
            setCorrectImage(cellData.picture)
        }
        
        if cellData.me {
            nameLabel.text      = "Me"
            nameLabel.textColor = .whiteColor()
            backgroundColor     = .affairColor()
        } else {
            nameLabel.text = cellData.name
        }
    }
	
    func setupInviteUI() {
        if let data = cellData {
            if data.inviting == true && data.id == invitedUserID {
                if accessoryView != loadingIndicatorView {
                    accessoryView = loadingIndicatorView
                }
                loadingIndicatorView.startAnimating()
            } else {                
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
    }
    
	override func awakeFromNib() {
		selectionStyle = UITableViewCellSelectionStyle.None
	}
	
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
    }
	
	func setCorrectImage(url: NSURL) {
        avatarImage.setImageSafely(fromURL: url, placeholderImage: UIImage(named: "user"))
	}

	func addFriendAction(sender: PLFriendCell) {
        invitedUserID = cellData!.id
		delegate?.addFriendButtonPressed(self)
	}
}
