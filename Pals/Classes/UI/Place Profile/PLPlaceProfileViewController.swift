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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadLayout()
        
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(-20, 0, 0, 0)
        automaticallyAdjustsScrollViewInsets = false
        
        // Setup Cell
        let nib = UINib(nibName: "PLPlaceProfileCollectionViewCell", bundle: nil)
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: "EventCell")
        
        // Setup Header
        let headerNib = UINib(nibName: "PLPlaceProfileHeader", bundle: nil)
        collectionView!.registerNib(headerNib,
                                    forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader,
                                    withReuseIdentifier: "Header")
        
        // Setup Section Header
        let sectionHeaderNib = UINib(nibName: "PLPlaceProfileSectionHeader", bundle: nil)
        collectionView!.registerNib(sectionHeaderNib,
                                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                    withReuseIdentifier: "SectionHeader")
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
    
    private func reloadLayout() {
        layout!.parallaxHeaderReferenceSize = CGSizeMake(view.frame.size.width, 200)
        layout!.parallaxHeaderMinimumReferenceSize = CGSizeMake(view.frame.size.width, 80)
        layout!.parallaxHeaderAlwaysOnTop = true
        layout!.disableStickyHeaders = false
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowOrder" {
        
        }
    }


}


// MARK: - UICollectionViewDataSource

extension PLPlaceProfileViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventCell", forIndexPath: indexPath)
            as! PLPlaceProfileCollectionViewCell
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension PLPlaceProfileViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case CSStickyHeaderParallaxHeader:
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            return view
        case UICollectionElementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as! PLPlaceProfileSectionHeader
            view.delegate = self
            return view
        default:
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

// MARK: - PLPlaceProfileSectionHeaderDelegate

extension PLPlaceProfileViewController: PLPlaceProfileSectionHeaderDelegate {
    
    func didSelectOrderButton() {
        performSegueWithIdentifier("ShowOrder", sender: self)
    }
}