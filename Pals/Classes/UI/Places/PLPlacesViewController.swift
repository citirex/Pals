//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLSearchController: UISearchController {

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}


class PLPlacesViewController: PLViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    private var resultsController: UITableViewController!
    private var searchController: PLSearchController!
    private var activityIndicator: UIActivityIndicatorView!
    
    private lazy var places: PLPlacesDatasource = { return PLPlacesDatasource() }()
    private var filteredPlaces: [PLPlace]!
    private var selectedPlace: PLPlace!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        configureActivityIndicator()
        view.addSubview(activityIndicator)
        tableView.backgroundView = UIView()
        
        let nib = UINib(nibName: PLPlaceTableViewCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceTableViewCell.identifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPage()
        configureNavigationBar()
    }
    
 
    private func loadPage() {
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
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
            cell.place = place
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
        if indexPath.row == places.count - 1 {
            loadPage()
        }
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

