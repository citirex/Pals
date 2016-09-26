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

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustFontToIPhoneSize()
    }
    
    private func adjustFontToIPhoneSize() {
        let deviceType = UIDevice.currentDevice().type
        
        switch deviceType {
        case .iPhone4S, .iPhone5, .iPhone5C, .iPhone5S:
            notificationName!.font = .systemFontOfSize(17.0)
        case .iPhone6, .iPhone6S:
            notificationName!.font = .systemFontOfSize(20.0)
        case .iPhone6plus:
            notificationName!.font = .systemFontOfSize(21.0)
        default:
            break
        }
    }

}
