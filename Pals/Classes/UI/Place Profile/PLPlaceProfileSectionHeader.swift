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
    
    static let nibName = "PLPlaceProfileSectionHeader"
    static let identifier = "SectionHeader"
    
    typealias didTappedOrderButtonDelegate = Void -> Void
    var didTappedOrderButton: didTappedOrderButtonDelegate?

    @IBOutlet weak var topOfView: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var musicGenresLabel: UILabel!
    @IBOutlet weak var closingTimeLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topOfView.round([.TopLeft, .TopRight], radius: 15)
        orderButton.addTarget(self, action: #selector(orderButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    func orderButtonTapped() {
        didTappedOrderButton!()
    }
   
}
