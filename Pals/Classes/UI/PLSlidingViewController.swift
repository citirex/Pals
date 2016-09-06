//
//  PLSlidingViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSlidingViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var backgroundView: UIView? = nil {
        didSet{
            if let backgroundView = backgroundView { setupBackgroundView(backgroundView) }
        }
    }
    
    var slidingView: UIView? = nil {
        didSet{
            if let slidingView = slidingView { setupSlidingView(slidingView) }
        }
    }
    
    var panGesture: UIPanGestureRecognizer? = nil
    var topOffsetMin: CGFloat = 60
    var topOffsetMax: CGFloat = 260
    var slidingConstraint: NSLayoutConstraint? = nil
    
    
    //MARK: - Actions
    func panGestureRecognized(panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translationInView(view)
        panGesture.setTranslation(CGPointZero, inView: view)
        //        print(translation)
        
        switch panGesture.state {
        case .Began:
            view.layer.removeAllAnimations()
        case .Ended:
            let velocity = panGesture.velocityInView(self.view)
            let finalPointConst = (velocity.y > 0) ? topOffsetMax : topOffsetMin
            let duration = max(Double(topOffsetMax / fabs(velocity.y)), 0.4)
            //            print(duration)
            slidingConstraint?.constant = finalPointConst
            UIView.animateWithDuration(duration,
                                       delay: 0,
                                       usingSpringWithDamping: 0.77,
                                       initialSpringVelocity: 0,
                                       options: [.CurveLinear, .AllowUserInteraction],
                                       animations: {
                                        self.view.layoutIfNeeded()
                }, completion: nil)
        case .Changed:
            var slidingConst = slidingConstraint!.constant
            if slidingConst >= topOffsetMin && slidingConst <= topOffsetMax {
                slidingConst += translation.y
                if slidingConst > topOffsetMax { slidingConst = topOffsetMax }
                if slidingConst < topOffsetMin { slidingConst = topOffsetMin }
                
                slidingConstraint?.constant = slidingConst
            }
    
            
        default: break
            
        }
    }
    
    
    //MARK: - Setup
    func setupGestures() {
        if let slidingView = slidingView {
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
            panGesture?.maximumNumberOfTouches = 1
            slidingView.addGestureRecognizer(panGesture!)
        }
    }
    
    private func setupBackgroundView(bgView: UIView) {
        bgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView!)
        setupConstraintsFor(backgroundView!, withHeight: nil)
    }
    
    private func setupSlidingView(slideView: UIView) {
        slideView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(slidingView!)
        
        setupConstraintsFor(slidingView!, withHeight: -topOffsetMin)
        slidingConstraint = NSLayoutConstraint(item: slidingView!,
                                            attribute: .Top,
                                            relatedBy: .Equal,
                                            toItem: view,
                                            attribute: .Top,
                                            multiplier: 1,
                                            constant: topOffsetMax)
        
        view.addConstraint(slidingConstraint!)
        setupGestures()
    }
    
    func setupConstraintsFor(targetView: UIView, withHeight height: CGFloat?) {
        view.addConstraint(NSLayoutConstraint(item: targetView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Height,
            multiplier: 1,
            constant: height ?? 0))
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[targetView]|",
            options: NSLayoutFormatOptions.AlignAllLeft,
            metrics: nil,
            views: ["targetView":targetView]))
        
        if height == nil {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[targetView]|",
                options: NSLayoutFormatOptions.AlignAllLeft,
                metrics: nil,
                views: ["targetView":targetView]))
        }
    }

}
