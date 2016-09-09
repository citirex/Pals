//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLPlacesViewController: PLViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let nibName = "PLPlaceTableViewCell"
    static let cellIdentifier = "PlaceCell"

    private var activityIndicator: UIActivityIndicatorView!
    private var resultsController: UITableViewController!
    private var searchController: UISearchController!
    
    
    lazy var datasource: PLPlacesDatasource = {return PLPlacesDatasource()}()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createActivityIndicator()
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
        datasource.load { [unowned self] page, error in
            if error == nil {
                let count = self.datasource.count
                let lastLoadedCount = page.count
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
    
    
    // MARK: - Alert
    
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
    
    
    // MARK: - Setup Activity Indicator
    
    private func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
//        activityIndicator.hidesWhenStopped = true
        tableView.addSubview(activityIndicator)
        
        addConstraints()
    }
    
    private func addConstraints() {
        tableView.addConstraint(NSLayoutConstraint(item: activityIndicator,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: tableView,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0))
        
        tableView.addConstraint(NSLayoutConstraint(item: activityIndicator,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: tableView,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0))
    }

}



// MARK: - Table view data source

extension PLPlacesViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLPlacesViewController.cellIdentifier, forIndexPath: indexPath)
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
        performSegueWithIdentifier("ShowPlaceProfile", sender: self)
    }

}


// MARK: - Table view delegate

extension PLPlacesViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == datasource.count - 1 {
            activityIndicator.startAnimating()
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