//
//  PLNotificationCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/20/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLNotificationCell: UITableViewCell {
    
    static let nibName = "PLNotificationCell"
    static let identifier = "NotificationCell"
    
    @IBOutlet weak var notificationName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        notificationName!.font = .customFontOfSize(17)
    }

}
