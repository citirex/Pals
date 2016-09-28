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
    
    lazy var order: PLCheckoutOrder = {
        let ord = PLCheckoutOrder()
        ord.delegate = self
       return ord
    }()
    
    private var drinksOffset = CGPointZero
    private var coversOffset = CGPointZero
    
    private var drinksDatasource = PLDrinksDatasource()
    private var coversDatasource = PLCoversDatasource()
    
    var currentTab = PLCollectionSectionType.Drinks
    private let animableVipView = UINib(nibName: "PLOrderAnimableVipView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLOrderAnimableVipView
    private lazy var checkoutPopupViewController : PLOrderCheckoutPopupViewController = {
        let popup = PLOrderCheckoutPopupViewController(nibName: "PLOrderCheckoutPopupViewController", bundle: nil)
        popup.delegate = self
        popup.modalPresentationStyle = .OverCurrentContext
       return popup
    }()
    private var vipButton: UIBarButtonItem? = nil
    private var checkoutButton = UIButton(frame: CGRectZero)
    
    private let placeholderUserName = "Chose user"
    private let placeholderPlaceName = "Chose place"
    
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    //MARK: - Network
    private func loadDrinks() {
        spinner.startAnimating()
        spinner.center = view.center
        drinksDatasource.loadPage { (indices, error) in
            if error == nil {
                if self.currentTab == .Drinks {
                    let newIndexPaths = indices.map({ NSIndexPath(forItem: $0.row, inSection: 1) })
                    self.collectionView?.performBatchUpdates({
                        self.collectionView?.insertItemsAtIndexPaths(newIndexPaths)
                        }, completion: nil)
                }
            } else {
                PLShowErrorAlert(error: error!)
            }
            self.spinner.stopAnimating()
        }
    }
    //FIXME: make no duplication of code
    private func loadCovers() {
        spinner.startAnimating()
        spinner.center = view.center
        
        coversDatasource.loadPage { (indices, error) in
            if error == nil {
                if self.currentTab == .Covers {
                    let newIndexPaths = indices.map({ NSIndexPath(forItem: $0.row, inSection: 1) })
                    self.collectionView?.performBatchUpdates({
                        self.collectionView?.insertItemsAtIndexPaths(newIndexPaths)
                        }, completion: nil)
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
        order.isVIP = !order.isVIP
        performTransitionToVipState(order.isVIP)
    }
    
    func restore() {
        order.isVIP = false
        navigationItem.rightBarButtonItem = vipButton
        animableVipView.restoreToDefaultState()
    }
    
    func performTransitionToVipState(vip: Bool) {
        (vip == true) ? animableVipView.animateVip() : animableVipView.restoreToDefaultState()
        UIView.animateWithDuration(0.3) {
            self.bgImageView.image = (vip == true) ? UIImage(named: "order_bg_vip") : UIImage(named: "order_bg")
            self.navigationController?.navigationBar.barTintColor = (vip == true) ? kPalsGoldColor : UIColor.affairColor()
        }
        drinksDatasource.isVIP = order.isVIP
        coversDatasource.isVIP = order.isVIP
        if order.place != nil {
            clean()
            drinksDatasource.collection.clean()
            coversDatasource.collection.clean()
            updateCheckoutButtonState()
            collectionView.reloadSections(NSIndexSet(index: 1))
            loadDrinks()
            loadCovers()
        }
    }
    
    func clean() {
        order.clean()
        coversOffset = CGPointZero
        drinksOffset = CGPointZero
    }
    
    // MARK: - Navigation
    @IBAction func backBarButtonItemTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(false, completion: nil)
    }
}

//MARK: - Checkout behavior
extension PLOrderViewController {
    func updateCheckoutButtonState() {
        (order.drinks.count > 0 || order.covers.count > 0) ? showCheckoutButton() : hideCheckoutButton()
    }
    
    private func showCheckoutButton() {
        if checkoutButton.hidden == true {
            let originYFinish = view.bounds.size.height - kCheckoutButtonHeight + 10
            var frame = checkoutButton.frame
            frame.origin.y = collectionView.bounds.size.height
            checkoutButton.frame = frame
            checkoutButton.hidden = false
            frame.origin.y = originYFinish
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.AllowUserInteraction], animations: {
                self.checkoutButton.frame = frame
                }, completion: nil)
        }
    }
    
    private func hideCheckoutButton() {
        if checkoutButton.hidden == false {
            var frame = checkoutButton.frame
            frame.origin.y = collectionView.bounds.size.height
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                                        self.checkoutButton.frame = frame
                }, completion: { (completion) in
                    self.checkoutButton.hidden = true
            })
        }
    }
    
    @objc private func checkoutButtonPressed(sender: UIButton) {
        guard let user = order.user else {
            checkoutButton.shake()
            PLShowAlert(title: "Need to chose user")
            return
        }
        guard let place = order.place else {
            checkoutButton.shake()
            PLShowAlert(title: "Need to chose place")
            return
        }
        
        checkoutPopupViewController.userName = user.name
        checkoutPopupViewController.locationName = place.name
        checkoutPopupViewController.orderAmount = calculateTotalAmount()
        tabBarController!.presentViewController(checkoutPopupViewController, animated: false) {
            self.checkoutPopupViewController.show()
        }
    }
    
    func calculateTotalAmount() -> String {
        var amount: Float = 0.0

        if order.drinks.count > 0 {
            for drinkSet in order.drinks.values {
                amount += Float(drinkSet.quantity) * drinkSet.drink.price
            }
        }
        
        if order.covers.count > 0 {
            for aCover in coversDatasource.collection.objects {
                if order.covers.contains(String(aCover.id)) {
                    amount += aCover.price
                }
            }
        }
        return "$" + String(format: "%.2f", amount)
    }
    
    func createNewOrderWithMessage(message: String) {
        order.message = message
        order.clean()
        updateCheckoutButtonState()

        collectionView.reloadSections(NSIndexSet(index: 1))
        tabBarController?.incrementCounterNumberOn(.TabProfile)
        tabBarController?.switchTabTo(.TabProfile)
    }
}

