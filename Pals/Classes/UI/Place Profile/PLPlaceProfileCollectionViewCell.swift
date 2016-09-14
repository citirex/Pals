//
//  PLPlaceProfileCollectionViewCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/7/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLPlaceProfileCollectionViewCell: UICollectionViewCell {
    
    static let nibName = "PLPlaceProfileCollectionViewCell"
    static let identifier = "EventCell"
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
