//
//  PLCollectionParalaxLayout.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/13/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLCollectionParalaxLayout: TGLStackedLayout {
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        
        guard let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath) where attributes.alpha == 0 else {
            return nil
        }
        
        // modify attributes for insertion here
        

        let height = collectionView?.frame.height
//        attributes.transform = CGAffineTransformMakeScale(0, 0);
        attributes.transform = CGAffineTransformMakeTranslation(0, height ?? 300)
        
        
        return attributes
        
    }
    


}
