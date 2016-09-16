//
//  PLOrderViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

private let kStillHeaderIdentifier = "stillHeader"
private let kStickyHeaderIdentifier = "stickyHeader"
private let kDrinkCellIdentifier = "drinkCell"
private let kCoverCellIdentifier = "coverCell"

private let kCheckoutButtonHeight: CGFloat = 64

class PLOrderViewController: PLViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var bgImageView: UIImageView!
    
    var order: PLCheckoutOrder? = nil
    var user: PLUser? = nil
    var place: PLPlace? = nil {
        didSet{
            if let aPlace = place {
                drinksDatasource.placeId = aPlace.id
                orderDrinks.removeAll()
                loadPage()
            }
        }
    }
    var isVip = false {
        didSet{
            updateState()
        }
    }
    var orderDrinks = [String: String]() {
        didSet{
            orderDrinks.count > 0 ? showCheckoutButton() : hideCheckoutButton()
        }
    }
    
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private var firstLaunch: Bool = true
    private var drinksDatasource = PLDrinksDatasource()
    
    var currentTab: CurrentTab = .Drinks
    private let animableVipView = UINib(nibName: "PLOrderAnimableVipView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLOrderAnimableVipView
    private var vipButton: UIBarButtonItem? = nil
    private var checkoutButton = UIButton(frame: CGRectZero)
    
    private let placeholderUserName = "Chose user"
    private let placeholderPlaceName = "Chose place"
    
    //Sample var
    private var covers = [PLCover]()
    
    private var orderCovers = [UInt64]()
    
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCheckoutButton()
        setupCollectionView()
        
        // sample fish data
        var i = 0
        while (i < 3) {
            
            let cover = PLCover(jsonDic: ["id" : i])
            cover?.name = (i % 2 == 1) ? "$8.00" : "Single person%"
            cover?.price = Float(arc4random() % 100)

            i += 1
            covers.append(cover!)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if navigationItem.titleView != animableVipView {
            navigationItem.titleView = animableVipView
        }
        navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = (isVip == true) ? kPalsGoldColor : kPalsPurpleColor
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if navigationItem.titleView != animableVipView {
            navigationItem.titleView = animableVipView
        }
    }
    
    
    //MARK: - Network
    private func loadPage() {
        spinner.startAnimating()
        spinner.center = view.center
        drinksDatasource.load {[unowned self] page, error in
            if error == nil {
                let count = self.drinksDatasource.count
                let lastLoadedCount = page.count
                if lastLoadedCount > 0 {
                    var indexPaths = [NSIndexPath]()
                    for i in count-lastLoadedCount..<count {
                        indexPaths.append(NSIndexPath(forItem: i, inSection: 1))
                    }
                    
                    if self.firstLaunch == true {
                        self.collectionView?.reloadData()
                        self.firstLaunch = false
                    } else {
                        self.collectionView?.performBatchUpdates({
                            self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                            }, completion: nil)
                    }
                }
            } else {
                PLShowErrorAlert(error: error!)
            }
            self.spinner.stopAnimating()
        }
    }
    
    
    //MARK: - Actions
    @objc private func vipButtonPressed(sender: UIBarButtonItem) {
//        navigationItem.rightBarButtonItem = nil
        isVip = !isVip
        (isVip == true) ? animableVipView.animateVip() : animableVipView.restoreToDefaultState()
    
        
        
        
//        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(restore), userInfo: nil, repeats: false)
    }
    
    func restore() {
        isVip = false
        navigationItem.rightBarButtonItem = vipButton
        animableVipView.restoreToDefaultState()
    }
    
    func updateState() {
        UIView.animateWithDuration(0.3) {
            self.bgImageView.image = (self.isVip == true) ? UIImage(named: "order_bg_vip") : UIImage(named: "order_bg")
            self.navigationController?.navigationBar.barTintColor = (self.isVip == true) ? kPalsGoldColor : kPalsPurpleColor
            
        }
    }
}

