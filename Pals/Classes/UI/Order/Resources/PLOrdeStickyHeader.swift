//
//  PLOrderOffersView
//  Pals
//
//  Created by Maks Sergeychuk on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol OrderCurrentTabDelegate: class {
    func orderTabChanged(tab: CurrentTab)
}

class PLOrdeStickyHeader: UICollectionViewCell {
    
    @IBOutlet private var coverButton: UIButton!
    @IBOutlet private var drinkButton: UIButton!
    
    @IBOutlet private var coverConstraint: NSLayoutConstraint!
    @IBOutlet private var drinkConstraint: NSLayoutConstraint!
    
    weak var delegate: OrderCurrentTabDelegate?
    
    var currentTab: CurrentTab = .Drinks {
        didSet{
            if currentTab == .Drinks {
                drinksButtonPressed(nil)
            } else {
                coverButtonPressed(nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        func setupGestureForDirection(direction: UISwipeGestureRecognizerDirection) {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognized(_:)))
            swipe.direction = direction
            self.addGestureRecognizer(swipe)
        }
        setupGestureForDirection(.Left)
        setupGestureForDirection(.Right)
        //FIXME: Memory leak?
    }
    
    @objc private func swipeRecognized(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Left:
            coverButtonPressed(nil)
        case UISwipeGestureRecognizerDirection.Right:
            drinksButtonPressed(nil)
        default: break
        }
    }
    
    
    @IBAction private func coverButtonPressed(sender: UIButton?) {
        if currentTab != .Covers {
            setupCollectionForState(.Covers)
        }
    }
    
    @IBAction private func drinksButtonPressed(sender: UIButton?) {
        if currentTab != .Drinks {
            setupCollectionForState(.Drinks)
        }
    }
    
    private func setupCollectionForState(state: CurrentTab) {
        delegate?.orderTabChanged(state)
        currentTab = state
        updateButtonsState()
        updateListIndicator()
    }
    
    private func updateButtonsState() {
        coverButton.selected = (currentTab == .Drinks) ? true : false
        drinkButton.selected = (currentTab == .Drinks) ? false : true
    }
    
    private func updateListIndicator() {
        coverConstraint.priority = (currentTab == .Covers) ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow
        drinkConstraint.priority = (currentTab == .Covers) ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh
        
        UIView.animateWithDuration(0.2) {
            self.layoutIfNeeded()
        }
    }
}
