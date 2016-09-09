//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation.CLLocation

class PLPlacesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let nibName = "PLPlaceTableViewCell"
    static let cellIdentifier = "PlaceCell"

    private var resultsController: UITableViewController!
    private var searchController: UISearchController!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var region: (center: CLLocation, radius: Double)!
    
    
    lazy var datasource: PLPlacesDatasource = { return PLPlacesDatasource() }()
  
    var places = [PLPlace]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setupLocationService()
        configureSearchController()
        
        let nib = UINib(nibName: PLPlacesViewController.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlacesViewController.cellIdentifier)
        loadPage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func loadPage() {
        activityIndicator.startAnimating()
        datasource.load { page, error in
            if error == nil {
                self.tableView.beginUpdates()
                for index in 0..<page.count {
                    self.places.append(page[index] as! PLPlace)
                    let paths = [NSIndexPath(forRow: index, inSection: 0)]
                    self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic)
                }
                self.tableView.endUpdates()
                self.activityIndicator.stopAnimating()
            } else {
                // show error
            }
        }
    }
    
    func setupLocationService() {
        locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else { return showAlert() }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - Initialize search controller
    
    func configureSearchController() {
        let nib = UINib(nibName: PLPlacesViewController.nibName, bundle: nil)
        resultsController = UITableViewController(style: .Grouped)
        resultsController.tableView.registerNib(nib, forCellReuseIdentifier: PLPlacesViewController.cellIdentifier)
        resultsController.tableView.rowHeight = 110.0
        resultsController.tableView.dataSource = self
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: "Background Location Access Disabled",
            message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { action in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        presentViewController(alertController, animated: true, completion: nil)
    }


    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPlaceProfile" {
            let placeProfileViewController = segue.destinationViewController as! PLPlaceProfileViewController
            placeProfileViewController.title = ""
        }
    }
    
}


// MARK: - Table view data source

extension PLPlacesViewController: UITableViewDataSource {

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLPlacesViewController.cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let place = places[indexPath.row]
        if let cell = cell as? PLPlaceTableViewCell {
            cell.backgroundImageView.image = UIImage(data: NSData(contentsOfURL: place.picture)!)
            cell.placeNameLabel.text = place.name
            cell.placeAddressLabel.text = place.address
            cell.musicGenresLabel.text = place.musicGengres
//            cell.distanceLabel.text = place.distance
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ShowPlaceProfile", sender: self)
    }

}

// MARK: - Table view delegate

extension PLPlacesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
   
    }
    
}


// MARK: - UISearchResultsUpdating

extension PLPlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text {
//            filteredPlaces = searchText.isEmpty ? datasource : datasource.filter {
//                $0.name!.rangeOfString(searchText, options: [.CaseInsensitiveSearch, .AnchoredSearch]) != nil
//            }
//            resultsController.tableView.reloadData()
//        }
    }
}

// MARK: - CLLocationManagerDelegate

extension PLPlacesViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            manager.startUpdatingLocation()
        case .NotDetermined:
            manager.requestAlwaysAuthorization()
        case .AuthorizedWhenInUse, .Restricted, .Denied:
            showAlert()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        if currentLocation == nil {
            currentLocation = location
            manager.stopUpdatingLocation()
        } else if currentLocation == location {
            manager.stopUpdatingLocation()
        } else {
            currentLocation = location
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Can't get your location!")
    }

}