//MARK: - Checkout behavior
extension PLOrderViewController {
    private func showCheckoutButton() {
        if checkoutButton.hidden != false {
            let originYFinish = view.bounds.size.height - kCheckoutButtonHeight
            var frame = checkoutButton.frame
            
            frame.origin.y = view.bounds.size.height
            checkoutButton.frame = frame
            checkoutButton.hidden = false
            frame.origin.y = originYFinish
            
            UIView.animateWithDuration(0.3,
                                       delay: 0,
                                       options: .BeginFromCurrentState,
                                       animations: {
                                        self.checkoutButton.frame = frame
                }, completion: nil)
        }
    }
    
    private func hideCheckoutButton() {
        if checkoutButton.hidden != true {
            var frame = checkoutButton.frame
            frame.origin.y = view.bounds.size.height
            
            UIView.animateWithDuration(0.3,
                                       delay: 0,
                                       options: .BeginFromCurrentState,
                                       animations: {
                                        self.checkoutButton.frame = frame
                }, completion: { (completion) in
                    self.checkoutButton.hidden = true
            })
        }
    }
    
    @objc private func checkoutButtonPressed(sender: UIButton) {
        guard let selectedUser = user else {
            checkoutButton.shake()
            PLShowAlert(title: "Need to chose user")
            return
        }
        guard let selectedPlace = place else {
            checkoutButton.shake()
            PLShowAlert(title: "Need to chose place")
            return
        }
        
        
        let qrCode = String.randomAlphaNumericString(8)
        let accessCode = String.randomAlphaNumericString(8)
        
        
        
        //FIXME: need to show checkout popup
        order = PLCheckoutOrder(qrCode: qrCode,
                                accessCode: accessCode,
                                user: selectedUser,
                                place: selectedPlace,
                                drinks: orderDrinks,
                                isVip: isVip,
                                message: nil)
        
        print(order?.serialize())
        
        order = nil
        orderDrinks.removeAll()
        collectionView.reloadSections(NSIndexSet(index: 1))
        
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(TabBarController.TabProfile.int) as! UITabBarItem
        
        if let badgeValue = tabItem.badgeValue, nextValue = Int(badgeValue)?.successor() {
            tabItem.badgeValue = String(nextValue)
        } else {
            tabItem.badgeValue = "1"
        }
    }
}

//MARK: - Order items delegate, Tab changed delegate
extension PLOrderViewController: OrderDrinksCounterDelegate, OrderCurrentTabDelegate, OrderHeaderBehaviourDelegate,OrderPlacesDelegate, OrderFriendsDelegate, UITextViewDelegate {
    
    //MARK: Order drinks count
    func updateOrderWith(drink: UInt64, andCount count: UInt64) {
        if count == 0 {
            orderDrinks.removeValueForKey(String(drink))
        } else {
            orderDrinks.updateValue(String(count), forKey: String(drink))
        }
    }
    
