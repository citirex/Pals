//
//  PLDescriptionLabel.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/27/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLDescriptionLabel: UILabel {


    
    override func drawRect(rect: CGRect) {
        addBorder(.Top, color: .darkGray(), width: 0.5)
        addBorder(.Bottom, color: .darkGray(), width: 0.5)
        
//        let startingPoint = CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMaxY(rect))
//        let endingPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect))
//        
//        let path = UIBezierPath()
//        path.lineWidth = 2
//        path.moveToPoint(startingPoint)
//        path.addLineToPoint(endingPoint)
//        UIColor.chatelleColor().setStroke()
//        path.stroke()
    }

}
