//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLPlacesViewController: PLViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    private var resultsController: UITableViewController!
    private var searchController: UISearchController!
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .grayColor()
        self.tableView.addSubview(activityIndicator)
        activityIndicator.addConstraintCentered()
        return activityIndicator
    }()
    
    lazy var datasource: PLPlacesDatasource = { return PLPlacesDatasource() }()
    private var selectedPlace: PLPlace!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPage()
        configureSearchController()
        
        let nib = UINib(nibName: PLPlaceTableViewCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceTableViewCell.identifier)
    }
    
    
    private func loadPage() {
        activityIndicator.startAnimating()
        datasource.load { [unowned self] pages, error in
            if error == nil {
                let count = self.datasource.count
                let lastLoadedCount = pages.count
                if lastLoadedCount > 0 {
                    var indexPaths = [NSIndexPath]()
                    for i in count - lastLoadedCount..<count {
                        indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
                    }
                    self.tableView?.beginUpdates()
                    self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
                    self.tableView?.endUpdates()
                }
                self.activityIndicator.stopAnimating()
            } else {
                PLShowErrorAlert(error: error!)
            }
        }
    }
    
    
    // MARK: - Initialize search controller
    
    private func configureSearchController() {
        let nib = UINib(nibName: PLPlaceTableViewCell.nibName, bundle: nil)
        resultsController = UITableViewController(style: .Grouped)
        resultsController.tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceTableViewCell.identifier)
        resultsController.tableView.rowHeight = 110.0
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = mainColor
        searchController.searchBar.tintColor = .whiteColor()
        
        tableView.backgroundView = UIView()
        tableView.tableHeaderView = searchController.searchBar

        definesPresentationContext = true
    }
    

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPlaceProfile" {
            let placeProfileViewController = segue.destinationViewController as! PLPlaceProfileViewController
            placeProfileViewController.place = selectedPlace
        }
    }
    
}


// MARK: - Table view data source

extension PLPlacesViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLPlaceTableViewCell.identifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let place = datasource[indexPath.row]
        if let cell = cell as? PLPlaceTableViewCell {
            cell.place = place
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedPlace = datasource[indexPath.row]
        performSegueWithIdentifier("ShowPlaceProfile", sender: self)
    }

}


// MARK: - Table view delegate

extension PLPlacesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == datasource.count - 1 {
            loadPage()
        }
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