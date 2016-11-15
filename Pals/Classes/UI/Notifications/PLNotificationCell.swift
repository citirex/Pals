//
//  PLNotificationCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/20/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate: class {
    func didChangeValueForCell(cell: PLNotificationCell, sender: UISwitch)
}

class PLNotificationCell: UITableViewCell {
    
    static let identifier = "NotificationCell"

    @IBOutlet weak var notificationName: UILabel!
    
    weak var delegate: NotificationCellDelegate?
    
    

    @IBAction func switchValueChanged(sender: UISwitch) {
        delegate?.didChangeValueForCell(self, sender: sender)
    }

}
