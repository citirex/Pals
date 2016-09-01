//
//  PLProfileViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import RandomKit

enum CurrentList {
    case covers
    case drinks
}

class PLProfileViewController: TGLStackedViewController {

    let collectionHelper = PLProfileCollectionHelper()
    let collectionBackgroundView = UINib(nibName: "PLProfileHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLProfileHeaderView
    var currentList: CurrentList = .drinks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.registerNib(UINib(nibName: "PLProfileDrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: drinkCellIdentifier)
        
        self.exposedItemSize = CGSizeMake(collectionView!.bounds.size.width, 420)
        self.stackedLayout!.itemSize = self.exposedItemSize;
        self.stackedLayout!.layoutMargin = UIEdgeInsetsMake(282.0, 0.0, self.tabBarController!.tabBar.frame.height, 0.0);
        
        
        self.collectionView?.dataSource = collectionHelper
        
        setupCollectionBackgroundView()
        setupUserInfo()
        
        // custom layout
        
        self.stackedLayout!.topReveal = 60;

        self.exposedPinningMode = TGLExposedLayoutPinningMode.Below
        self.exposedTopPinningCount = 10;
        self.exposedBottomPinningCount = 10;
        self.exposedItemsAreCollapsible = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView!.backgroundColor = UIColor.clearColor() //need for collection background view
    }
    
    
    
    //MARK: - Actions
    func editProfileButtonPressed(sender: UIButton) {
        print("Edit button pressed")
    }
    
    func addFundsButtonPressed(sender: UIButton) {
        print("Add funds button pressed")
    }
    
    func myCoversButtonPressed(sender: AnyObject) {
        if currentList != .covers {
            currentList = .covers
            updateListIndicator()
        }
        print("My covers button pressed")
    }
    
    func myDrinksButtonPressed(sender: AnyObject) {
        if currentList != .drinks {
            currentList = .drinks
            updateListIndicator()
        }
        print("MY drinks button pressed")
    }
    
    func swipeRecognized(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Left:
            myCoversButtonPressed(sender)
        case UISwipeGestureRecognizerDirection.Right:
            myDrinksButtonPressed(sender)
        default: break
        }
    }
    
    
    //MARK: - Setup
    func setupUserInfo() {
        collectionBackgroundView.userNameLabel.text = "Phantom assasin"
        collectionBackgroundView.editProfileButton.addTarget(self, action: #selector(editProfileButtonPressed(_:)), forControlEvents: .TouchUpInside)
        collectionBackgroundView.balanceButton.setTitle("$0.0", forState: .Normal)
        collectionBackgroundView.balanceButton.addTarget(self, action: #selector(addFundsButtonPressed(_:)), forControlEvents: .TouchUpInside)
        collectionBackgroundView.myCoversButton.addTarget(self, action: #selector(myCoversButtonPressed(_:)), forControlEvents: .TouchUpInside)
        collectionBackgroundView.myDrinksButton.addTarget(self, action: #selector(myDrinksButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        collectionBackgroundView.userPicImageView.image = UIImage(named: "fish_avatar")
        collectionBackgroundView.applyBlurEffect(UIImage(named: "fish_avatar")!)
    }
    
    func updateListIndicator() {
        collectionBackgroundView.myCoversConstraint.priority = (currentList == .covers) ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow
        collectionBackgroundView.myDrinksConstraint.priority = (currentList == .covers) ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh
        
        UIView.animateWithDuration(0.2) {
            self.collectionBackgroundView.layoutIfNeeded()
        }
    }
    
    func setupCollectionBackgroundView() {
        collectionBackgroundView.frame = self.collectionView!.bounds
        self.view.insertSubview(collectionBackgroundView, belowSubview: self.collectionView!)
        let backgroundProxy = TGLBackgroundProxyView()
        backgroundProxy.targetView = collectionBackgroundView
        self.collectionView?.backgroundView = backgroundProxy
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognized(_:)))
        swipeLeft.direction = .Left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognized(_:)))
        swipeRight.direction = .Right
        
        collectionBackgroundView.addGestureRecognizer(swipeLeft)
        collectionBackgroundView.addGestureRecognizer(swipeRight)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
