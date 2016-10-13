//
//  PLPlaceProfileSectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLPlaceProfileSectionHeader: UICollectionReusableView {
    
    static let nibName = "PLPlaceProfileSectionHeader"
    static let identifier = "SectionHeader"
    
    typealias didTappedOrderButtonDelegate = (sender: UIButton) -> Void
    var didTappedOrderButton: didTappedOrderButtonDelegate?

    @IBOutlet weak var topOfView: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var musicGenresLabel: UILabel!
    @IBOutlet weak var closingTimeLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton! {
        didSet {
            orderButton.addTarget(self, action: .orderButtonTapped, forControlEvents: .TouchUpInside)
        }
    }



    func orderButtonTapped(sender: UIButton) {
        didTappedOrderButton!(sender: sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        orderButton.rounded = true
        orderButton.layer.borderWidth = 1.0
        orderButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        round([.TopLeft, .TopRight], radius: 15)
        
        addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
    }
   
}
