//
//  PLCheckbox.swift
//  Pals
//
//  Created by Vitaliy Delidov on 11/11/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

class PLCheckbox: UIView {
    
    typealias CheckboxStateChange = (checkbox: PLCheckbox) -> Void
    var stateChanged: CheckboxStateChange?
    
    private var label: UILabel!
    private var checkbox: UIView!
    private var checkmark: PLCheckmark!
    
    private var shouldSetupConstraints = true
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: .handleTap)
    }()
    
    var checked = false
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCheckbox()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckbox()
    }
    
    init(title: String) {
        super.init(frame: CGRectZero)
        setupCheckbox()
        setupLabel(title)
    }
    
    func setupCheckbox() {
        label = UILabel.newAutoLayoutView()
        
        checkbox = UIView.newAutoLayoutView()
        checkbox.layer.borderColor  = UIColor.darkGrayColor().CGColor
        checkbox.layer.cornerRadius = 7
        checkbox.layer.borderWidth  = 1
        
        checkmark = PLCheckmark.newAutoLayoutView()
        
        addSubview(label)
        addSubview(checkbox)
        checkbox.addSubview(checkmark)
        addGestureRecognizer(tapGesture)
        
        setNeedsUpdateConstraints()
    }
    
    func setupLabel(title: String) {
        label.font = .systemFontOfSize(14)
        label.textColor = .darkGrayColor()
        label.text = title
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        checked = !checked
        
        if checked {
            checkmark.show()
        } else {
            checkmark.hide()
        }
        stateChanged!(checkbox: self)
    }
    
    override func updateConstraints() {
        if shouldSetupConstraints {
            
            checkbox.autoSetDimensionsToSize(CGSizeMake(25, 25))
            checkbox.autoPinEdgeToSuperviewEdge(.Left, withInset: 15)
            checkbox.autoPinEdgeToSuperviewEdge(.Top)
            
            checkmark.autoPinEdgesToSuperviewEdges()
            
            label.autoPinEdge(.Left, toEdge: .Right, ofView: checkbox, withOffset: 8)
            label.autoAlignAxis(.Horizontal, toSameAxisOfView: checkbox)
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
}




// MARK: - Checkmark

class PLCheckmark: UIView {
    
    private var strokeColor = UIColor.darkGrayColor().CGColor
    private var duration: NSTimeInterval = 0.275
    private var checkmarkLayer: CAShapeLayer!
    private var strokeWidth: CGFloat = 1.0
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCheckmark()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckmark()
    }
    
    private func setupCheckmark() {
        backgroundColor = .clearColor()
        checkmarkLayer = CAShapeLayer()
        checkmarkLayer.fillColor = nil
    }
    
}


extension PLCheckmark {
    
    private var key: String {
        return "strokeEnd"
    }
    
    func show() {
        alpha = 1
        
        checkmarkLayer.removeAllAnimations()
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGRectGetWidth(bounds) * 0.28, CGRectGetHeight(bounds) * 0.5))
        path.addLineToPoint(CGPointMake(CGRectGetWidth(bounds) * 0.42, CGRectGetHeight(bounds) * 0.66))
        path.addLineToPoint(CGPointMake(CGRectGetWidth(bounds) * 0.72, CGRectGetHeight(bounds) * 0.36))
        path.lineCapStyle = .Square
        checkmarkLayer.path = path.CGPath
        
        checkmarkLayer.strokeColor = strokeColor
        checkmarkLayer.lineWidth   = strokeWidth
        layer.addSublayer(checkmarkLayer)
        
        let animation = CABasicAnimation(keyPath: key)
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeBoth
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        checkmarkLayer.addAnimation(animation, forKey: key)
    }
    
    func hide() {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0
        }) { completed in
            self.checkmarkLayer.removeFromSuperlayer()
        }
    }
    
}

