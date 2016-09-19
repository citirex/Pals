//
//  PLCollectionViewCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/19/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLCollectionViewCell: UICollectionViewCell {
    
    private var viewWidth: CGFloat = 0
    private var needsToRound = false
    private var roundedCorners: UIRectCorner = [.AllCorners]
    private var roundedCornersRadius: CGFloat = 0
    
    func setRoundedCorners(corners: UIRectCorner,withRadius radius: CGFloat) {
        needsToRound = true
        roundedCorners = corners
        roundedCornersRadius = radius
    }
    
    func resetRoundedCorners() {
        roundedCorners = [.AllCorners]
        roundedCornersRadius = 0
        setNeedsLayout()
        layoutIfNeeded()
        needsToRound = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if needsToRound == true && bounds.size.width != viewWidth {
            round(roundedCorners, radius: roundedCornersRadius)
            viewWidth = bounds.size.width
        }
    }
}