//MARK: - Order items delegate, Tab changed delegate
extension PLOrderViewController: OrderDrinksCounterDelegate, OrderCurrentTabDelegate, OrderHeaderBehaviourDelegate,OrderPlacesDelegate, OrderFriendsDelegate, CheckoutOrderPopupDelegate, PLCheckoutDelegate {
    
    //MARK: Checkout delegate
    func newPlaceWasSet() {
        updateDataForSelectedPlace()
    }
    
    //MARK: Order drinks count
    func updateOrderWith(drinkCell: PLOrderDrinkCell, andCount count: UInt64) {
        order.updateWithDrink(drinksDatasource[collectionView.indexPathForCell(drinkCell)!.row], andCount: count)
        updateCheckoutButtonState()
    }

    func updateCoverAt(indexPath: NSIndexPath) {
        let coverCell = collectionView.cellForItemAtIndexPath(indexPath) as! PLOrderCoverCell
        let coverID = coversDatasource.collection.objects[indexPath.row].id
        order.updateWithCoverID(coverID, inCell: coverCell)
        updateCheckoutButtonState()
    }
    
    
    //MARK: Cnange user
    func userNamePressed(sender: AnyObject) {
        if let viewController = UIStoryboard.viewControllerWithType(.OrderFriendsViewController) as? PLOrderFriendsViewController {
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func didSelectFriend(selectedFriend: PLUser) {
        order.user = selectedFriend
        collectionView.reloadData()
    }
    
    //MARK: Cnange place
    func placeNamePressed(sender: AnyObject) {
        if let viewController = UIStoryboard.viewControllerWithType(.OrderLocationsViewController) as? PLOrderPlacesViewController {
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func didSelectNewPlace(selectedPlace: PLPlace) {
        order.place = selectedPlace
    }
    
    func updateDataForSelectedPlace() {
        clean()
        if collectionView != nil { collectionView.reloadData() }
        drinksDatasource.placeId = order.place!.id
        coversDatasource.placeId = order.place!.id
        loadDrinks()
        loadCovers()
    }
    
    //MARK: Order change tab
    func orderTabChanged(tab: PLCollectionSectionType) {
        switch currentTab {
        case .Drinks: drinksOffset = collectionView.contentOffset
        case .Covers: coversOffset = collectionView.contentOffset
        }
        
        currentTab = tab
        
        UIView.animateWithDuration(0, delay: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: {
            }) { (complete) in
                self.collectionView.contentOffset = (self.currentTab == .Drinks) ? self.drinksOffset : self.coversOffset
                self.collectionView.reloadSections(NSIndexSet(index: 1))
        }
    }
    
    //MARK: - Checkout Popup 
    func cancelButtonPressed() {
        checkoutPopupViewController.hide()
    }
    
    func sendButtonPressedWith(message: String) {
        checkoutPopupViewController.hide()
        createNewOrderWithMessage(message)
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
}

//MARK: - CollectionView dataSource
extension PLOrderViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
            if (order.covers.contains(String(cover.id))) {
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
        case .Covers: if indexPath.row == coversDatasource.count - 1 {  loadCovers() }
        }
    }
}

