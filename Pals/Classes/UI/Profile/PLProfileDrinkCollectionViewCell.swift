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
    @IBOutlet var barTitleLabel: UILabel!
    @IBOutlet var barCaptionLabel: UILabel!
    @IBOutlet var barPlaceLabel: UILabel!
    @IBOutlet var drinkQRCodeLabel: UILabel!
    @IBOutlet var drinkQRCodeImageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBOutlet var userView: UIView!
    @IBOutlet var userPicImageView: UIImageView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 20
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