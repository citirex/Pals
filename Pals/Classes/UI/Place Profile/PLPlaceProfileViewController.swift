//
//  PLPlaceProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/7/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CSStickyHeaderFlowLayout
import EventKit


class PLPlaceProfileViewController: PLViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var layout: CSStickyHeaderFlowLayout? {
        return collectionView?.collectionViewLayout as? CSStickyHeaderFlowLayout
    }
    
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
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadLayout()
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
        eventsDatasource.loadPage { (indices, error) in
            if error == nil {
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.insertItemsAtIndexPaths(indices)
                    }, completion: nil)
                
            } else {
                PLShowErrorAlert(error: error!)
            }
            self.spinner.stopAnimating()
        }
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
        layout!.parallaxHeaderReferenceSize = CGSizeMake(view.frame.size.width, 278.0)
        layout!.parallaxHeaderMinimumReferenceSize = CGSizeMake(view.frame.size.width, 80.0)
        layout!.parallaxHeaderAlwaysOnTop = true
        layout!.disableStickyHeaders = false
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = SegueIdentifier(rawValue: segue.identifier!) else { return }
        switch identifier {
        case .OrderSegue:
            let orderViewController = segue.destinationViewController as! PLOrderViewController
            orderViewController.order.place = place
        default: break
        }
    }
    
}


// MARK: - UICollectionViewDataSource

extension PLPlaceProfileViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsDatasource.count
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
        
        switch kind {
        case CSStickyHeaderParallaxHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PLPlaceProfileHeader.identifier, forIndexPath: indexPath) as! PLPlaceProfileHeader
            headerView.headerImageView.setImageWithURL(place.picture)
            return headerView
        case UICollectionElementKindSectionHeader:
            let sectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PLPlaceProfileSectionHeader.identifier, forIndexPath: indexPath) as! PLPlaceProfileSectionHeader
            sectionHeader.placeNameLabel.text    = place.name
            sectionHeader.musicGenresLabel.text  = place.musicGengres
            sectionHeader.closingTimeLabel.text  = place.closeTime
            sectionHeader.placeAddressLabel.text = place.address
            sectionHeader.phoneNumberLabel.text  = place.phone
            sectionHeader.didTappedOrderButton   = { [unowned self] sender in
                self.performSegueWithIdentifier(SegueIdentifier.OrderSegue, sender: sender)
            }
            return sectionHeader
        default:
            assert(false, "Unsupported supplementary view kind")
            return UICollectionReusableView()
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
        return CGSizeMake(view.frame.size.width, 188)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.size.width, 115)
    }
    
}
