//
//  PLProfileDrinkCollectionViewswift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

//import UIKit

import SwiftQRCode

class PLProfileDrinkCollectionViewCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userView.layer.cornerRadius = 10
        userPicImageView.layer.cornerRadius = userPicImageView.bounds.width / 2
        
        setupCellCornersAndShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowPath = UIBezierPath(rect: bounds).CGPath
        
        var myBounds = bounds
        myBounds.size.width = UIScreen.mainScreen().bounds.size.width
        let path = UIBezierPath(roundedRect: myBounds, byRoundingCorners: [.TopLeft,.TopRight], cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        containerView.layer.mask = mask  
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
        switch type {
        case .Covers:
            cardTitleLabel.text = (order.isVIP) ? "VIP" : order.place.name
            cardCaptionLabel.text = (order.isVIP) ? order.place.name : order.place.musicGengres
            headerView.backgroundColor = .affairColor()
        case .Drinks:
            if let drinkType = order.drinkSets?.first?.drink.type where drinkType != .Undefined {
                headerView.backgroundColor = (drinkType == .Light) ? kPalsOrderCardBeerDrinkColor : kPalsOrderCardLiqiorDrinkColor
            } else {
                headerView.backgroundColor = kPalsOrderCardDrinkUndefinedColor
            }
             fallthrough
        case .All:
            cardTitleLabel.text = order.place.name
            cardCaptionLabel.text = order.place.musicGengres
        }
        
        if order.isVIP == true {
            headerView.backgroundColor = kPalsOrderCardVIPColor
        } else if (order.user.id == PLFacade.profile!.id) {
            headerView.backgroundColor = kPalsOrderCardMyselfColor
        }
        
        barPlaceLabel.text = order.place.address
        
        if let QR = cardQRCodeLabel.text where QR != order.place.QRcode {
            cardQRCodeLabel.text = order.place.QRcode
        }
        
        userNicknameLabel.text = order.user.name
        userMessageLabel.text = order.message
    }
    
    func setupImages(order: PLOrderCellData) {
        cardQRCodeImageView.image = QRCode.generateImage(order.place.QRcode, avatarImage: nil)
        setImage(order.user.picture)
    }
    
    private func setImage(url: NSURL) {
        userPicImageView.setImageSafely(fromURL: url, placeholderImage: UIImage(named: "user")!)
    }
    
    func setupCellCornersAndShadow() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        contentView.layer.shadowOpacity = 0.9
        contentView.layer.shadowRadius = 7
    }
}