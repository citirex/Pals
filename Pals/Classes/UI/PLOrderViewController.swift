//
//  PLOrderViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

private let orderCellIdentifier = "orderCell"

class PLOrderViewController: PLSlidingViewController {//TGLStackedViewController, UICollectionViewDataSource {

    var orderBackgroundView = UINib(nibName: "PLOrderBackgroundView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLOrderBackgroundView
    var orderSlidingView = UINib(nibName: "PLOrderOffersView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLOrderOffersView
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        backgroundView = orderBackgroundView
        slidingView = orderSlidingView
        
        
        
//        setupCollectionBackgroundView(collectionBackgroundView)
//        
//        collectionView?.registerNib(UINib(nibName: "PLOrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: orderCellIdentifier)
//        
//        
//        var expoItemSize = CGSizeMake(collectionView!.bounds.size.width, 420)
//        if (UIDevice().type == .iPhone4 || UIDevice().type == .iPhone4S) {
//            //|| UIDevice().type == .simulator) {
//            expoItemSize.height = 340
//        }
//        exposedItemSize = expoItemSize
//        stackedLayout!.itemSize = self.exposedItemSize;
//        stackedLayout!.layoutMargin = UIEdgeInsetsMake(282.0, 0.0, self.tabBarController!.tabBar.frame.height, 0.0);
//        
//        
//        collectionView?.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Collection datasource
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(orderCellIdentifier, forIndexPath: indexPath) as! PLOrderCollectionViewCell
//        return cell
//    }

}
