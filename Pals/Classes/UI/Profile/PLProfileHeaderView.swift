//
//  PLProfileHeaderView.swift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLProfileHeaderView: UIView {
    
    @IBOutlet var userPicImageView: UIImageView!
    @IBOutlet var balanceButton: UIButton!
    @IBOutlet var myCoversButton: UIButton!
    @IBOutlet var myDrinksButton: UIButton!
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var myCoversConstraint: NSLayoutConstraint!
    @IBOutlet var myDrinksConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPicImageView.layer.cornerRadius = 50
    }
    
    
    func applyBlurEffect(image: UIImage){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for fullscreen blur effect
        blurEffectView.frame = backgroundImageView.bounds
        backgroundImageView.image = userPicImageView.image
        backgroundImageView.addSubview(blurEffectView)
        
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.6, 1.6)
        UIView.animateWithDuration(1) { 
            self.backgroundImageView.transform = CGAffineTransformIdentity

        }

    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}