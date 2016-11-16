//
//  PLOrderOffersView
//  Pals
//
//  Created by Maks Sergeychuk on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol PLOrderHeaderDelegate: class {
    func orderHeader(header: PLOrdeStickyHeader, didChangeSection section: PLOrderSection)
}

class PLOrdeStickyHeader: UICollectionViewCell {
    
    static let height: CGFloat = 70
    
    @IBOutlet private var coverButton: UIButton!
    @IBOutlet private var drinkButton: UIButton!
    
    @IBOutlet private var coverConstraint: NSLayoutConstraint!
    @IBOutlet private var drinkConstraint: NSLayoutConstraint!
    
    weak var delegate: PLOrderHeaderDelegate?
    
    var currentSection: PLOrderSection = .Drinks {
        didSet{
            updateButtonsState()
            updateListIndicator()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateButtonsState()
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
        if currentSection != .Covers {
            setupCollectionForSection(.Covers)
        }
    }
    
    @IBAction private func drinksButtonPressed(sender: UIButton?) {
        if currentSection != .Drinks {
            setupCollectionForSection(.Drinks)
        }
    }
    
    private func setupCollectionForSection(section: PLOrderSection) {
        currentSection = section
        updateButtonsState()
        updateListIndicator()
        delegate?.orderHeader(self, didChangeSection: section)
    }
    
    private func updateButtonsState() {
        coverButton.selected = currentSection != .Drinks
        drinkButton.selected = currentSection == .Drinks
    }
    
    private func updateListIndicator() {
        coverConstraint.priority = currentSection == .Covers ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow
        drinkConstraint.priority = currentSection == .Covers ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh
        
        UIView.animateWithDuration(0.2) {
            self.layoutIfNeeded()
        }
    }
}
