//
//  PLSettingsTableViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/3/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CSStickyHeaderFlowLayout

class PLSettingsViewController: PLViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var layout: CSStickyHeaderFlowLayout? {
        return collectionView?.collectionViewLayout as? CSStickyHeaderFlowLayout
    }

    private let headerTitles = ["Cards", "Notifications"]
    private var cardData  = ["Privat Bank", "**** **** **** 4321"]
    private let services = ["Notifications", "Account Info"]
    private let numberOfItems = 2
    
    
    var user: PLUser!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadLayout()
        
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(-20, 0, 0, 0)
        automaticallyAdjustsScrollViewInsets = false
        
        // Setup Cell
        let nib = UINib(nibName: "PLSettingsCell", bundle: nil)
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: "SettingsCell")
        
        // Setup Header
        let headerNib = UINib(nibName: "PLSettingsHeader", bundle: nil)
        collectionView!.registerNib(headerNib,
                                    forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader,
                                    withReuseIdentifier: "Header")
        
        // Setup Section Header
        let sectionHeaderNib = UINib(nibName: "PLSettingsSectionHeader", bundle: nil)
        collectionView!.registerNib(sectionHeaderNib,
                                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                    withReuseIdentifier: "SectionHeader")
        
        // Setup Section Footer
        let sectionFooterNib = UINib(nibName: "PLSettingsSectionFooter", bundle: nil)
        collectionView!.registerNib(sectionFooterNib,
                                    forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                    withReuseIdentifier: "SectionFooter")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButtonItem = PLBackBarButtonItem()
        navigationItem.leftBarButtonItem = backButtonItem
        backButtonItem.didTappedBackButton = {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    private func reloadLayout() {
        layout!.parallaxHeaderReferenceSize = CGSizeMake(view.frame.size.width, 275)
        layout!.parallaxHeaderAlwaysOnTop = true
        layout!.disableStickyHeaders = false
    }


    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowNotifications":
                print("Show Notifications View Controller")
            case "ShowAccountInfo":
                print("Show Account Info ViewController")
            default:
                break
            }
        }
    }

    
}


// MARK: - UICollectionViewDataSource

extension PLSettingsViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return headerTitles.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SettingsCell", forIndexPath: indexPath)
            as! PLSettingsCell

        switch indexPath.section {
        case 0:
            cell.titleLabel.text = cardData[indexPath.row]
        case 1:
            cell.titleLabel.text = services[indexPath.row]
        default:
            break
        }
        cell.separatorView.hidden = indexPath.row % 2 != 0 ? true : false
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                performSegueWithIdentifier("ShowNotifications", sender: self)
            case 1:
                performSegueWithIdentifier("ShowAccountInfo", sender: self)
            default:
                break
            }
        }
    }
    
}


// MARK: - UICollectionViewDelegate

extension PLSettingsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case CSStickyHeaderParallaxHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! PLSettingsHeader
//            headerView.backgroundImageView.setImageWithURL(user.picture)
//            headerView.userProfileImageView.setImageWithURL(user.picture)
            return headerView
        case UICollectionElementKindSectionHeader:
            let sectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as! PLSettingsSectionHeader
            sectionHeader.headerLabel.text = headerTitles[indexPath.section]
            return sectionHeader
        case UICollectionElementKindSectionFooter:
            let sectionFooter = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionFooter", forIndexPath: indexPath) as! PLSettingsSectionFooter
            sectionFooter.didTappedSignOutButton = {
                print("Sign Out")
            }
            return sectionFooter
        default:
            assert(false, "Unsupported supplementary view kind")
            return UICollectionReusableView()
        }
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PLSettingsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(view.frame.size.width, 40)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 1 ? CGSizeMake(view.frame.size.width, 50) : CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.size.width, 44)
    }
}

