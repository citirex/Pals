//
//  PLEmptyBackgroundView.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/11/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import PureLayout


// TODO: - needs to delete this class! :)
class PLEmptyBackgroundView: UIView {
    
    private var topLabel: UILabel!
    private var bottomLabel: UILabel?
    
    private let topTextColor    = UIColor.grayColor()
    private let topTextFont     = UIFont.boldSystemFontOfSize(22)
    private let bottomTextColor = UIColor.lightGrayColor()
    private let bottomTextFont  = UIFont.systemFontOfSize(18)
    
    var textLabelsSpacing: CGFloat {
        set{
            textLabelsSpacingConstraint?.constant = newValue
            layoutIfNeeded()
        }
        get{
           return textLabelsSpacingConstraint?.constant ?? 10
        }
    }
    
    private var textLabelsSpacingConstraint: NSLayoutConstraint?
    
    var didSetupConstraints = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init(topText: String, bottomText: String?) {
        super.init(frame: CGRectZero)
        setupViews()
        setupTextLabels(topText, bottomText: bottomText)
    }

    private func setupViews() {
        topLabel = UILabel.newAutoLayoutView()
        topLabel.textColor = topTextColor
        topLabel.font      = topTextFont
        addSubview(topLabel!)
    }
    
    func applyShadowWithColor(color: UIColor, andRadius radius: CGFloat) {
        topLabel.shadowColor = color
        topLabel.shadowOffset = CGSizeZero
        topLabel.layer.shadowRadius = radius
        
        bottomLabel?.shadowColor = color
        bottomLabel?.shadowOffset = CGSizeZero
        bottomLabel?.layer.shadowRadius = radius
    }

    
    func setupTextLabels(topText: String, bottomText: String?) {
        topLabel.text = topText
        
        if let bottom = bottomText {
            guard bottomLabel != nil else {
                bottomLabel = UILabel.newAutoLayoutView()
                addSubview(bottomLabel!)
                bottomLabel?.textColor     = bottomTextColor
                bottomLabel?.font          = bottomTextFont
                bottomLabel?.numberOfLines = 0
                bottomLabel?.textAlignment = .Center
                return
            }
            bottomLabel?.text = bottom
        }
    }
    
    
    func setTopTextColor(color: UIColor) {
        topLabel.textColor = color
    }
    
    func setTopTextFont(font: UIFont) {
        topLabel.font = font
    }
    
    func setBottomTextColor(color: UIColor) {
        bottomLabel?.textColor = color
    }
    
    func setBottomTextFont(font: UIFont) {
        bottomLabel?.font = font
    }
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            topLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            topLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: self, withOffset: -20)
            
            bottomLabel?.autoAlignAxisToSuperviewAxis(.Vertical)
           textLabelsSpacingConstraint = bottomLabel?.autoPinEdge(.Top, toEdge: .Bottom, ofView: topLabel, withOffset: textLabelsSpacing)

            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}

