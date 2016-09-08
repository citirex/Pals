//
//  PLOrderViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

private let kStillHeaderIdentifier = "stillHeader"
private let kStickyHeaderIdentifier = "stickyHeader"
private let kDrinkCellIdentifier = "drinkCell"


class PLOrderViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var orderDrinks = [String: Int]() {
        didSet{
            if orderDrinks.count > 0 {
                print("Show orderButton")
            }
        }
    }
    private var currentTab: CurrentTab = .Drinks
    var drinks = [PLDrink]()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "PLOrderStillHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kStillHeaderIdentifier)
        collectionView.registerNib(UINib(nibName: "PLOrdeStickyHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kStickyHeaderIdentifier)
        collectionView.registerNib(UINib(nibName: "PLOrderDrinkCell", bundle: nil), forCellWithReuseIdentifier: kDrinkCellIdentifier)
        
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
}

//MARK: - Order items delegate, Tab changed delegate
extension PLOrderViewController: OrderDrinksCounterDelegate, OrderCurrentTabDelegate, OrderHeaderBehaviourDelegate {
    func updateOrderWith(drink: String, andCount count: Int) {
        if count == 0 {
            orderDrinks.removeValueForKey(drink)
        } else {
            orderDrinks.updateValue(count, forKey: drink)
        }
    }
    
    func orderTabChanged(tab: CurrentTab) {
        print("reload collection items")
    }
    
    func vipButtonPressed() {
        print("Vip button pressed")
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
            
            return header
        } else {
            
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStickyHeaderIdentifier, forIndexPath: indexPath) as! PLOrdeStickyHeader
            header.delegate = self
            
            return header
        }
        
    }
    
    //MARK: Collection delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = (section == 0) ? 206 : 61 // hardcore..
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
