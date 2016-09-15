//
//  PLSettingsTableViewCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSettingsTableViewCell: UITableViewCell {
    
    typealias didChangedNotificationsDelegate = (state: Bool) -> Void
    var didChangedNotificationsSwitch: didChangedNotificationsDelegate?
    
    static let nibName = "PLSettingsTableViewCell"
    static let identifier = "SettingsCell"

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @IBAction func stateSwitchChanged(sender: UISwitch) {
        let state = sender.on ? true : false
        didChangedNotificationsSwitch!(state: state)
    }
    
    
//    if switchBtn.on{
//    stateLabelObj.text = "Switch btn is on now"
//    }else{
//    stateLabelObj.text = "Switch btn is off now"
//    }
//    }
    
    //    @IBAction func changeSwitchButtonTapped(sender: UIButton) {
//}
}
