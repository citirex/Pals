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
private let kPLEventCellMinHeight: CGFloat = 130


class PLPlaceProfileViewController: PLViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var noEventsView = PLEmptyBackgroundView(topText: "No events yet", bottomText: nil)
    
    private lazy var eventDateFormatter: NSDateFormatter = {
        let dateFormat = NSDateFormatter()
        dateFormat.timeZone =  NSTimeZone.localTimeZone()
        dateFormat.dateFormat = "MMMM dd, yyyy"
        return dateFormat
    }()
    
    private lazy var events: PLEventsDatasource = {
        let eventsDatasource = PLEventsDatasource()
        eventsDatasource.placeId = self.place.id
        return eventsDatasource }()
    
    var place: PLPlace!
    
    lazy var sizingCell: PLEventCell = {
        let objects = NSBundle.mainBundle().loadNibNamed(PLEventCell.nibName(), owner: PLEventCell.self, options: nil) as! [UIView]
        let cell = objects.first as! PLEventCell
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupBackBarButtonItem()
        loadEvents()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.style = .PlaceProfileStyle
    }

    private func setupBackBarButtonItem() {
        let backBarButtonItem = PLBackBarButtonItem()
        backBarButtonItem.didTapBackButton = { [unowned self] in
            self.navigationController?.popViewControllerAnimated(true)
        }
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -20
        navigationItem.setLeftBarButtonItems([negativeSpacer, backBarButtonItem], animated: false)
    }
    
    private func loadEvents() {
        collectionView.bounces = false
        
        if collectionView.contentOffset == CGPointZero {
            startActivityIndicator(.WhiteLarge, color: .grayColor(), position: .Bottom)
        } else {
            startActivityIndicator(.WhiteLarge, color: .grayColor())
        }
        
        events.loadPage { [unowned self] indices, error in
            self.stopActivityIndicator()
            
            if error == nil {
                if indices.count > 0 {
                    self.noEventsView.hidden = true
                    let newIndexPaths = indices.map { NSIndexPath(forItem: $0.row, inSection: 1) }
                    self.collectionView?.performBatchUpdates({
                        self.collectionView?.insertItemsAtIndexPaths(newIndexPaths)
                        }, completion: { complete in
                            self.collectionView.bounces = true
                    })
                } else if self.events.pagesLoaded == 0 {
                    self.noEventsView.hidden = false
                }
            } else {
                PLShowErrorAlert(error: error!)
            }
            self.collectionView.bounces = true
        }
    }

    
    // MARK: - Configure collectionView
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .whiteColor()
        
        collectionView.registerNib(UINib(nibName: PLPlaceProfileHeader.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kStillHeaderIdentifier)
        collectionView.registerNib(UINib(nibName: PLPlaceProfileSectionHeader.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kStickyHeaderIdentifier)
        
        collectionView.registerCell(PLEventCell)
        
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
    
    func switchToOrderWithPlace(place: PLPlace?, event: PLEvent?) {
        if place != nil {
            tabBarController?.switchTabBarItemTo(.OrderItem) {
                let notifObj = PLPlaceEventNotification(place: place!, event: event)
                PLNotifications.postNotification(.PlaceDidSelect, object: notifObj)
            }
        } else {
            PLLog("No place is set")
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PLPlaceProfileViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : events.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PLEventCell.self, forIndexPath: indexPath) as! PLEventCell
        cell.delegate = self
        let event = events[indexPath.row]
        cell.updateWithEvent(event)
        return cell
    }
}

extension PLPlaceProfileViewController : PLEventCellDelegate {
    func eventCell(cell: PLEventCell, didClickBuyEvent event: PLEvent) {
        switchToOrderWithPlace(place, event: event)
    }
}

// MARK: - UICollectionViewDelegate

extension PLPlaceProfileViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStillHeaderIdentifier, forIndexPath: indexPath) as! PLPlaceProfileHeader
            let placeholderImage = UIImage(named: "place_placeholder")
            if let picture = place.picture {
                headerView.headerImageView.setImageWithURL(picture, placeholderImage: placeholderImage)
            } else {
                headerView.headerImageView.image = placeholderImage
            }
            return headerView
        } else {
            let sectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kStickyHeaderIdentifier, forIndexPath: indexPath) as! PLPlaceProfileSectionHeader
            sectionHeader.place = place
            sectionHeader.didTapOrderButton  = { [unowned self] sender in
                self.switchToOrderWithPlace(self.place, event: nil)
            }
            return sectionHeader
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let event = events[indexPath.row]
        let objectsToShare = ["\(place.name) \(eventDateFormatter.stringFromDate(event.start)),\n\(event.info))"]
        let calendarActivity = PLActivity(title: "To calendar", imageName: "icon_calendar") {
            
            let alertView = UIAlertController(title: "Add event to calendar?", message: nil, preferredStyle: .Alert)
            
            let buttonYes = UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
                self.addEventToCalendar(title: self.place.name, description: event.info, startDate: event.start, endDate: event.end) { (success, error) in
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
        if events.shouldLoadNextPage(indexPath) { loadEvents() }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PLPlaceProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(view.frame.size.width, kCollectionHeaderHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let event = events[indexPath.row]
        let cell = sizingCell
        cell.updateWithEvent(event)
        let minSize = CGSizeMake(collectionView.frame.width, kPLEventCellMinHeight)
        let size = cell.compressedLayoutSizeFittingMinimumSize(minSize)
        return size
    }
}
