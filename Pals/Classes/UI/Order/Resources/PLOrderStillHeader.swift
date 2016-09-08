//
//  PLOrderBackgroundView.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol OrderHeaderBehaviourDelegate: class {
    func vipButtonPressed()
}

class PLOrderStillHeader: UICollectionViewCell {

    @IBOutlet private var labelVip: UILabel!
    @IBOutlet private var crownImageView: UIImageView!
    @IBOutlet private var labelOrder: UILabel!
    @IBOutlet private var labelOrderCentered: UILabel!
    @IBOutlet private var vipButton: UIButton!
    
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var placeTextField: UITextField!
    @IBOutlet private var messageTextView: UITextView!
    
    weak var delegate: OrderHeaderBehaviourDelegate?
    
    @IBAction private func vipButtonPressed(sender: UIButton) {
        delegate?.vipButtonPressed()
        animateVip()
    }
    
    private func animateVip() {
        
        vipButton.hidden = true
        
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
                                            }) { (completion) in
                                                NSTimer.scheduledTimerWithTimeInterval(3, target: weakSelf!, selector: #selector(PLOrderStillHeader.restoreToDefaultState), userInfo: nil, repeats: false)
                                            }
                })
                
        }
    }
    
    func restoreToDefaultState() {
        labelVip.hidden = true
        labelOrder.hidden = true
        crownImageView.hidden = true
        
        vipButton.hidden = false
        labelOrderCentered.hidden = false
    }

}
