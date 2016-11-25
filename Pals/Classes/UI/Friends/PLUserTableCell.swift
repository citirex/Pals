//
//  PLUserTableCell.swift
//  Pals
//
//  Created by ruckef on 25.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLUserTableCell: UITableViewCell, Initializable, Constrainable {
    
    lazy var userImageView: PLProfileImageView = {
        let iv = PLProfileImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .ScaleAspectFit
        return iv
    }()
    
    lazy var usernameLabel: UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        ul.textColor = .violetColor
        return ul
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        selectionStyle = .None
    }
    
    func addSubviews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(usernameLabel)
    }
    
    func setupLayoutConstraints() {
        let views = ["picture" : userImageView, "label" : usernameLabel]
        let metrics = ["gap" : 10, "top" : 15]
        let strings = ["H:|-(gap)-[picture]-(gap)-[label]-(gap)-|",
                       "V:|-(top)-[picture]-(top)-|",
                       "V:|-(top)-[label]-(top)-|"]
        contentView.addConstraints(strings, views: views, metrics: metrics)
        NSLayoutConstraint(item: userImageView, attribute: .Width, relatedBy: .Equal, toItem: userImageView, attribute: .Height, multiplier: 1, constant: 0).active = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.onPrepareForReuseInCell()
    }
    
    var user: PLUser? {
        didSet {
            userImageView.user = user
            usernameLabel.text = user?.name ?? "<Error>"
        }
    }
}

extension PLUserTableCell : PLReusableCell {
    class func identifier() -> String {
        return "PLUserTableCell"
    }
    class func nibName() -> String {
        return "PLUserTableCell"
    }
}