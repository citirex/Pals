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
    
    typealias notificationStateDelegate = (sender: UISwitch) -> Void
    var didChangeNotification: notificationStateDelegate?

    @IBOutlet weak var notificationName: UILabel!
    

    @IBAction func switchValueChanged(sender: UISwitch) {
        didChangeNotification!(sender: sender)
    }

}
