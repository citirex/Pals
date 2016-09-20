//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLPlacesViewController: PLViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    private var activityIndicator: UIActivityIndicatorView!
    private var resultsController: UITableViewController!
    private var searchController: PLSearchController!
    
    private lazy var places: PLPlacesDatasource = { return PLPlacesDatasource() }()
    private var selectedPlace: PLPlace!
    private var previousFilter = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        configureActivityIndicator()
        view.addSubview(activityIndicator)
        tableView.backgroundView = UIView()
        
        let nib = UINib(nibName: PLPlaceTableViewCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceTableViewCell.identifier)
        
        loadPlaces()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicator.center = view.center
        configureNavigationBar()
    }
 
    private func loadPlaces() {
        activityIndicator.startAnimating()
        places.load { places, error in
            if error == nil {
                let count = self.places.count
                let lastLoadedCount = places.count
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
    
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.hidesWhenStopped = true
    }
    
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.barTintColor = .affairColor()
        navigationController?.hideTransparentNavigationBar()
    }
    
    
    // MARK: - Initialize search controller
    
    private func configureSearchController() {
        let nib = UINib(nibName: PLPlaceTableViewCell.nibName, bundle: nil)
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceTableViewCell.identifier)
        resultsController.tableView.backgroundColor = .affairColor()
        resultsController.tableView.tableFooterView = UIView()
        resultsController.tableView.backgroundView = UIView()
        resultsController.tableView.rowHeight = 110.0
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        searchController = PLSearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder = "Find a Place"
        searchController.searchBar.barTintColor = .affairColor()
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = .whiteColor()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
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
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLPlaceTableViewCell.identifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let place = places[indexPath.row]
        if let cell = cell as? PLPlaceTableViewCell {
            cell.cellData = place.cellData
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedPlace = places[indexPath.row]
        performSegueWithIdentifier("ShowPlaceProfile", sender: self)
    }

}

// MARK: - Table view delegate

extension PLPlacesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if places.shouldLoadNextPage(indexPath) { loadPlaces() }
    }
    
}

// MARK: - UISearchControllerDelegate

extension PLPlacesViewController : UISearchControllerDelegate {
    func willDismissSearchController(searchController: UISearchController) {
        let offset = tableView.contentOffset.y + tableView.contentInset.top
        if offset >= searchController.searchBar.frame.height {
            UIView.animateWithDuration(0.25) {
                searchController.searchBar.alpha = 0
            }
        }
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        if searchController.searchBar.alpha == 0 {
            UIView.animateWithDuration(0.25) {
                searchController.searchBar.alpha = 1
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension PLPlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        places.searching = searchController.active
        let filter = searchController.searchBar.text!
        if filter.isEmpty {
            places.searching = false
        } else {
            activityIndicator.startAnimating()
            places.filter(filter, completion: { [unowned self] in
                self.resultsController.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }
    }
}

