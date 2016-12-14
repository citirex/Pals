//
//  PLInviteCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 12/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol PLInviteCellDelegate: class {
    func clickedInviteCell(cell: PLInviteCell)
}

enum PLInviteState: Int {
    case Invitable
    case Inviting
    case Invited
}

class PLInviteCell: UITableViewCell {
    
    static let nibName = "PLInviteCell"
    static let reuseIdentifier = "InviteCell"
    
    @IBOutlet weak var userImageView: PLCircularImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var inviteButton: PLAddButton!
    @IBOutlet weak var checkmarkButton: PLCheckmarkButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    weak var delegate: PLInviteCellDelegate?
    
    var cellState: PLInviteState = .Invitable {
        didSet {
            inviteButton.hidden = true
            spinner.hidden = true
            checkmarkButton.hidden = true
            
            switch cellState {
            case .Invitable:
                inviteButton.hidden = false
            case .Inviting:
                spinner.hidden = false
                spinner.startAnimating()
            case .Invited:
                checkmarkButton.hidden = false
            }
        }
    }
    
    var user: PLUser? {
        didSet {
            usernameLabel.text = user?.name ?? "<Error>"
            let placeholderImage = UIImage(named: "user_placeholder")
            userImageView.setImageWithURL(user!.picture, placeholderImage: placeholderImage)
            
            guard let user = user else { return cellState = .Invitable }
            let state = stateFromUser(user)
            cellState = state
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func inviteTapped(sender: UIButton) {
        delegate?.clickedInviteCell(self)
    }
    
    
    // MARK: - Private methods
    
    private func stateFromUser(user: PLUser) -> PLInviteState {
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


