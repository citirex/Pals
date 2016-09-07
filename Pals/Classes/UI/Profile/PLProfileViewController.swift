//
//  PLProfileViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import RandomKit
import SDWebImage

enum CurrentList {
    case Covers
    case Drinks
}

class PLProfileViewController: TGLStackedViewController {

    let collectionHelper = PLProfileCollectionHelper()
    var collectionBackgroundView = UINib(nibName: "PLProfileHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLProfileHeaderView
    var currentList: CurrentList = .Drinks
    var firstLaunch: Bool = true
    var profile: PLUser? {
        didSet {
            setupUserInfo()
        }
    }
    
    let sampleDrinks = [String](count: 13, repeatedValue: "Value")
    let sampleCovers = [String](count: 1, repeatedValue: "Value")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        profile = PLFacade.profile
        collectionHelper.fishUser = profile
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if firstLaunch == true {
            collectionView?.alpha = 0
        }
        navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstLaunch == true {
            showCards()
            firstLaunch = false
        }
    }
    
    
    //MARK: - Actions
    func editProfileButtonPressed(sender: UIButton) {
        print("Edit button pressed")
    }
    
    func addFundsButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("addFunds", sender: nil)
        print("Add funds button pressed")
    }
    
    func myCoversButtonPressed(sender: AnyObject) {
        if currentList != .Covers {
            setupCollectionForState(.Covers)
        }
    }
    
    func myDrinksButtonPressed(sender: AnyObject) {
        if currentList != .Drinks {
            setupCollectionForState(.Drinks)
        }
    }
    
    func setupCollectionForState(state: CurrentList) {
        currentList = state
        updateListIndicator()
        collectionHelper.collection = (state == .Drinks) ? sampleDrinks : sampleCovers
        collectionView?.reloadData({
            self.collectionView?.layoutIfNeeded()
            self.showCards()
        })
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
    
    func showCards() {
        if let visibleCells = collectionView?.visibleCells() where visibleCells.count > 0 {
            collectionView?.alpha = 0
            
            let diff = 0.05
            let collectionHeight = collectionView!.bounds.size.height
            
            for cell in visibleCells {
                cell.transform = CGAffineTransformMakeTranslation(0, collectionHeight)
            }
            
            collectionView?.alpha = 1
            var counter = 0.0
            for cell in visibleCells {
                UIView.animateWithDuration(1,
                                           delay: diff*counter,
                                           usingSpringWithDamping: 0.77,
                                           initialSpringVelocity: 0,
                                           options: .CurveLinear,
                                           animations: {
                                            cell.transform = CGAffineTransformMakeTranslation(0, 0)
                    }, completion: nil)
                counter += 1
            }
        }
    }
    
    
    //MARK: - Setup
    func setupUserInfo() {
        if let profile = profile {
            title = profile.name
            collectionBackgroundView.balanceButton.setTitle(String(format: "$%.2f", profile.balance), forState: .Normal)
            collectionBackgroundView.balanceButton.addTarget(self, action: #selector(addFundsButtonPressed(_:)), forControlEvents: .TouchUpInside)
            collectionBackgroundView.myCoversButton.addTarget(self, action: #selector(myCoversButtonPressed(_:)), forControlEvents: .TouchUpInside)
            collectionBackgroundView.myDrinksButton.addTarget(self, action: #selector(myDrinksButtonPressed(_:)), forControlEvents: .TouchUpInside)
            collectionBackgroundView.userPicImageView.sd_setImageWithURL(profile.picture, placeholderImage: UIImage(named: "avatar_placeholder"),  completed: {[unowned self] (image, error, SDImageCacheType, url) in
                if error != nil {
                    print("Error when downloading profile image: \(error.debugDescription)")
                } else {
                    self.collectionBackgroundView.applyBlurEffect(image)
                }
            })
        }
    }
    
    func updateListIndicator() {
        collectionBackgroundView.myCoversConstraint.priority = (currentList == .Covers) ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow
        collectionBackgroundView.myDrinksConstraint.priority = (currentList == .Covers) ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh
        
        UIView.animateWithDuration(0.2) {
            self.collectionBackgroundView.layoutIfNeeded()
        }
    }
    
    func setupCollectionView() {
        setupCollectionBackgroundView(collectionBackgroundView)
        
        self.collectionView?.registerNib(UINib(nibName: "PLProfileDrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: drinkCellIdentifier)
        
        
        var expoItemSize = CGSizeMake(collectionView!.bounds.size.width, 420)
        if (UIDevice().type == .iPhone4 || UIDevice().type == .iPhone4S) {
            //|| UIDevice().type == .simulator) {
            expoItemSize.height = 340
        }
        self.exposedItemSize = expoItemSize
        self.stackedLayout!.itemSize = self.exposedItemSize;
        self.stackedLayout!.layoutMargin = UIEdgeInsetsMake(282.0, 0.0, self.tabBarController!.tabBar.frame.height, 0.0);
        
        collectionHelper.collection = sampleDrinks
        self.collectionView?.dataSource = collectionHelper
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognized(_:)))
        swipeLeft.direction = .Left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognized(_:)))
        swipeRight.direction = .Right
        
        collectionBackgroundView.addGestureRecognizer(swipeLeft)
        collectionBackgroundView.addGestureRecognizer(swipeRight)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addFunds" {
            print("funds")
        }
    }
    

}

extension UICollectionView {
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: { self.reloadData() })
        { _ in completion() }
    }
}
