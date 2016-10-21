//
//  PLPlaceProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/7/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import EventKit

private let kStillHeaderIdentifier = "stillHeader"
private let kStickyHeaderIdentifier = "stickyHeader"

private let kCollectionHeaderHeight: CGFloat = 188
private let kCollectionCellHeight: CGFloat = 115


class PLPlaceProfileViewController: PLViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let eventsDatasource = PLEventsDatasource()
    var place: PLPlace! {
        didSet {
            if let newPlace = place {
                eventsDatasource.placeId = newPlace.id
                spinner.activityIndicatorViewStyle = .Gray
                load()
            }
        }
    }
    
    lazy var eventDateFormatter: NSDateFormatter = {
        let dateFormat = NSDateFormatter()
        dateFormat.timeZone =  NSTimeZone.localTimeZone()
        dateFormat.dateFormat = "MMMM dd, yyyy"
       return dateFormat
    }()
    
    var noEventsView = PLEmptyBackgroundView(topText: "No events yet", bottomText: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupBackBarButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.navigationBar.style = .PlaceProfileStyle
    }

    private func setupBackBarButtonItem() {
        let backBarButtonItem = PLBackBarButtonItem()
        backBarButtonItem.didTappedBackButton = { [unowned self] in
            self.navigationController?.popViewControllerAnimated(true)
        }
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -20
        navigationItem.setLeftBarButtonItems([negativeSpacer, backBarButtonItem], animated: false)
    }
    
    private func load() {
        spinner.startAnimating()
        spinner.center = view.center
        collectionView.bounces = false
        eventsDatasource.loadPage {[unowned self] (indices, error) in
            if error == nil {
                if indices.count > 0 {
                    self.noEventsView.hidden = true
                    let newIndexPaths = indices.map({ NSIndexPath(forItem: $0.row, inSection: 1) })
                    self.collectionView?.performBatchUpdates({
                        self.collectionView?.insertItemsAtIndexPaths(newIndexPaths)
                        }, completion: { (complete) in
                            self.collectionView.bounces = true
                    })
                    
                } else if self.eventsDatasource.pagesLoaded == 0 {
                    self.noEventsView.hidden = false
                }
                
            } else {
                PLShowErrorAlert(error: error!)
            }
            self.collectionView.bounces = true
            self.spinner.stopAnimating()
        }
    }
    
    // MARK: - Configure collectionView
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .whiteColor()
        
        collectionView.registerNib(UINib(nibName: PLPlaceProfileHeader.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kStillHeaderIdentifier)
        collectionView.registerNib(UINib(nibName: PLPlaceProfileSectionHeader.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kStickyHeaderIdentifier)
        
        collectionView.registerNib(UINib(nibName: PLPlaceProfileCell.nibName, bundle: nil), forCellWithReuseIdentifier: PLPlaceProfileCell.identifier)
        
        noEventsView.setTopTextColor(UIColor(white: 77))
        self.collectionView.addSubview(noEventsView)
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 44
        var bottomOffset = ((collectionView.bounds.size.height - kCollectionHeaderHeight * 2 - tabBarHeight) / 2 - 26) + kCollectionHeaderHeight * 2
        
        if UIDevice().type == .iPhone4 || UIDevice().type == .iPhone4S {
            bottomOffset -= 50
        }
        
        noEventsView.autoPinEdgeToSuperviewEdge(.Top, withInset: bottomOffset)
        noEventsView.autoAlignAxisToSuperviewAxis(.Vertical)
        noEventsView.hidden = true
    }
    
}


// MARK: - UICollectionViewDataSource

extension PLPlaceProfileViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : eventsDatasource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PLPlaceProfileCell.identifier, forIndexPath: indexPath)
            as! PLPlaceProfileCell
        let event = eventsDatasource[indexPath.row].cellData
        cell.setupWithEventInfo(event, andDateFormatter: eventDateFormatter)
        
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate

extension PLPlaceProfileViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        

        if indexPath.section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStillHeaderIdentifier, forIndexPath: indexPath) as! PLPlaceProfileHeader
            headerView.headerImageView.setImageWithURL(place.picture, placeholderImage: UIImage(named: "place_placeholder"))
            return headerView
        } else {
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStickyHeaderIdentifier, forIndexPath: indexPath) as! PLPlaceProfileSectionHeader
            sectionHeader.placeNameLabel.text    = place.name
            sectionHeader.musicGenresLabel.text  = place.musicGengres
            sectionHeader.closingTimeLabel.text  = place.closeTime
            sectionHeader.placeAddressLabel.text = place.address
            sectionHeader.phoneNumberLabel.text  = place.phone
            sectionHeader.didTappedOrderButton   = { [unowned self] sender in
                
                let orderViewController = self.tabBarController!.getOrderViewController()
                orderViewController.didSelectNewPlace(self.place)
                self.tabBarController?.switchTabTo(TabBarControllerTabs.TabOrder)
            }
            return sectionHeader
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let event = eventsDatasource[indexPath.row].cellData
        let objectsToShare = ["\(place.name) \(eventDateFormatter.stringFromDate(event.date)),\n\(event.info))"]
        let calendarActivity = PLActivity(title: "To calendar", imageName: "icon_calendar") {
            
            let alertView = UIAlertController(title: "Add event to calendar?", message: nil, preferredStyle: .Alert)
            
            let buttonYes = UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
                self.addEventToCalendar(title: self.place.name, description: event.info, startDate: event.date, endDate: event.date.dateByAddingTimeInterval(3600)) { (success, error) in
                    //load slow need fix maybe
                    if error == nil && success == true {
                        self.showAlertWithText("Success", message: "Event added to calendar")
                    } else {
                        print(error?.localizedDescription)
                        self.showAlertWithText("Oops!", message: "Something went wrong")
                    }
                }
            })
            alertView.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
            alertView.addAction(buttonYes)
            self.tabBarController?.present(alertView, animated: true)
        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: [calendarActivity])
        
        tabBarController?.present(activityVC, animated: true)
    }
    
    func showAlertWithText(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        dispatch_async(dispatch_get_main_queue()) {
            self.tabBarController?.presentViewController(alert, animated: true, completion: {
                self.performSelector(.dismissAlert, withObject: alert, afterDelay: 0.7)
            })
        }
    }
    
    func dismissAlert(alert: UIAlertController) {
        alert.dismiss(true)
    }
    
    func addEventToCalendar(title title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.saveEvent(event, span: .ThisEvent)
                } catch let e as NSError {
                    completion?(success: false, error: e)
                    return
                }
                completion?(success: true, error: nil)
            } else {
                completion?(success: false, error: error)
            }
        })
    }

    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == eventsDatasource.count - 1 { load() }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PLPlaceProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(view.frame.size.width, kCollectionHeaderHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.size.width, kCollectionCellHeight)
    }
}
