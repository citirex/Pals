//
//  PLProfileViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

let kProfileInfoChanged = "ProfileChanged"
private let kCellHeaderOffset: CGFloat = 54

class PLProfileViewController: TGLStackedViewController {

    private var collectionHelper = PLProfileCollectionHelper()
    private var datasourceSwitcher = PLProfileDatasourceSwitcher()
    private var currentDatasource: PLOrderDatasource { return datasourceSwitcher.currentDatasource }
    
    private var needsToShowNewOrder = false
    
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
            loadPageIfEmpty()
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
        profile = PLFacade.profile
        currentTab = .Drinks
        view.addSubview(spinner)
        setupCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.style = .ProfileStyle
        exposedItemIndexPath = nil
        if needsToShowNewOrder == true && currentDatasource.count > 0 {
            showNewOrder()
        }
    }
    
    func addNewOrder(order: PLOrder) {
        if order.covers.count == 0 && currentTab == .Covers {
            datasourceSwitcher.resetOffset(forType: .Drinks)
            myDrinksButtonPressed(nil)
        } else if order.drinkSets.count == 0 && currentTab == .Drinks{
            datasourceSwitcher.resetOffset(forType: .Covers)
            myCoversButtonPressed(nil)
        } else {
            datasourceSwitcher.resetOffset(forType: currentTab)
        }
        
        needsToShowNewOrder = true
        
        if currentDatasource.pagesLoaded == 0 || currentDatasource.loading == true {
            
        } else {
            currentDatasource[0] = order
            if view.window != nil { // Needs to test when you recive order when you on profile screen
                showNewOrder()
            }
        }
    }
    
    private func showNewOrder() {
        if needsToShowNewOrder == true {
            needsToShowNewOrder = false
            
            if currentDatasource.count > 1 {
                collectionView?.reloadData({
                    self.collectionView?.layoutIfNeeded()
                    if let cellToShow = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) {
                        var visibleCells = self.collectionView?.visibleCells()
                        var i = 0
                        var indexOfCellToDelete: Int?
                        for cell in visibleCells! {
                            if cell != cellToShow {
                                cell.transform = CGAffineTransformMakeTranslation(0, -kCellHeaderOffset)
                            } else {
                                indexOfCellToDelete = i
                            }
                            i += 1
                        }
                        if let index = indexOfCellToDelete {
                            visibleCells?.removeAtIndex(index)
                        }
                        cellToShow.transform = CGAffineTransformMakeTranslation(0, self.collectionView!.bounds.size.height)
                        
                        UIView.animateWithDuration(0.5, animations: {
                            for cell in visibleCells! {
                                cell.transform = CGAffineTransformIdentity
                            }
                            }, completion: { (complete) in
                                UIView.animateWithDuration(1,
                                    delay: 0.0,
                                    usingSpringWithDamping: 0.77,
                                    initialSpringVelocity: 0.0,
                                    options: UIViewAnimationOptions.CurveLinear,
                                    animations: {
                                        cellToShow.transform = CGAffineTransformIdentity
                                    },
                                    completion: nil)
                        })
                    } else {
                        self.collectionView?.reloadData()
                    }
                })
            } else {
                collectionView?.performBatchUpdates({
                    self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
                    }, completion: { (complete) in
                        
                })
            }
            tabBarController?.resetConterNumberOn(.Profile)
        }
    }
    
    func profileInfoChangedNotification(notification: NSNotification){
        if notification.name == kProfileInfoChanged {
            profile = PLFacade.profile
        }
    }

    func loadPageIfEmpty() {
        if currentDatasource.empty {
            loadPage()
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
    
    func myCoversButtonPressed(sender: AnyObject?) {
        if currentTab != .Covers {
            setupCollectionForState(.Covers)
        }
    }
    
    func myDrinksButtonPressed(sender: AnyObject?) {
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
            needsToShowNewOrder = false
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
            
            let urlRequest = NSURLRequest(URL: profile.picture, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 60)
            collectionBackgroundView.userPicImageView.setImageWithURLRequest(urlRequest,
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
