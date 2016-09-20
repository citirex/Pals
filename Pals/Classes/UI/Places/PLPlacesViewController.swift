//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class SearchController: UISearchController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
}


class PLPlacesViewController: PLViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    private var resultsController: UITableViewController!
    private var searchController: SearchController!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
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
        
        tableView.backgroundColor = .affairColor()
        
        let nib = UINib(nibName: PLPlaceTableViewCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceTableViewCell.identifier)
        tableView.contentOffset = CGPointMake(0, searchController.searchBar.frame.size.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.barTintColor = .affairColor()
        navigationController?.hideTransparentNavigationBar()
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
        resultsController.tableView.backgroundColor = .affairColor()
        resultsController.childViewControllerForStatusBarStyle()
        resultsController.tableView.rowHeight = 150.0
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        searchController = SearchController(searchResultsController: resultsController)
        searchController.searchBar.barTintColor = .affairColor()
        searchController.searchBar.tintColor = .whiteColor()
        searchController.searchResultsUpdater = self
    
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
            cell.cellData = place.cellData
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