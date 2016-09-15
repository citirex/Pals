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
        if let order = datasource?[indexPath.row].cellData {
            
            if order.isVIP == true {
                cell.headerView.backgroundColor = kPalsOrderCardVIPColor
            } else if (indexPath.row % 4 == 1) { //FIXME: myself order
                cell.headerView.backgroundColor = kPalsOrderCardMyselfColor
            } else if (indexPath.row % 4 == 2) {
                cell.headerView.backgroundColor = kPalsOrderCardDrinkStrongColor
            } else if (indexPath.row % 4 == 3) {
                cell.headerView.backgroundColor = kPalsOrderCardDrinkLightColor
            } else if (indexPath.row % 4 == 0) {
                cell.headerView.backgroundColor = kPalsOrderCardDrinkUndefinedColor
            }
            
            cell.cardTitleLabel.text = order.place.name
            cell.cardCaptionLabel.text = order.place.musicGengres
            cell.barPlaceLabel.text = order.place.address
            cell.cardQRCodeLabel.text = order.QRcode
            cell.cardQRCodeImageView.image = QRCode.generateImage(order.QRcode, avatarImage: nil)
            
            cell.userPicImageView.setImageWithURL(order.user.picture)
            cell.userNicknameLabel.text = order.user.name
            cell.userMessageLabel.text = order.message
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
