//
//  PLPlaceProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/7/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CSStickyHeaderFlowLayout

class PLPlaceProfileViewController: PLViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var layout: CSStickyHeaderFlowLayout? {
        return collectionView?.collectionViewLayout as? CSStickyHeaderFlowLayout
    }
    
    var place: PLPlace!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadLayout()
        setupCollectionView()
        
        let backButtonItem = PLBackBarButtonItem()
        navigationItem.leftBarButtonItem = backButtonItem
        backButtonItem.didTappedBackButton = {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.hideTransparentNavigationBar()
    }
    
    
    // MARK: - Configure collectionView
    
    private func setupCollectionView() {
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(-20, 0, 0, 0)
        automaticallyAdjustsScrollViewInsets = false
        
        // Setup Cell
        let nib = UINib(nibName: PLPlaceProfileCell.nibName, bundle: nil)
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: PLPlaceProfileCell.identifier)
        
        // Setup Header
        let headerNib = UINib(nibName: PLPlaceProfileHeader.nibName, bundle: nil)
        collectionView!.registerNib(headerNib,
                                    forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader,
                                    withReuseIdentifier: PLPlaceProfileHeader.identifier)
        
        // Setup Section Header
        let sectionHeaderNib = UINib(nibName: PLPlaceProfileSectionHeader.nibName, bundle: nil)
        collectionView!.registerNib(sectionHeaderNib,
                                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                    withReuseIdentifier: PLPlaceProfileSectionHeader.identifier)
    }
    
    private func reloadLayout() {
        layout!.parallaxHeaderReferenceSize = CGSizeMake(view.frame.size.width, 200)
        layout!.parallaxHeaderMinimumReferenceSize = CGSizeMake(view.frame.size.width, 80)
        layout!.parallaxHeaderAlwaysOnTop = true
        layout!.disableStickyHeaders = false
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowOrder" {
            let orderViewController = segue.destinationViewController as! PLOrderViewController
            orderViewController.place = place
        }
    }

}


// MARK: - UICollectionViewDataSource

extension PLPlaceProfileViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PLPlaceProfileCell.identifier, forIndexPath: indexPath)
            as! PLPlaceProfileCell
        cell.eventImageView.setImageWithURL(place.picture)
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension PLPlaceProfileViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case CSStickyHeaderParallaxHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PLPlaceProfileHeader.identifier, forIndexPath: indexPath) as! PLPlaceProfileHeader
            headerView.headerImageView.setImageWithURL(place.picture)
            return headerView
        case UICollectionElementKindSectionHeader:
            let sectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PLPlaceProfileSectionHeader.identifier, forIndexPath: indexPath) as! PLPlaceProfileSectionHeader
            sectionHeader.placeNameLabel.text = place.name
            sectionHeader.musicGenresLabel.text = place.musicGengres
            sectionHeader.closingTimeLabel.text = place.closeTime
            sectionHeader.placeAddressLabel.text = place.address
            sectionHeader.phoneNumberLabel.text = place.phone
            sectionHeader.didTappedOrderButton = {
                self.performSegueWithIdentifier("ShowOrder", sender: self)
            }
            return sectionHeader
        default:
            assert(false, "Unsupported supplementary view kind")
            return UICollectionReusableView()
        }
    }

}


// MARK: - UICollectionViewDelegateFlowLayout

extension PLPlaceProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(view.frame.size.width, 165)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.size.width, 95)
    }
}
