//
//  PLProfileViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

let kProfileInfoChanged = "ProfileChanged"

class PLProfileViewController: TGLStackedViewController {

    private var collectionHelper = PLProfileCollectionHelper()
    private var datasourceSwitcher = PLProfileDatasourceSwitcher()
    private var currentDatasource: PLOrderDatasource { return datasourceSwitcher.currentDatasource }
    
    lazy var spinner: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    }()
    
    var collectionBackgroundView = UINib(nibName: "PLProfileHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLProfileHeaderView
    
    private var currentTab = PLCollectionSectionType.Drinks {
        willSet {
            datasourceSwitcher.saveOffset(collectionView!.contentOffset, forType: currentTab)
        }
        didSet {
            datasourceSwitcher.switchDatasource(currentTab)
            collectionHelper.datasource = currentDatasource
            collectionView?.reloadData()
            collectionView?.contentOffset = datasourceSwitcher.currentOffset
            if currentDatasource.empty {
                loadPage()
            }
        }
    }
    
    var profile: PLUser? {
        didSet {
            if let user = profile {
                datasourceSwitcher.updateUserId(user.id)
            }
            setupUserInfo()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(profileInfoChangedNotification(_:)), name:kProfileInfoChanged, object: nil)

        currentTab = .Drinks
        view.addSubview(spinner)
        setupCollectionView()
        
        profile = PLFacade.profile
        loadPage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .ProfileStyle
    }
    
    func profileInfoChangedNotification(notification: NSNotification){
        if notification.name == kProfileInfoChanged {
            profile = PLFacade.profile
        }
    }

    
    func loadPage() {
        spinner.startAnimating()
        spinner.center = view.center
        currentDatasource.loadPage {[unowned self] (indices, error) in
            if error == nil {
                if indices.count > 0 {
                    self.collectionBackgroundView.noItemsLabel.hidden = true
                    if self.currentDatasource.pagesLoaded == 1 {
                        self.collectionView?.alpha = 0
                        self.collectionView?.reloadData({
                            self.collectionView?.layoutIfNeeded()
                            self.showCards()
                        })
                    } else {
                        UIView.animateWithDuration(1,
                            delay: 0.0,
                            usingSpringWithDamping: 0.77,
                            initialSpringVelocity: 0.0,
                            options: UIViewAnimationOptions(),
                            animations: {
                                self.collectionView?.performBatchUpdates({
                                    self.collectionView?.insertItemsAtIndexPaths(indices)
                                    }, completion: nil)
                            },
                            completion: nil)
                    }
                } else {
                    self.collectionBackgroundView.noItemsLabel.hidden = false
                }
            } else {
                PLShowErrorAlert(error: error!)
            }
            self.spinner.stopAnimating()
        }
    }
    
    //MARK: - Actions
    func addFundsButtonPressed(sender: UIButton) {
        performSegueWithIdentifier(SegueIdentifier.AddFundsSegue, sender: sender)
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
    
    func setupCollectionForState(state: PLCollectionSectionType) {
        currentDatasource.cancel()
        currentTab = state
        updateListIndicator()
    }
    
    func updateListIndicator() {
        collectionBackgroundView.myCoversConstraint.priority = (currentTab == .Covers) ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow
        collectionBackgroundView.myDrinksConstraint.priority = (currentTab == .Covers) ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh
        UIView.animateWithDuration(0.2) {
            self.collectionBackgroundView.layoutIfNeeded()
        }
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
                                                                                self.collectionBackgroundView.backgroundImageView.image = image
                }, failure: { (request, response, error) in
                    print("Error when downloading profile image: \(error.debugDescription)")
            })
        }
    }
    
    func setupCollectionView() {
        setupCollectionBackgroundView(collectionBackgroundView)
        collectionBackgroundView.roundUserPicCorners()
        let collectionSize = collectionView!.bounds.size
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(collectionSize.height / 2, 0, 0, 0)
        
        self.collectionView?.registerNib(UINib(nibName: "PLProfileDrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: drinkCellIdentifier)
        
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.height
        let exposedCardHeight = collectionSize.height - tabBarHeight - 60
        
        let expoItemSize = CGSizeMake(collectionSize.width, exposedCardHeight)
        self.exposedItemSize = expoItemSize
        self.stackedLayout!.itemSize = self.exposedItemSize;
        
        let layoutTopMargin = collectionView!.frame.size.height / 2 + 1
        self.stackedLayout!.layoutMargin = UIEdgeInsetsMake(layoutTopMargin, 0.0, tabBarHeight, 0.0);
        
        collectionHelper.datasource = currentDatasource
        self.collectionView?.dataSource = collectionHelper
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognized(_:)))
        swipeLeft.direction = .Left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognized(_:)))
        swipeRight.direction = .Right
        
        collectionBackgroundView.addGestureRecognizer(swipeLeft)
        collectionBackgroundView.addGestureRecognizer(swipeRight)
    }
    
}

extension PLProfileViewController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == currentDatasource.count-1 {
            loadPage()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.exposedItemIndexPath != nil && indexPath.item == self.exposedItemIndexPath?.item {
            self.exposedItemIndexPath = nil
            
            
//            let items = collectionView.indexPathsForVisibleItems()
//            collectionView.reloadItemsAtIndexPaths(items)
            
            
        } else {
            self.exposedItemIndexPath = indexPath
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PLProfileDrinkCollectionViewCell
            cell.setupImages(currentDatasource[indexPath.row].cellData)
        }
    }
}

extension UICollectionView {
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: { self.reloadData() })
        { _ in completion() }
    }
}
