//
//  PLProfileDrinkCollectionViewswift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

//import UIKit

import SwiftQRCode

class PLProfileDrinkCollectionViewCell: PLCollectionViewCell {

    @IBOutlet var headerView: UIView!
    @IBOutlet var cardTitleLabel: UILabel!
    @IBOutlet var cardCaptionLabel: UILabel!
    @IBOutlet var barPlaceLabel: UILabel!
    @IBOutlet var cardQRCodeLabel: UILabel!
    @IBOutlet var cardQRCodeImageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBOutlet var userView: UIView!
    @IBOutlet var userPicImageView: UIImageView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userMessageLabel: UILabel!
    
    private var currentUrl = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.whiteColor()
        userView.layer.cornerRadius = 10
        setRoundedCorners([.TopLeft,.TopRight], withRadius: 20)
        userPicImageView.layer.cornerRadius = userPicImageView.bounds.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.contentOffset = CGPointMake(0, 0)
        if cardQRCodeImageView.image != UIImage(named: "qr_placeholder")  {
            cardQRCodeImageView.image = UIImage(named: "qr_placeholder")
        }
        userPicImageView.image = nil
    }
    
    
    func setupWith(order: PLOrderCellData, withOrderType type: PLOrderType, forIndexPath indexPath: NSIndexPath) {
        
        //FIXME: надо закинуть в модель тип крепкости пойла для подсветки карточки
        if order.isVIP == true {
            headerView.backgroundColor = kPalsOrderCardVIPColor
        } else if (indexPath.row % 4 == 1) { //FIXME: myself order
            headerView.backgroundColor = kPalsOrderCardMyselfColor
        } else if (indexPath.row % 4 == 2) {
            headerView.backgroundColor = kPalsOrderCardDrinkStrongColor
        } else if (indexPath.row % 4 == 3) {
            headerView.backgroundColor = kPalsOrderCardDrinkLightColor
        } else if (indexPath.row % 4 == 0) {
            headerView.backgroundColor = kPalsOrderCardDrinkUndefinedColor
        }
        //FIXME:
        
        if type == .Covers {
            cardTitleLabel.text = (order.isVIP) ? "VIP" : order.place.name
            cardCaptionLabel.text = (order.isVIP) ? order.place.name : order.place.musicGengres
        } else {
            cardTitleLabel.text = order.place.name
            cardCaptionLabel.text = order.place.musicGengres
        }
        
        barPlaceLabel.text = order.place.address
        
        if let QR = cardQRCodeLabel.text where QR != order.QRcode {
            cardQRCodeLabel.text = order.QRcode
        }
        
        userNicknameLabel.text = order.user.name
        userMessageLabel.text = order.message
    }
    
    func setupImages(order: PLOrderCellData) {
        cardQRCodeImageView.image = QRCode.generateImage(order.QRcode, avatarImage: nil)
        setImage(order.user.picture)
    }
    
    private func setImage(url: NSURL) {
        userPicImageView.image = nil
        let urlString = url.absoluteString
        let request = NSURLRequest(URL: url)
        currentUrl = urlString
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if urlString != self.currentUrl {
                return
            }
            self.userPicImageView.setImageWithURLRequest(request, placeholderImage: nil, success: {[unowned self] (request, response, image) in
                if urlString != self.currentUrl {
                    return
                }
                dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                    self.userPicImageView.image = image
                    })
            }) { (request, response, error) in
               PLShowErrorAlert(error: error)
            }
        }
    }
    
}