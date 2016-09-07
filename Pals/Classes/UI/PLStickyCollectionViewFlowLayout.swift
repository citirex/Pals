//
//  PLStickyCollectionViewFlowLayout.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/7/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLStickyCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let contentOffset = collectionView!.contentOffset.y
        var attributes = super.layoutAttributesForElementsInRect(rect)!
        
        var mainHeaderAttributes: UICollectionViewLayoutAttributes!
        var stickyHeaderAttributes: UICollectionViewLayoutAttributes!
        
        for attribute in attributes {
            if attribute.representedElementKind == UICollectionElementKindSectionHeader {
                if attribute.indexPath.section == 0 {
                    mainHeaderAttributes = attribute
                } else {
                    stickyHeaderAttributes = attribute
                }
            } else {
                attribute.zIndex = 1
            }
        }
        
        var mainHeaderHeight: CGFloat = 0.0
        if mainHeaderAttributes != nil {
            var mainHeaderFrame = mainHeaderAttributes.frame
            mainHeaderFrame.origin.y = contentOffset / 3.0
            mainHeaderAttributes.frame = mainHeaderFrame
            mainHeaderAttributes.zIndex = 0
            if mainHeaderHeight != mainHeaderFrame.size.height {
                mainHeaderHeight = mainHeaderFrame.size.height
            }
        }
        
        if stickyHeaderAttributes == nil {
            stickyHeaderAttributes = super.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: 1))
            attributes.append(stickyHeaderAttributes)
        }
        
        var stickyHeaderFrame = stickyHeaderAttributes.frame
        
        if contentOffset >= mainHeaderHeight {
            stickyHeaderFrame.origin.y = contentOffset
            stickyHeaderAttributes.frame = stickyHeaderFrame
        }
        
        stickyHeaderAttributes.zIndex = 1024
        return attributes
    }
    
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

}
