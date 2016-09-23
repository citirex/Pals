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
    
    typealias didTappedOrderButtonDelegate = (sender: UIButton) -> Void
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
        
        orderButton.addTarget(self, action: #selector(orderButtonTapped(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func drawRect(rect: CGRect) {
        topOfView.round([.TopLeft, .TopRight], radius: 15)
        
        let startingPoint = CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMaxY(rect))
        let endingPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))
        
        let path = UIBezierPath()
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        path.lineWidth = 1
        UIColor.lightGrayColor().setStroke()
        path.stroke()
    }
    
    func orderButtonTapped(sender: UIButton) {
        didTappedOrderButton!(sender: sender)
    }
   
}
