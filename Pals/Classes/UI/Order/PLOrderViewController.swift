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
   
    
    private var totalAmount: Float = 0
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private var firstLaunch: Bool = true
    private var drinksDatasource = PLDrinksDatasource()
    
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
    
    //Sample var
    private var covers = [PLCover]()
    
    private var orderCovers = [UInt64]() {
        didSet{
            print(orderCovers.debugDescription)
        }
    }
    
    
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
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = (isVip == true) ? kPalsGoldColor : kPalsPurpleColor
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if navigationItem.titleView != animableVipView {
            navigationItem.titleView = animableVipView
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = nil
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
        collectionView.reloadSections(NSIndexSet(index: 1))

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
    
    // MARK: - Navigation
    @IBAction func backBarButtonItemTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(false, completion: nil)
    }
}

//MARK: - Checkout behavior
extension PLOrderViewController {
    private func showCheckoutButton() {
        if checkoutButton.hidden != false {
            let originYFinish = view.bounds.size.height - kCheckoutButtonHeight + 10
            var frame = checkoutButton.frame
            frame.origin.y = view.bounds.size.height
            checkoutButton.frame = frame
            checkoutButton.hidden = false
            frame.origin.y = originYFinish
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.AllowUserInteraction], animations: {
                self.checkoutButton.frame = frame
                }, completion: nil)
        }
    }
    
    private func hideCheckoutButton() {
        if checkoutButton.hidden != true {
            var frame = checkoutButton.frame
            frame.origin.y = view.bounds.size.height
            
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                                        self.checkoutButton.frame = frame
                }, completion: { (completion) in
                    self.checkoutButton.hidden = true
            })
        }
    }
    
    @objc private func checkoutButtonPressed(sender: UIButton) {
        guard user != nil else {
            checkoutButton.shake()
            PLShowAlert(title: "Need to chose user")
            return
        }
        guard place != nil else {
            checkoutButton.shake()
            PLShowAlert(title: "Need to chose place")
            return
        }
        
        checkoutPopupViewController.userName = user?.name
        checkoutPopupViewController.locationName = place?.name
        checkoutPopupViewController.orderAmount = calculateTotalAmount()
        tabBarController!.presentViewController(checkoutPopupViewController, animated: false) {
            self.checkoutPopupViewController.show()
        }
    }
    
    func calculateTotalAmount() -> String {
//         drinksDatasource.collection.objects
        return "$666"
    }
    
    func createNewOrderWithMessage(message: String) {
        let qrCode = String.randomAlphaNumericString(8).uppercaseString
        let accessCode = String.randomAlphaNumericString(8).uppercaseString
        
        order = PLCheckoutOrder(qrCode: qrCode,
                                accessCode: accessCode,
                                user: user!,
                                place: place!,
                                drinks: orderDrinks,
                                isVip: isVip,
                                message: message)
        
        print(order?.serialize())
        
        order = nil
        orderDrinks.removeAll()
        collectionView.reloadSections(NSIndexSet(index: 1))
        
        tabBarController?.incrementCounterNumberOn(.TabProfile)
        tabBarController?.switchTabTo(.TabProfile)
    }
}

//MARK: - Order items delegate, Tab changed delegate
extension PLOrderViewController: OrderDrinksCounterDelegate, OrderCurrentTabDelegate, OrderHeaderBehaviourDelegate,OrderPlacesDelegate, OrderFriendsDelegate, CheckoutOrderPopupDelegate {
    
    //MARK: Order drinks count
    func updateOrderWith(cell: PLOrderDrinkCell, andCount count: UInt64) {
        
        let currentDrink = drinksDatasource.collection.objects[(collectionView.indexPathForCell(cell)?.row)!]
        
        
//        let drinkset = PLDrinkset(aDrink: currentDrink, andCount: count)
//        
//        let drinkss = [PLDrinkset];
//        
//        if drinkss.contains(drinkset) {
//            
//        }
        
        if count == 0 {
//            totalAmount = 0
            orderDrinks.removeValueForKey(String(currentDrink.id))
        } else {
//            if orderDrinks[String(currentDrink.id)] {
//                
//            }
//            totalAmount = 0
            orderDrinks.updateValue(String(count), forKey: String(currentDrink.id))
        }
    }
    
    //sample fish
    func updateOrderAt(indexPath: NSIndexPath) {
        let coverCell = collectionView.cellForItemAtIndexPath(indexPath) as! PLOrderCoverCell
        let coverID = covers[indexPath.row].id
        
        if let index = orderCovers.indexOf(coverID) {
            orderCovers.removeAtIndex(index)
            coverCell.setDimmed(false, animated: true)
        } else {
            orderCovers.append(coverID)
            coverCell.setDimmed(true, animated: true)
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
    func orderTabChanged(tab: PLCollectionSectionType) {
        currentTab = tab
        UIView.animateWithDuration(0, delay: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: {
            }) { (complete) in
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
            case .Drinks:
                return drinksDatasource.count ?? 0
            case .Covers:
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
        case .Drinks:
            let cell = dequeuedCell as! PLOrderDrinkCell
            let drink = drinksDatasource[indexPath.row].cellData
            
            cell.delegate = self
            cell.setupWith(drink, isVip: isVip)
            if let count = orderDrinks[String(drink.drinkId)] {
                cell.drinkCount = UInt64(count)!
            }
            return cell
        case .Covers:
            let cell = dequeuedCell as! PLOrderCoverCell
            let cover = covers[indexPath.row]
            cell.coverTitle = cover.name
            if (orderCovers.indexOf(covers[indexPath.row].id) != nil) {
                cell.setDimmed(true, animated: false)
            }
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
        case .Drinks:
            break
        case .Covers:
            updateOrderAt(indexPath)
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
        case .Drinks:
            if indexPath.row == drinksDatasource.count-1 {
                loadPage()
            }
        case .Covers: break
        }
    }
}

