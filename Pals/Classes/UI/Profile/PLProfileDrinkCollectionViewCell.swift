//
//  PLProfileDrinkCollectionViewCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

//import UIKit

class PLProfileDrinkCollectionViewCell: UICollectionViewCell {

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
        
        contentView.backgroundColor = UIColor.whiteColor()
        round([.TopLeft, .TopRight], radius: 20)
        userView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.contentOffset = CGPointMake(0, 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPicImageView.layer.cornerRadius = userPicImageView.bounds.width / 2
    }
}