//
//  PLProfileCollectionHelper
//  Pals
//
//  Created by Maks Sergeychuk on 9/1/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import SwiftQRCode

let drinkCellIdentifier = "DrinkCell"

class PLProfileCollectionHelper: NSObject, UICollectionViewDataSource {
    
    weak var datasource: PLOrderDatasource?
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(drinkCellIdentifier, forIndexPath: indexPath) as! PLProfileDrinkCollectionViewCell
        if let orderCellData = datasource?[indexPath.row].cellData {
            cell.setupWith(orderCellData, withOrderType: datasource!.orderType, forIndexPath: indexPath)
        }
        
        return cell
    }
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    
}
