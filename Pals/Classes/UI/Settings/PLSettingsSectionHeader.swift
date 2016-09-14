//
//  PLSettingsSectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/12/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSettingsSectionHeader: UICollectionReusableView {
    
    static let nibName = "PLSettingsSectionHeader"
    static let identifier = "SectionHeader"
    
    @IBOutlet weak var headerLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
}
