//
//  PLOrderHistorySectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLOrderHistorySectionHeader: UITableViewCell {

    static let nibName = "PLOrderHistorySectionHeader"
    static let reuseIdentifier = "SectionHeader"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var orderCellData: PLOrderCellData! {
        didSet { setup() }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabel.font = UIFont.customFontOfSize(17, weight: UIFontWeightMedium)
        placeNameLabel.font = .customFontOfSize(17)
    }
    
    override func drawRect(rect: CGRect) {
        let startingPoint = CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMinY(rect))
        let endingPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMinY(rect))
        
        let path = UIBezierPath()
        path.lineWidth = 1
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        UIColor.lightGrayColor().setStroke()
        path.stroke()
    }
    
    private func setup() {
        guard let orderCellData = orderCellData else { return }
//        dateLabel.text = orderCellData.date
        placeNameLabel.text = orderCellData.place.name
    }
    
}
