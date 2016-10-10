//
//  PLNotificationCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/20/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLNotificationCell: UITableViewCell {
    
    static let identifier = "NotificationCell"
    
    typealias notificationStateDelegate = (sender: PLNotificationCell, enabled: Bool) -> Void
    var notificationState: notificationStateDelegate?

    @IBOutlet weak var notificationName: UILabel!
    

    @IBAction func switchValueChanged(sender: UISwitch) {
        notificationState!(sender: self, enabled: sender.on ? true : false)
    }

}
