//
//  PLPlaceProfileSectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

@IBDesignable
class PLPlaceProfileSectionHeader: UICollectionReusableView {

    @IBOutlet weak var topOfView: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var musicGenresLabel: UILabel!
    @IBOutlet weak var closingTimeLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topOfView.round([.TopLeft, .TopRight], radius: 12)
    }
   
}
