//
//  PLOrderAnimableVipView.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLOrderAnimableVipView: UIView {

    static let suggestedFrame = CGRectMake(0, 0, 180, 26)
    
    @IBOutlet private var labelVip: UILabel!
    @IBOutlet private var crownImageView: UIImageView!
    @IBOutlet private var labelOrder: UILabel!
    @IBOutlet private var labelOrderCentered: UILabel!
    
    func animateVip() {
        
        weak var weakSelf = self
        UIView.animateWithDuration(0.3, animations: {
            weakSelf?.labelOrderCentered.transform = CGAffineTransformMakeScale(0.3, 0.3)
            weakSelf?.labelOrderCentered.alpha = 0.0
        }) { (completion) in
            weakSelf?.labelOrderCentered.hidden = true
            weakSelf?.labelOrderCentered.transform = CGAffineTransformIdentity
            weakSelf?.labelOrderCentered.alpha = 1
            
            weakSelf?.crownImageView.transform = CGAffineTransformMakeScale(0, 0)
            weakSelf?.crownImageView.hidden = false
            weakSelf?.labelVip.hidden = false
            weakSelf?.labelOrder.hidden = false
            weakSelf?.labelVip.alpha = 0
            weakSelf?.labelOrder.alpha = 0
            
            UIView.animateWithDuration(0.4,
                                       delay: 0,
                                       usingSpringWithDamping: 0.6,
                                       initialSpringVelocity: 0,
                                       options: UIViewAnimationOptions.CurveLinear,
                                       animations: {
                                        weakSelf?.crownImageView.transform = CGAffineTransformIdentity
                },
                                       completion: { (completion) in
                                        UIView.animateWithDuration(0.4, animations: {
                                            weakSelf?.labelVip.alpha = 1
                                            weakSelf?.labelOrder.alpha = 1
                                        })
            })
            
        }
    }
    
    func restoreToDefaultState() {
        labelVip.hidden = true
        labelOrder.hidden = true
        crownImageView.hidden = true
        
        labelOrderCentered.hidden = false
    }

}