    //sample fish
    func updateOrderWithCover(cover: PLCover) {
        if let index = orderCovers.indexOf(cover.id) {
            orderCovers.removeAtIndex(index)
        } else {
            orderCovers.append(cover.id)
        }
    }
    
    
    //MARK: Cnange user
    func userNamePressed(sender: AnyObject) {
        if let viewController = UIStoryboard.viewControllerWithType(.OrderFriendsViewController) as? PLOrderFriendsViewController {
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func didSelectFriend(selectedFriend: PLUser) {
        user = selectedFriend
        collectionView.reloadSections(NSIndexSet(index: 0))
    }
    
    //MARK: Cnange place
    func placeNamePressed(sender: AnyObject) {
        if let viewController = UIStoryboard.viewControllerWithType(.OrderLocationsViewController) as? PLOrderPlacesViewController {
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func didSelectNewPlace(selectedPlace: PLPlace) {
        place = selectedPlace
        collectionView.reloadSections(NSIndexSet(index: 0))
    }
    
    //MARK: Order change tab
    func orderTabChanged(tab: CurrentTab) {
        currentTab = tab
        UIView.animateWithDuration(0, delay: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: {
            }) { (complete) in
                self.collectionView.reloadSections(NSIndexSet(index: 1))
        }
    }
    
    //MARK: - Setup
    func setupCollectionView() {
        view.insertSubview(spinner, aboveSubview: collectionView)
        animableVipView.frame = PLOrderAnimableVipView.suggestedFrame
        vipButton = UIBarButtonItem(title: "VIP", style: .Plain, target: self, action: #selector(vipButtonPressed(_:)))
        vipButton?.setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 20.0)!,
            NSForegroundColorAttributeName: UIColor.orangeColor()],
                                          forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem = vipButton
        
        collectionView.registerNib(UINib(nibName: "PLOrderStillHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kStillHeaderIdentifier)
        collectionView.registerNib(UINib(nibName: "PLOrdeStickyHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kStickyHeaderIdentifier)
        collectionView.registerNib(UINib(nibName: "PLOrderDrinkCell", bundle: nil), forCellWithReuseIdentifier: kDrinkCellIdentifier)
        collectionView.registerNib(UINib(nibName: "PLOrderCoverCell", bundle: nil), forCellWithReuseIdentifier: kCoverCellIdentifier)
    }
    
    func setupCheckoutButton() {
        checkoutButton.frame = CGRectMake(0,0,collectionView.bounds.size.width,kCheckoutButtonHeight)
        checkoutButton.setTitle("Send", forState: .Normal)
        checkoutButton.backgroundColor = UIColor(red:0.25, green:0.57, blue:0.42, alpha:1.0)
        checkoutButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        checkoutButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        checkoutButton.round([.TopLeft, .TopRight], radius: 10)
        checkoutButton.hidden = true
        self.view.addSubview(checkoutButton)
        checkoutButton.addTarget(self, action: #selector(checkoutButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }

}

//MARK: - CollectionView dataSource
extension PLOrderViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 1 {
            switch currentTab {
            case CurrentTab.Drinks:
                return drinksDatasource.count ?? 0
            case CurrentTab.Covers:
                return covers.count
            }
        }
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = (currentTab == .Drinks) ? kDrinkCellIdentifier : kCoverCellIdentifier
        let dequeuedCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
        switch currentTab {
        case CurrentTab.Drinks:
            let cell = dequeuedCell as! PLOrderDrinkCell
            let drink = drinksDatasource[indexPath.row].cellData
            
            cell.delegate = self
            cell.setupWith(drink)
            if let count = orderDrinks[String(drink.drinkId)] {
                cell.drinkCount = UInt64(count)!
            }
            return cell
        case CurrentTab.Covers:
            let cell = dequeuedCell as! PLOrderCoverCell
            let cover = covers[indexPath.row]
            cell.titleLabel.text = cover.name
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStillHeaderIdentifier, forIndexPath: indexPath) as! PLOrderStillHeader
            header.delegate = self
            header.userName = user?.name ?? placeholderUserName
            header.placeName = place?.name ?? placeholderPlaceName
            return header
        } else {
            
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStickyHeaderIdentifier, forIndexPath: indexPath) as! PLOrdeStickyHeader
            header.delegate = self
            header.currentTab = currentTab
            
            return header
        }
        
    }
    
    //MARK: Collection delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch currentTab {
        case CurrentTab.Drinks:
            break
        case CurrentTab.Covers:
            let item = covers[indexPath.row]
            
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = (section == 0) ? PLOrderStillHeader.height : PLOrdeStickyHeader.height
        return CGSizeMake(collectionView.bounds.size.width, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = (currentTab == .Drinks) ? PLOrderDrinkCell.height : PLOrderCoverCell.height
        return CGSizeMake(collectionView.bounds.size.width, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        switch currentTab {
        case CurrentTab.Drinks:
            if indexPath.row == drinksDatasource.count-1 {
                loadPage()
            }
        case CurrentTab.Covers: break
        }
    }
}

