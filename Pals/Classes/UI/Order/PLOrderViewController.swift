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

private let kCheckoutButtonHeight: CGFloat = 74

class PLOrderViewController: PLViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var bgImageView: UIImageView!
    
    var order = PLCheckoutOrder()
    
    private var drinksOffset = CGPointZero
    private var coversOffset = CGPointZero
    
    private var drinksDatasource = PLDrinksDatasource()
    private var coversDatasource = PLCoversDatasource()
    
    private var currentTab = PLCollectionSectionType.Drinks
    private let animableVipView = UINib(nibName: "PLOrderAnimableVipView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLOrderAnimableVipView
 
    private lazy var noItemsView: PLEmptyBackgroundView = {
        let emptyView = PLEmptyBackgroundView(topText: "No drinks", bottomText: nil)
        self.collectionView.addSubview(emptyView)
        emptyView.autoCenterInSuperview()
        emptyView.hidden = true
        
        return emptyView
    }()
    
    private var vipButton: UIBarButtonItem? = nil
    private var checkoutButton = UIButton(frame: CGRectZero)
    private var checkoutButtonOnScreen = false
    
    private let placeholderUserName = "Chose user"
    private let placeholderPlaceName = "Chose place"
    
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        setupCheckoutButton()
        setupCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if navigationItem.titleView != animableVipView {
            navigationItem.titleView = animableVipView
        }
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = (order.isVIP == true) ? kPalsGoldColor : UIColor.affairColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if navigationItem.titleView != animableVipView {
            navigationItem.titleView = animableVipView
        }
    }
        
    
    //Publiq methods
    func setSectionType(type: PLCollectionSectionType) {
        orderTabChanged(type)
    }
    
    func setNewPlace(place: PLPlace) {
        order.place = place
        updateDataForSelectedPlace()
    }
}

//MARK: - Checkout behavior
extension PLOrderViewController {
    //MARK: - Network
    private func loadDrinks() {
        startActivityIndicator(.WhiteLarge)
        coversDatasource.cancel()
        drinksDatasource.loadPage {[unowned self] (indices, error) in
            self.collectionViewInsertItems(indices, withError: error)
        }
    }
    
    private func loadCovers() {
        startActivityIndicator(.WhiteLarge)
        drinksDatasource.cancel()
        coversDatasource.loadPage {[unowned self] (indices, error) in
            self.collectionViewInsertItems(indices, withError: error)
        }
    }
    
