//
//  PLSettingCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/20/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSettingCell: UITableViewCell {
    
    static let nibName = "PLSettingCell"
    static let identifier = "SettingCell"
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustFontToIPhoneSize()
    }
    
    private func adjustFontToIPhoneSize() {
        let deviceType = UIDevice.currentDevice().type
        
        switch deviceType {
        case .iPhone4S, .iPhone5, .iPhone5C, .iPhone5S:
            textLabel!.font = .systemFontOfSize(17.0)
        case .iPhone6, .iPhone6S:
            textLabel!.font = .systemFontOfSize(20.0)
        case .iPhone6plus:
            textLabel!.font = .systemFontOfSize(21.0)
        default:
            break
        }
    }

    
}
