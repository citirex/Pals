//
//  PLPlaceProfileSectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLPlaceProfileSectionHeader: UICollectionReusableView {
    
    static let nibName    = "PLPlaceProfileSectionHeader"
    static let identifier = "SectionHeader"
    
    typealias PLTapOrderButtonDelegate = (sender: UIButton) -> Void
    var didTapOrderButton: PLTapOrderButtonDelegate?

    @IBOutlet weak var placeNameLabel     : UILabel!
    @IBOutlet weak var musicGenresLabel   : UILabel!
    @IBOutlet weak var closingTimeLabel   : UILabel!
    @IBOutlet weak var placeAddressLabel  : UILabel!
    @IBOutlet weak var phoneNumberLabel   : UILabel!
    @IBOutlet weak var orderButton: PLRoundedButton! {
        didSet {
            orderButton.addTarget(self, action: .orderButtonTapped, forControlEvents: .TouchUpInside)
        }
    }

    var place: PLPlace! {
        didSet {
            placeNameLabel.text    = place.name
            musicGenresLabel.text  = place.musicGengres
            closingTimeLabel.text  = place.closeTime
            placeAddressLabel.text = place.address
            phoneNumberLabel.text  = place.phone
        }
    }


    func orderButtonTapped(sender: UIButton) {
        didTapOrderButton!(sender: sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        round([.TopLeft, .TopRight], radius: 15)
        addBorder([.Bottom], color: .lightGrayColor(), width: 0.5)
    }
   
}
