//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PLPlacesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let nibName = "PLPlaceTableViewCell"
    static let cellIdentifier = "PlaceCell"

    private var resultsController: UITableViewController!
    private var searchController: UISearchController!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var region: (center: CLLocation, radius: Double)!
    
    //    var places: [PLPlace]!
    //    var filteredPlaces: [PLPlace]!
    
    var places: [String] = [
        "One",
        "Two",
        "Three",
        "Four",
        "Five",
        "Six",
        "Seven",
        "Eight",
        "Nine"
    ]
    
    var filteredPlaces: [String] = [
        "One",
        "Two",
        "Three",
        "Four",
        "Five",
        "Six",
        "Seven",
        "Eight",
        "Nine"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationService()
        configureSearchController()
        
        let nib = UINib(nibName: PLPlacesViewController.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlacesViewController.cellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func setupLocationService() {
        locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else { return showAlert() }
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - Initialize search controller
    
    func configureSearchController() {
        let nib = UINib(nibName: PLPlacesViewController.nibName, bundle: nil)
        resultsController = UITableViewController(style: .Grouped)
        resultsController.tableView.registerNib(nib, forCellReuseIdentifier: PLPlacesViewController.cellIdentifier)
        resultsController.tableView.rowHeight = 110.0
        resultsController.tableView.dataSource = self
//        resultsController.tableView.delegate = self
        
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
    
    
//    let regionRadius: CLLocationDistance = 1000
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
//        let mapView = MKMapView()
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
    
//    func coordinateRegionWithCenter(center: CLLocation) -> (location: CLLocation, region: CLLocation) {
//
//        return (currentLocation, region)
//    }

    
}


extension PLPlacesViewController: UITableViewDataSource {

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView === self.tableView ? places.count : filteredPlaces.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLPlacesViewController.cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        //        let place = searchController.active ? filteredPlaces[indexPath.row] : places[indexPath.row]
        //        if let cell = cell as? PLPlaceTableViewCell {
        //
        //        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ShowPlaceProfile", sender: self)
    }

}


// MARK: - UISearchResultsUpdating

extension PLPlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //        if let searchText = searchController.searchBar.text {
        //            filteredPlaces = searchText.isEmpty ? places : places.filter {
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


