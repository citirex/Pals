//
//  PLOrderCoverCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/15/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

private let kDimmed: CGFloat = 0.3
private let kTransparent: CGFloat = 0

class PLOrderCoverCell: UICollectionViewCell, PLCounterViewDelegate {
    
    static let height: CGFloat = 200.0
    
    @IBOutlet private var bgView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dimmedView: UIView!
    @IBOutlet private var counter: PLCounterView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        counter.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dimmedView.alpha = 0
    }
    
    func setDimmed(dimmed: Bool,animated: Bool) {
        if animated == true {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { 
                self.dimmedView.alpha = (dimmed == true) ? kDimmed : kTransparent
                }, completion: nil)
           
        } else {
            dimmedView.hidden = (dimmed == true) ? false : true
            dimmedView.alpha = (dimmed == true) ? kDimmed : kTransparent
        }
    }
    
    var coverTitle: String?{
        set{
            titleLabel.text = newValue
        }
        get{
           return titleLabel.text
        }
    }
    
    func counterView(view: PLCounterView, didChangeCounter counter: Int) {
        PLLog("Count: \(counter)")
    }
    
}
