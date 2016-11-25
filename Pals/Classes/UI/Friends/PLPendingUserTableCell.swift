//
//  PLPendingUserTableCell.swift
//  Pals
//
//  Created by ruckef on 25.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLPendingUserCellState: Int {
    case Pending
    case Answering
    case Answered
}

protocol PLPendingUserTableCellDelegate: class {
    func pendingUserCell(cell: PLPendingUserTableCell, didClickAnswer answer: Bool)
}

class PLPendingUserTableCell: PLUserTableCell {
    
    weak var delegate: PLPendingUserTableCellDelegate?
    
    var cellState: PLPendingUserCellState = .Pending {
        didSet {
            acceptButton.hidden = true
            declineButton.hidden = true
            spinner.hidden = true
            answerLabel.hidden = true
            switch cellState {
            case .Pending:
                acceptButton.hidden = false
                declineButton.hidden = false
            case .Answering:
                spinner.hidden = false
                spinner.startAnimating()
            case .Answered:
                answerLabel.hidden = false
            }
        }
    }
    
    override var user: PLUser? {
        didSet {
            if let u = user {
                let state = pendingStateFromUser(u)
                cellState = state
                if u.answered {
                    answerLabel.text = u.answer ? "Accepted" : "Declined"
                }
            } else {
                cellState = .Pending
            }
        }
    }
    
    lazy var acceptButton: PLCheckmarkButton = {
        let ab = PLCheckmarkButton()
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
        return ab
    }()
    
    lazy var declineButton: PLCancelButton = {
        let cb = PLCancelButton()
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
        return cb
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.color = .violetColor
        return s
    }()
    
    lazy var answerLabel: UILabel = {
        let al = UILabel()
        al.translatesAutoresizingMaskIntoConstraints = false
        al.font = UIFont(name: "HelveticaNeue-Italian", size: 13)
        al.textColor = .violetColor
        al.textAlignment = .Right
        return al
    }()
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(acceptButton)
        contentView.addSubview(declineButton)
        contentView.addSubview(spinner)
        contentView.addSubview(answerLabel)
    }
    
    override func setupLayoutConstraints() {
        super.setupLayoutConstraints()
        
        var views: [String: UIView] = ["accept" : acceptButton, "decline" : declineButton]
        var metrics = ["side" : 50, "offsetV" : 5, "offsetH" : 15]
        var strings = ["[accept(side)]-(offsetH)-|",
                       "[decline(side)]-(offsetH)-|",
                       "V:|-(offsetV)-[accept(side)]",
                       "V:[decline(side)]-(offsetV)-|"]
        contentView.addConstraints(strings, views: views, metrics: metrics)
        
        views = ["answer" : answerLabel]
        metrics = ["offset" : 15]
        strings = ["|-(offset)-[answer]-(offset)-|",
                       "V:[answer(20)]-(offset)-|"]
        contentView.addConstraints(strings, views: views, metrics: metrics)
        
        views = ["spinner" : spinner]
        metrics = ["side" : 50, "offsetH" : 15]
        strings = ["[spinner(side)]-(offsetH)-|",
                       "V:[spinner(side)]"]
        contentView.addConstraints(strings, views: views, metrics: metrics)
        NSLayoutConstraint(item: spinner, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0).active = true
    }
    
    override class func identifier() -> String {
        return "PLPendingUserTableCell"
    }
    
    override class func nibName() -> String {
        return "PLPendingUserTableCell"
    }
    
    func buttonClicked(button: UIButton) {
        var answer = false
        if button == acceptButton {
            answer = true
        }
        delegate?.pendingUserCell(self, didClickAnswer: answer)
    }
    
    func pendingStateFromUser(user: PLUser) -> PLPendingUserCellState {
        if user.answering {
            return .Answering
        } else {
            if user.answered{
                return .Answered
            } else {
                return .Pending
            }
        }
    }
}