    private func collectionViewInsertItems(indices: [NSIndexPath],withError error: NSError?) {
        if error == nil {
            if indices.count > 0 {
                noItemsView.hidden = true
                let newIndexPaths = indices.map({ NSIndexPath(forItem: $0.row, inSection: 1) })
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.insertItemsAtIndexPaths(newIndexPaths)
                    }, completion: { (complete) in
                })
            } else {
                switch currentTab {
                case .Drinks:
                    if drinksDatasource.pagesLoaded == 0 && order.place != nil {
                        noItemsView.setupTextLabels("No drinks", bottomText: nil)
                        noItemsView.hidden = false
                    }
                case .Covers:
                    if coversDatasource.pagesLoaded == 0 && order.place != nil {
                        noItemsView.setupTextLabels("No covers", bottomText: nil)
                        noItemsView.hidden = false
                    }
                }
            }
            
        } else {
            PLShowErrorAlert(error: error!)
        }
        self.stopActivityIndicator()
    }
    
    //MARK: - Actions
    @objc private func vipButtonPressed(sender: UIBarButtonItem) {
        order.isVIP = !order.isVIP
        performTransitionToVipState(order.isVIP)
    }
    
    private func restore() {
        order.isVIP = false
        self.bgImageView.image = UIImage(named: "order_bg")
        navigationItem.rightBarButtonItem = vipButton
        animableVipView.restoreToDefaultState()
    }
    
    private func performTransitionToVipState(vip: Bool) {
        (vip == true) ? animableVipView.animateVip() : animableVipView.restoreToDefaultState()
        UIView.animateWithDuration(0.3) {
            self.bgImageView.image = (vip == true) ? UIImage(named: "order_bg_vip") : UIImage(named: "order_bg")
            self.navigationController?.navigationBar.barTintColor = (vip == true) ? kPalsGoldColor : UIColor.affairColor()
        }
        drinksDatasource.isVIP = order.isVIP
        coversDatasource.isVIP = order.isVIP
        if order.place != nil {
            order.clean()
            resetOffsets()
            resetDataSources()
            updateCheckoutButtonState()
            collectionView.reloadSections(NSIndexSet(index: 1))
            currentTab == .Drinks ? loadDrinks() : loadCovers()
        }
    }
    
    private func resetOffsets() {
        coversOffset = CGPointZero
        drinksOffset = CGPointZero
    }
    
    private func resetDataSources() {
        drinksDatasource.clean()
        coversDatasource.clean()
    }
    
    // MARK: - Navigation
    @IBAction private func backBarButtonItemTapped(sender: UIBarButtonItem) {
        dismiss(false)
    }
    
    
    func updateCheckoutButtonState() {
        (order.drinks.count > 0 || order.covers.count > 0) ? showCheckoutButton() : hideCheckoutButton()
    }
    
    private func showCheckoutButton() {
        if checkoutButtonOnScreen == false {
            checkoutButtonOnScreen = true
            checkoutButton.layer.removeAllAnimations()
            let originYFinish = view.bounds.size.height - kCheckoutButtonHeight + 10
            var frame = checkoutButton.frame
            frame.origin.y = collectionView.bounds.size.height
            checkoutButton.frame = frame
            checkoutButton.hidden = false
            frame.origin.y = originYFinish
            shiftCollectionView(true)
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.AllowUserInteraction], animations: {
                self.checkoutButton.frame = frame
                }, completion: nil)
        }
    }
    
    private func hideCheckoutButton() {
        if checkoutButtonOnScreen == true {
            checkoutButtonOnScreen = false
            var frame = checkoutButton.frame
            frame.origin.y = collectionView.bounds.size.height
            shiftCollectionView(false)
            
            UIView.animateWithDuration(0.3, delay: 0, options: [.BeginFromCurrentState, .AllowUserInteraction, .CurveLinear], animations: {
                                        self.checkoutButton.frame = frame
                }, completion: { (completion) in
                    if completion == true {
                        self.checkoutButton.hidden = true
                    }
            })
        }
    }
    
    func shiftCollectionView(shift: Bool) {
        let newOffsetShift = collectionView.contentOffset.y
		if (UIScreen.mainScreen().bounds.height - navigationController!.navigationBar.frame.size.height - tabBarController!.tabBar.frame.size.height - collectionView.contentSize.height) <= kCheckoutButtonHeight {
				UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState, animations: {
				self.collectionView.contentOffset.y = shift ? newOffsetShift + kCheckoutButtonHeight : newOffsetShift - kCheckoutButtonHeight
				}) { (complete) in
				self.collectionView.contentInset.bottom = shift ? kCheckoutButtonHeight : 0
				}
		}
    }
    
    
    
    @objc private func checkoutButtonPressed(sender: UIButton) {
        guard order.user != nil else {
            checkoutButton.shake()
            return PLShowAlert(title: "Need to chose user")
        }
        guard order.place != nil else {
            checkoutButton.shake()
            return PLShowAlert(title: "Need to chose place")
        }
        createAndShowSendPopup(order)
    }
    
    func createAndShowSendPopup(order: PLCheckoutOrder) {
        let popup = PLOrderCheckoutPopupViewController(nibName: "PLOrderCheckoutPopupViewController", bundle: nil)
        popup.delegate = self
        popup.modalPresentationStyle = .OverCurrentContext
        popup.order = order
        tabBarController!.presentViewController(popup, animated: false) {
            popup.show()
        }
    }
    
    func sendCurrentOrder() {
        startActivityIndicator(.WhiteLarge)
        PLFacade.sendOrder(order) {[unowned self] (order,error) in
            if let newOrder = order {
                self.order = PLCheckoutOrder()
                self.resetOffsets()
                self.performTransitionToVipState(false)
                self.resetDataSources()
                self.updateCheckoutButtonState()
                self.collectionView.reloadData()
                
                
                if PLFacade.profile!.id == order?.user.id {
                    let profileViewController = self.tabBarController!.profileViewController
                    profileViewController.addNewOrder(newOrder)
                    let item = PLTabBarItem.ProfileTabBarItem.rawValue
                    self.tabBarController?.tabBar.items![item].plusBadge()
                    self.tabBarController?.switchTabBarItemTo(.ProfileTabBarItem)
                } else {
                    PLShowAlert(title: "Success")
                }
            
            } else {
                PLShowErrorAlert(error: error!)
            }
            self.stopActivityIndicator()
        }
    }
}

//MARK: - Order items delegate, Tab changed delegate
extension PLOrderViewController: OrderDrinksCounterDelegate, OrderCurrentTabDelegate, OrderHeaderBehaviourDelegate, CheckoutOrderPopupDelegate {
    
    //MARK: Order drinks count
    func updateOrderWith(drinkCell: PLOrderDrinkCell, andCount count: UInt64) {
        order.updateWithDrink(drinksDatasource[collectionView.indexPathForCell(drinkCell)!.row], andCount: count)
        updateCheckoutButtonState()
    }

    func updateCoverAt(indexPath: NSIndexPath) {
        let coverCell = collectionView.cellForItemAtIndexPath(indexPath) as! PLOrderCoverCell
        let cover = coversDatasource[indexPath.row]
        order.updateWithCoverID(cover, inCell: coverCell)
        updateCheckoutButtonState()
    }
    
    
    //MARK: Cnange user
    func userNamePressed(sender: AnyObject) {
        performSegueWithIdentifier(SegueIdentifier.OrderFriendsSegue, sender: sender)
    }

