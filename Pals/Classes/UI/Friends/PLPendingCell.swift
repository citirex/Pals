//
//  PLPendingCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 12/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol PLPendingCellDelegate: class {
    func pendingCell(cell: PLPendingCell, success: Bool)
}

enum PLPendingState: Int {
    case Pending
    case Answering
    case Answered
}

class PLPendingCell: UITableViewCell {
    
    static let nibName = "PLPendingCell"
    static let reuseIdentifier = "PendingCell"
    
    @IBOutlet weak var userImageView: PLCircularImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var acceptButton: PLCheckmarkButton!
    @IBOutlet weak var declineButton: PLCancelButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    weak var delegate: PLPendingCellDelegate?
    
    var pendingState: PLPendingState = .Pending {
        didSet {
            updateUI()
        }
    }
    
    
    func updateUI() {
        acceptButton.hidden  = true
        declineButton.hidden = true
        answerLabel.hidden   = true
        spinner.hidden       = true
        
        switch pendingState {
        case .Pending:
            acceptButton.hidden  = false
            declineButton.hidden = false
        case .Answering:
            spinner.hidden = false
            spinner.startAnimating()
        case .Answered:
            answerLabel.hidden = false
        }
    }
    
    var user: PLUser? {
        didSet {
            usernameLabel.text = user?.name ?? "<Error>"
            let placeholderImage = UIImage(named: "user_placeholder")
            userImageView.setImageWithURL(user!.picture, placeholderImage: placeholderImage)
            
            if let user = user {
                pendingState = pendingStateFromUser(user)
                if user.answered {
                    answerLabel.text = user.answer ? "Accepted" : "Declined"
                }
            } else {
                pendingState = .Pending
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonClicked(button: UIButton) {
        delegate?.pendingCell(self, success: button == acceptButton)
    }
    
    
    // MARK: - Private methods
    
    private func pendingStateFromUser(user: PLUser) -> PLPendingState {
        if user.answering {
            return .Answering
        } else {
            if user.answered {
                return .Answered
            } else {
                return .Pending
            }
        }
    }
    
    
}

