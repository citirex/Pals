//
//  PLOrderAnimableVipView.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

private let crownOffsetCentered: CGFloat = 59
private let crownOffset: CGFloat = 0

class PLOrderAnimableVipView: UIView {

    static let suggestedFrame = CGRectMake(0, 0, 144, 26)
    
    
    @IBOutlet private var labelVip: UILabel!
    @IBOutlet private var crownImageView: UIImageView!
    @IBOutlet private var labelOrderCentered: UILabel!
    
    @IBOutlet private var crownRightConstraint: NSLayoutConstraint!
    
    
    func animateVip() {
        
        weak var weakSelf = self
        UIView.animateWithDuration(0.3, animations: {
            weakSelf?.labelOrderCentered.transform = CGAffineTransformMakeScale(0.3, 0.3)
            weakSelf?.labelOrderCentered.alpha = 0.0
        }) { (completion) in
            weakSelf?.labelOrderCentered.transform = CGAffineTransformIdentity
            weakSelf?.labelOrderCentered.alpha = 0
            
            weakSelf?.crownImageView.transform = CGAffineTransformMakeScale(0, 0)
            weakSelf?.crownRightConstraint.constant = crownOffsetCentered
            
            weakSelf?.crownImageView.hidden = false
            weakSelf?.labelVip.alpha = 0
            weakSelf?.labelVip.hidden = false
            
            UIView.animateWithDuration(0.4,
                                       delay: 0,
                                       usingSpringWithDamping: 0.6,
                                       initialSpringVelocity: 0,
                                       options: UIViewAnimationOptions.CurveLinear,
                                       animations: {
                                        weakSelf?.crownImageView.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: { (completion) in
                    weakSelf?.crownRightConstraint.constant = crownOffset
                    UIView.animateWithDuration(0.4, animations: {
                        weakSelf?.layoutIfNeeded()
                        }, completion: { (completion) in
                            UIView.animateWithDuration(0.4, animations: {
                                weakSelf?.labelVip.alpha = 1
                                weakSelf?.labelOrderCentered.alpha = 1.0
                            })
                    })
            })
        }
    }
    
    func restoreToDefaultState() {
        labelVip.hidden = true
        crownImageView.hidden = true
    }

}
