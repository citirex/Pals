//
//  PLHistorySectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/19/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLHistorySectionHeader: UITableViewCell {
    
    static let nibName = "PLHistorySectionHeader"
    static let reuseIdentifier = "SectionHeader"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var drink: PLDrink! {
        didSet {
            setup()
        }
    }
    
    
    
    override func drawRect(rect: CGRect) {
        let startingPoint = CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMinY(rect))
        let endingPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMinY(rect))
        
        let path = UIBezierPath()
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        path.lineWidth = 1
        UIColor.lightGrayColor().setStroke()
        path.stroke()
    }
    
    
    func setup() {
        dateLabel.text = "Last Week"
        placeNameLabel.text = "The Marky Bark Pub"
    }
}
