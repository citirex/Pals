//
//  PLProfileViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import SwiftQRCode
import RandomKit

private let drinkCellIdentifier = "DrinkCell"

class PLProfileViewController: TGLStackedViewController {

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.registerNib(UINib(nibName: "PLProfileDrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: drinkCellIdentifier)
        
        self.exposedItemSize = CGSizeMake(collectionView!.bounds.size.width, 400);
        
        let bottomSpace = (self.tabBarController != nil) ? self.tabBarController!.tabBar.frame.height : 44
        
        
        self.stackedLayout!.itemSize = self.exposedItemSize;
        self.stackedLayout!.layoutMargin = UIEdgeInsetsMake(220.0, 0.0, bottomSpace, 0.0);
        self.stackedLayout!.topReveal = 60;
        self.stackedLayout!.bounceFactor = 0.2;
        self.stackedLayout!.fillHeight = true;
        self.stackedLayout!.alwaysBounce = false;

        
        let backView = UIView(frame: self.collectionView!.bounds);
        backView.backgroundColor = UIColor.magentaColor()

        self.view.insertSubview(backView, belowSubview: self.collectionView!)
        
        let backgroundProxy = TGLBackgroundProxyView()
        backgroundProxy.targetView = backView
        self.collectionView?.backgroundView = backgroundProxy
        
//        TGLBackgroundProxyView *backgroundProxy = [[TGLBackgroundProxyView alloc] init];
        
//        backgroundProxy.targetView = self.collectionViewBackground;
//        backgroundProxy.hidden = self.collectionViewBackground.hidden;
//        
//        self.collectionView.backgroundView = backgroundProxy;
        
        
        

//        let randInt = String(Int.random(100...999))
//        let randString = String.random(5, "A"..."Z")
//        let result = randString + randInt
//        qrTextLabel.text = result
//        quImageView.image = QRCode.generateImage(result, avatarImage: nil)
 
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView!.backgroundColor = UIColor.clearColor()
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(drinkCellIdentifier, forIndexPath: indexPath) as! PLProfileDrinkCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.headerView.backgroundColor = generateRandomColor()
        cell.barTitleLabel.text = "Bar #\(indexPath.row)"
        
        return cell
    }
    

    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
