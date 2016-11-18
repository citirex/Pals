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

    func update(username: String, message: String?, userPicture: NSURL?) {
        
    }
    
    static var nibName: String {
        return "PLOrderItemFooterView"
    }
    
}
