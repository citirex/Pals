//
//  PLPlaceProfileCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLPlaceProfileCell: UICollectionViewCell {

    static let nibName = "PLPlaceProfileCell"
    static let identifier = "EventCell"
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    private let offset: CGFloat = 80
    
   
    override func drawRect(rect: CGRect) {
        let startingPoint = CGPoint(x: CGRectGetMinX(rect) + offset, y: CGRectGetMaxY(rect))
        let endingPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))
        
        let path = UIBezierPath()
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        path.lineWidth = 2
        UIColor.lightGrayColor().setStroke()
        path.stroke()
    }

}
