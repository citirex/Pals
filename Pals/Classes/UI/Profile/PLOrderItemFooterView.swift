//
//  PLOrderItemFooterView.swift
//  Pals
//
//  Created by ruckef on 17.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLOrderItemFooterView: UIView, PLNibNamable {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userMessageLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    func update(username: String, message: String?, userPicture: NSURL?) {
        usernameLabel.text = username
        userMessageLabel.text = message
        userImageView.setImageSafely(fromURL: userPicture, placeholderImage: UIImage(named: "user"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userMessageLabel.preferredMaxLayoutWidth = userMessageLabel.frame.width
    }
    
    static var nibName: String {
        return "PLOrderItemFooterView"
    }
    
}
