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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel!.font = .customFontOfSize(17)
    }
    
}
