//
//  PLPlaceProfileCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLPlaceProfileCell: UICollectionViewCell {
    
    static let nibName    = "PLPlaceProfileCell"
    static let identifier = "EventCell"
    
    @IBOutlet private var eventImageView: PLCircularImageView!
    @IBOutlet private var eventDateLabel:             UILabel!
    @IBOutlet private var eventDescriptionLabel:      UILabel!
    
    private let offset: CGFloat = 70
    
    
    func setupWithEventInfo(event: PLEventCellData, andDateFormatter dateFormatter: NSDateFormatter) {
        eventImageView.setImageWithURL(event.picture, placeholderImage: UIImage(named: "no_image_placeholder"))
        eventDateLabel.text        =  dateFormatter.stringFromDate(event.date)
        eventDescriptionLabel.text = event.info
    }
    
    override func drawRect(rect: CGRect) {
        let startingPoint = CGPoint(x: CGRectGetMinX(rect) + offset, y: CGRectGetMaxY(rect))
        let endingPoint   = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))
   
        let path = UIBezierPath()
        path.lineWidth = 1
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        UIColor.lightGrayColor().setStroke()
        path.stroke()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        round([.TopLeft, .TopRight], radius: 15)
    }
    
}
