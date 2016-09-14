//
//  PLSettingsCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/12/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSettingsCell: UICollectionViewCell {
    
    static let nibName = "PLSettingsCell"
    static let identifier = "SettingsCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

}