    //MARK: Cnange place
    func placeNamePressed(sender: AnyObject) {
        performSegueWithIdentifier(SegueIdentifier.OrderPlacesSegue, sender: sender)
    }

    func updateDataForSelectedPlace() {
        resetOffsets()
        order.clean()
        updateCheckoutButtonState()
        if collectionView != nil {
            collectionView.reloadData()
        }
        drinksDatasource.placeId = order.place!.id
        coversDatasource.placeId = order.place!.id
        currentTab == .Drinks ? loadDrinks() : loadCovers()
    }
    
    //MARK: Order change tab
    func orderTabChanged(tab: PLCollectionSectionType) {
        noItemsView.hidden = true
        self.stopActivityIndicator()
        switch currentTab {
        case .Drinks:
            drinksOffset = collectionView.contentOffset
            drinksDatasource.cancel()
            if coversDatasource.pagesLoaded < 1 && order.place != nil {
                loadCovers()
            }
        case .Covers:
            coversOffset = collectionView.contentOffset
            coversDatasource.cancel()
            if drinksDatasource.pagesLoaded < 1 && order.place != nil {
                loadDrinks()
            }
        }
        
        currentTab = tab
        collectionView.contentOffset = (self.currentTab == .Drinks) ? self.drinksOffset : self.coversOffset
        collectionView.reloadData()
    }
    
    //MARK: - Send Popup
    func orderPopupCancelClicked(popup: PLOrderCheckoutPopupViewController) {
        popup.hide()
    }
    
    func orderPopupSendClicked(popup: PLOrderCheckoutPopupViewController) {
        popup.hide()
        sendCurrentOrder()
    }
    
    //MARK: - Setup
    func setupCollectionView() {
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
        checkoutButton.frame = CGRectMake(0,0,view.bounds.size.width,kCheckoutButtonHeight)
        checkoutButton.setTitle("Send", forState: .Normal)
        checkoutButton.backgroundColor = UIColor(red:0.25, green:0.57, blue:0.42, alpha:1.0)
        checkoutButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        checkoutButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        checkoutButton.round([.TopLeft, .TopRight], radius: 10)
        checkoutButton.hidden = true
        self.view.addSubview(checkoutButton)
        checkoutButton.addTarget(self, action: #selector(checkoutButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = SegueIdentifier(rawValue: segue.identifier!) else { return }
        switch identifier {
        case .OrderPlacesSegue:
            if let orderPlacesViewController = segue.destinationViewController as? PLOrderPlacesViewController {
                orderPlacesViewController.delegate = self
            }
        case .OrderFriendsSegue:
            if let orderFriendsViewController = segue.destinationViewController as? PLOrderFriendsViewController {
                orderFriendsViewController.delegate = self
            }
        default:
            break
        }
    }

}

//MARK: - CollectionView dataSource
extension PLOrderViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIDevice.SYSTEM_VERSION_LESS_THAN("9.0") {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        if section == 1 {
            switch currentTab {
            case .Drinks:
                return drinksDatasource.count
            case .Covers:
                return coversDatasource.count
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
        case .Drinks:
            let cell = dequeuedCell as! PLOrderDrinkCell
            let drink = drinksDatasource[indexPath.row].cellData
            
            cell.delegate = self
            cell.setupWith(drink, isVip: order.isVIP)
            if let drinkSet = order.drinks[drink.drinkId] {
                cell.drinkCount = drinkSet.quantity
            }
            return cell
        case .Covers:
            let cell = dequeuedCell as! PLOrderCoverCell
            let cover = coversDatasource[indexPath.row]
            cell.coverTitle = cover.name
            if order.covers[cover.id] != nil {
                cell.setDimmed(true, animated: false)
            }
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStillHeaderIdentifier, forIndexPath: indexPath) as! PLOrderStillHeader
            header.delegate = self
            header.userName = order.user?.name ?? placeholderUserName
            header.placeName = order.place?.name ?? placeholderPlaceName
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
        case .Drinks: break
        case .Covers:
            updateCoverAt(indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = (section == 0) ? PLOrderStillHeader.height : PLOrdeStickyHeader.height
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
        case .Drinks: if indexPath.row == drinksDatasource.count - 1 { loadDrinks() }
        case .Covers: if indexPath.row == coversDatasource.count - 1 { loadCovers() }
        }
    }
    
}


// MARK: - PLPlacesSelectionDelegate

extension PLOrderViewController: PLOrderPlacesSelectionDelegate {
    
    func didSelectPlace(controller: PLOrderPlacesViewController, place: PLPlace) {
        setNewPlace(place)
        controller.navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: - PLFriendsSelectionDelegate

extension PLOrderViewController: PLOrderFriendsSelectionDelegate {
    
    func didSelectFriend(controller: PLOrderFriendsViewController, friend: PLUser) {
        order.user = friend
        collectionView.reloadSections(NSIndexSet(index: 0))
        controller.navigationController?.popViewControllerAnimated(true)
    }
}
