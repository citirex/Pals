//
//  PLInvitableUserCell.swift
//  Pals
//
//  Created by ruckef on 25.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLInvitableUserCellDelegate {
    func invitableCellInviteClicked(cell: PLInvitableUserCell)
}

enum PLInvitableUserCellState: Int {
    case Invitable
    case Inviting
    case Invited
}

class PLInvitableUserCell: PLUserTableCell {
    
    var delegate: PLInvitableUserCellDelegate?
    var cellState: PLInvitableUserCellState = .Invitable {
        didSet {
            inviteButton.hidden = true
            spinner.hidden = true
            invitedCheckmark.hidden = true
            switch cellState {
            case .Invitable:
                inviteButton.hidden = false
            case .Inviting:
                spinner.hidden = false
                spinner.startAnimating()
            case .Invited:
                invitedCheckmark.hidden = false
            }
        }
    }
    
    override var user: PLUser? {
        didSet {
            if let u = user {
                let state = intiveStateFromUser(u)
                cellState = state
            } else {
                cellState = .Invitable
            }
        }
    }
    
    lazy var inviteButton: UIButton = {
        let ib = UIButton()
        ib.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "plus_violet")
        ib.setBackgroundImage(image, forState: .Normal)
        ib.addTarget(self, action: #selector(buttonClicked), forControlEvents: .TouchUpInside)
        return ib
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.color = .violetColor
        return s
    }()
    
    lazy var invitedCheckmark: UIImageView = {
        let ic = UIImageView()
        ic.translatesAutoresizingMaskIntoConstraints = false
        ic.contentMode = .ScaleAspectFit
        ic.image = UIImage(named: "check_icon")?.withColor(.violetColor)
        return ic
    }()
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(inviteButton)
        contentView.addSubview(spinner)
        contentView.addSubview(invitedCheckmark)
    }
    
    override func setupLayoutConstraints() {
        super.setupLayoutConstraints()
        for view in [inviteButton, spinner, invitedCheckmark] {
            let views = ["view" : view]
            let metrics = ["side" : 50, "offsetH" : 15]
            let strings = ["[view(side)]-(offsetH)-|",
                           "V:[view(side)]"]
            contentView.addConstraints(strings, views: views, metrics: metrics)
            NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0).active = true
        }
    }
    
    override class func identifier() -> String {
        return "PLInvitableUserCell"
    }
    
    override class func nibName() -> String {
        return "PLInvitableUserCell"
    }
    
    func buttonClicked() {
        delegate?.invitableCellInviteClicked(self)
    }
    
    func intiveStateFromUser(user: PLUser) -> PLInvitableUserCellState {
        if user.inviting {
            return .Inviting
        } else {
            if user.invited {
                return .Invited
            } else {
                return .Invitable
            }
        }
    }
}