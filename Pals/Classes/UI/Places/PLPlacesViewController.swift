//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLPlacesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let nibName = "PLPlaceTableViewCell"
    static let cellIdentifier = "PlaceCell"

    private var resultsController: UITableViewController!
    private var searchController: UISearchController!
    
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
        
        configureSearchController()
        
        let nib = UINib(nibName: PLPlacesViewController.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlacesViewController.cellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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


    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPlaceProfile" {
            let placeProfileViewController = segue.destinationViewController as! PLPlaceProfileViewController
            placeProfileViewController.title = ""
        }
    }

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


