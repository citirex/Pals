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
    var fishUser: PLUser? = nil
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(drinkCellIdentifier, forIndexPath: indexPath) as! PLProfileDrinkCollectionViewCell
        // assign to a cell
        let order = datasource?[indexPath.row].cellData
        
        
        cell.contentView.backgroundColor = UIColor.whiteColor()
        cell.headerView.backgroundColor = generateRandomColor()
        cell.barTitleLabel.text = "Bar #\(indexPath.row) "
        cell.drinkQRCodeImageView.image = QRCode.generateImage("AAAA777", avatarImage: nil)
        
        if let user = fishUser {
            cell.userPicImageView.setImageWithURL(user.picture)
            cell.userNicknameLabel.text = user.name
//            cell.userMessageLabel.text = use
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
