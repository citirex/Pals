//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import DZNEmptyDataSet

class PLPlacesViewController: PLViewController {
    
    @IBOutlet var tableView: UITableView!
   
    private let nib = UINib(nibName: PLPlaceCell.nibName, bundle: nil)
    private var resultsController: UITableViewController!
    private var searchController: PLSearchController!
    private var selectedPlace: PLPlace!
    private var previousFilter = ""
    private var searchPlace: String!
    private var isLoading = false
    
    lazy var places: PLPlacesDatasource = { return PLPlacesDatasource() }()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureResultsController()
        configureSearchController()
        
        tableView.hideSearchBar()
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceCell.identifier)
        
        loadPlaces()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.style = .PlacesStyle
    }

    
    // MARK: - Private Methods
    
    private func loadPlaces() {
        isLoading = true
        startActivityIndicator(.WhiteLarge)
        tableView.reloadEmptyDataSet()
        
        places.loadPage { [unowned self] indexPaths, error in
            self.isLoading = false
            self.stopActivityIndicator()
            
            guard error == nil else {
                self.tableView.reloadEmptyDataSet()
                self.tableView.tableHeaderView = nil
                return PLShowErrorAlert(error: error!)
            }
            self.tableView?.beginUpdates()
            self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
            self.tableView?.endUpdates()
        }
    }
    
    private func configureResultsController() {
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceCell.identifier)
        resultsController.tableView.backgroundColor        = .affairColor()
        resultsController.tableView.tableFooterView        = UIView()
        resultsController.tableView.rowHeight              = 128.0
        resultsController.tableView.dataSource             = self
        resultsController.tableView.delegate               = self
        resultsController.tableView.emptyDataSetSource     = self
        resultsController.tableView.emptyDataSetDelegate   = self
    }

    
    // MARK: - Initialize Search Controller
    
    private func configureSearchController() {
        searchController = PLSearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder     = "Find a Place"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor       = .whiteColor()
        searchController.searchBar.barTintColor    = .affairColor()
        searchController.searchResultsUpdater      = self
        
        tableView.tableHeaderView                  = searchController.searchBar
        tableView.backgroundView                   = UIView()
        
        definesPresentationContext = true
    }
    

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = SegueIdentifier(rawValue: segue.identifier!) else { return }
        switch identifier {
        case .PlaceProfileSegue:
            let placeProfileViewController = segue.destinationViewController as! PLPlaceProfileViewController
            placeProfileViewController.place = selectedPlace
        default:
            break
        }
    }
    
    func hideSearchBar() {
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
    }

}


// MARK: - Table view data source
    
extension PLPlacesViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLPlaceCell.identifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLPlaceCell else { return }
        let place = places[indexPath.row]
        cell.placeCellData = place.cellData
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedPlace = places[indexPath.row]
        performSegueWithIdentifier(SegueIdentifier.PlaceProfileSegue, sender: self)
    }

}


// MARK: - Table view delegate

extension PLPlacesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if places.shouldLoadNextPage(indexPath) { loadPlaces() }
    }
    
}


// MARK: - UISearchResultsUpdating

extension PLPlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        places.searching = searchController.active
        searchPlace = searchController.searchBar.text!
        
        if searchPlace.isEmpty {
            places.searching = false
        } else {
            startActivityIndicator(.WhiteLarge)
            places.filter(searchPlace, completion: { [unowned self] in
                self.resultsController.tableView.reloadData()
                self.stopActivityIndicator()
                self.resultsController.tableView.reloadData()
            })
        }
    }
    
}


// MARK: - DZNEmptyDataSetSource

extension PLPlacesViewController: DZNEmptyDataSetSource {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let string = scrollView === tableView ? "Places list" : "No results found"
        let attributedString = NSAttributedString(string: string, font: .boldSystemFontOfSize(20), color: .lightGrayColor())
        return attributedString
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let string = scrollView === tableView ? "No data" : "No places were found that match '\(searchPlace)'"
        let attributedString = NSAttributedString(string: string, font: .systemFontOfSize(18), color: .lightGrayColor())
        return attributedString
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        let named = scrollView === tableView ? "place_pin_placeholder" : "search"
        return UIImage(named: named)!.imageResize(CGSizeMake(100, 100))
    }

}


// MARK: - DZNEmptyDataSetDelegate

extension PLPlacesViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return !isLoading
    }
    
}


