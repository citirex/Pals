//
//  PLProfileViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import AFNetworking

class PLProfileViewController: TGLStackedViewController {

    var orderDatasource = PLOrderDatasource()
    var collectionHelper = PLProfileCollectionHelper()
    
    lazy var spinner: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    }()
    
    var collectionBackgroundView = UINib(nibName: "PLProfileHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLProfileHeaderView
    private var currentTab: CurrentTab = .Drinks
    var firstLaunch: Bool = true
    var profile: PLUser? {
        didSet {
            if let user = profile {
                orderDatasource.userId = user.id
            }
            setupUserInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(spinner)
        setupCollectionView()
        
        profile = PLFacade.profile
        loadPage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentTransparentNavigationBar()
    }
    
//    override func viewDidAppear(animated: Bool) {
//        tabBarController?.tabBar.items?[TabBarController.TabProfile.int].badgeValue = nil
//    }
    
    func loadPage() {
        spinner.startAnimating()
        spinner.center = view.center
        orderDatasource.load {[unowned self] page, error in
            if error == nil {
                let count = self.orderDatasource.count
                let lastLoadedCount = page.count
                if lastLoadedCount > 0 {
                    var indexPaths = [NSIndexPath]()
                    for i in count-lastLoadedCount..<count {
                        indexPaths.append(NSIndexPath(forItem: i, inSection: 0))
                    }
                    
                    if self.firstLaunch == true {
                        self.collectionView?.alpha = 0
                        self.collectionView?.reloadData({
                            self.collectionView?.layoutIfNeeded()
                            self.showCards()
                        })
                        self.firstLaunch = false
                    } else {
                        UIView.animateWithDuration(1,
                            delay: 0.0,
                            usingSpringWithDamping: 0.77,
                            initialSpringVelocity: 0.0,
                            options: UIViewAnimationOptions(),
                            animations: {
                                self.collectionView?.performBatchUpdates({
                                    self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                                    }, completion: nil)
                            },
                            completion: nil)
                    }
                }
                self.spinner.stopAnimating()
            } else {
                PLShowErrorAlert(error: error!)
            }
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
        if currentTab != .Covers {
            setupCollectionForState(.Covers)
        }
    }
    
    func myDrinksButtonPressed(sender: AnyObject) {
        if currentTab != .Drinks {
            setupCollectionForState(.Drinks)
        }
    }
    
    func setupCollectionForState(state: CurrentTab) {
        currentTab = state
        updateListIndicator()
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
            
            
            collectionBackgroundView.userPicImageView.setImageWithURLRequest(NSURLRequest(URL: profile.picture),
                                                                             placeholderImage: UIImage(named: "avatar_placeholder"),
                                                                             success: { (retuqest, response, image) in
                                                                                self.collectionBackgroundView.userPicImageView.image = image
                                                                                self.collectionBackgroundView.applyBlurEffect(image)
                }, failure: { (request, response, error) in
                    print("Error when downloading profile image: \(error.debugDescription)")
            })
        }
    }
    
    func updateListIndicator() {
        collectionBackgroundView.myCoversConstraint.priority = (currentTab == .Covers) ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow
        collectionBackgroundView.myDrinksConstraint.priority = (currentTab == .Covers) ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh
        
        UIView.animateWithDuration(0.2) {
            self.collectionBackgroundView.layoutIfNeeded()
        }
    }
    
    func setupCollectionView() {
        setupCollectionBackgroundView(collectionBackgroundView)
        
        self.collectionView?.registerNib(UINib(nibName: "PLProfileDrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: drinkCellIdentifier)
        
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.height
        let exposedCardHeight = collectionView!.bounds.size.height - tabBarHeight - 60
        
        let expoItemSize = CGSizeMake(collectionView!.bounds.size.width, exposedCardHeight)
        self.exposedItemSize = expoItemSize
        self.stackedLayout!.itemSize = self.exposedItemSize;
        self.stackedLayout!.layoutMargin = UIEdgeInsetsMake(282.0, 0.0, self.tabBarController!.tabBar.frame.height, 0.0);
        
        collectionHelper.datasource = orderDatasource
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
        if let identifier = segue.identifier {
            switch identifier {
            case "addFunds":
                print("funds")
            case "ShowSettings":
                let settingsViewController = segue.destinationViewController as! PLSettingsViewController
                settingsViewController.user = profile
            default:
                break
            }
        }
    }
}

extension PLProfileViewController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == orderDatasource.count-1 {
            loadPage()
        }
    }
}

extension UICollectionView {
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: { self.reloadData() })
        { _ in completion() }
    }
}
