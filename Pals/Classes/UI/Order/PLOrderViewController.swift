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

import RandomKit

class PLOrderViewController: PLViewController {
    
    @IBOutlet private var collectionView: UICollectionView!

    var order: PLOrder? = nil
    var user: PLUser? = nil
    var place: PLPlace? = nil
    var message: String? = nil
    var isVip = false
    var orderDrinks = [String: Int]() {
        didSet{
            orderDrinks.count > 0 ? showCheckoutButton() : hideCheckoutButton()
        }
    }
    
    var drinks = [PLDrink]()
    
    private var currentTab: CurrentTab = .Drinks
    private let animableVipView = UINib(nibName: "PLOrderAnimableVipView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLOrderAnimableVipView
    private var vipButton: UIBarButtonItem? = nil
    
    lazy private var checkoutButton: UIButton = {
        let buttonFrame = CGRectMake(0,0,180,60)
        let button = UIButton(frame: buttonFrame)
        button.setTitle("Send", forState: .Normal)
        button.backgroundColor = UIColor(red:0.22, green:0.81, blue:0.51, alpha:0.9)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.layer.cornerRadius = buttonFrame.size.height / 2
        button.hidden = true
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(checkoutButtonPressed(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    private let placeholderUserName = "Chose user"
    private let placeholderPlaceName = "Chose place"
    private let placeholderMessageToUser = "Enter descriprion"
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        // sample fish data
        var i = 0
        while (i < 14) {
            
            let drink = PLDrink(jsonDic: ["id" : i])
            drink?.drinkID = "\(i)"
            drink?.name = (i % 2 == 1) ? "Chernigivske \(i)%" : "Obolon \(i)%"
            drink?.price = Float(arc4random() % 100)
            if i == 7 {
                drink?.price = 0
            }
            i += 1
            drinks.append(drink!)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if navigationItem.titleView != animableVipView {
            navigationItem.titleView = animableVipView
        }
        navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = kPalsPurpleColor
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if navigationItem.titleView != animableVipView {
            navigationItem.titleView = animableVipView
        }
    }
    
    @objc private func vipButtonPressed(sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = nil
        isVip = true
        animableVipView.animateVip()
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(restore), userInfo: nil, repeats: false)
    }
    
    func restore() {
        isVip = false
        navigationItem.rightBarButtonItem = vipButton
        animableVipView.restoreToDefaultState()
    }
    
    func showCheckoutButton() {
        if checkoutButton.hidden != false {
            let originYFinish = view.bounds.size.height - 80
            var frame = checkoutButton.frame
            
            frame.origin.x = view.center.x - frame.size.width / 2
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
    
    func hideCheckoutButton() {
        if checkoutButton.hidden != true {
            var frame = checkoutButton.frame
            frame.origin.x = view.center.x - frame.size.width / 2
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
        
        
        order = PLOrder(withUser: selectedUser, place: selectedPlace, isVip: isVip, message: message, qrCode: qrCode, accessCode: accessCode)
        order?.drinks = orderDrinks
        
        print(order.debugDescription)
    }
}

//MARK: - Order items delegate, Tab changed delegate
extension PLOrderViewController: OrderDrinksCounterDelegate, OrderCurrentTabDelegate, OrderHeaderBehaviourDelegate,OrderPlacesDelegate, OrderFriendsDelegate {
    
    //MARK: Order drinks count
    func updateOrderWith(drink: String, andCount count: Int) {
        if count == 0 {
            orderDrinks.removeValueForKey(drink)
        } else {
            orderDrinks.updateValue(count, forKey: drink)
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
        print("reload collection items")
    }
}

//MARK: - CollectionView dataSource
extension PLOrderViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return drinks.count
        }
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kDrinkCellIdentifier, forIndexPath: indexPath) as! PLOrderDrinkCell
        let drink = drinks[indexPath.row]
        
        cell.delegate = self
        cell.setupWith(drink)
        if let count = orderDrinks[drink.drinkID!] {
            cell.drinkCount = count
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStillHeaderIdentifier, forIndexPath: indexPath) as! PLOrderStillHeader
            header.delegate = self
            header.userNameButton.setTitle(user?.name ?? placeholderUserName, forState: .Normal)
            header.placeNameButton.setTitle(place?.name ?? placeholderPlaceName, forState: .Normal)
            header.messageTextView.text = message ?? placeholderMessageToUser
            
            return header
        } else {
            
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStickyHeaderIdentifier, forIndexPath: indexPath) as! PLOrdeStickyHeader
            header.delegate = self
            header.currentTab = .Drinks
            
            return header
        }
        
    }
    
    //MARK: Collection delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = (section == 0) ? 144 : 61 // hardcore..
        return CGSizeMake(collectionView.bounds.size.width, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, 80) // hardcode..
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}
