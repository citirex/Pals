//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLPlacesViewController: PLViewController {
    
    @IBOutlet var tableView: UITableView!
   
    private let nib = UINib(nibName: PLPlaceCell.nibName, bundle: nil)
    private var activityIndicator: UIActivityIndicatorView!
    private var resultsController: UITableViewController!
    private var searchController: PLSearchController!
    private var selectedPlace: PLPlace!
    private var previousFilter = ""
    
    lazy var places: PLPlacesDatasource = { return PLPlacesDatasource() }()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureResultsController()
        configureSearchController()
        configureActivityIndicator()
        
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceCell.identifier)

        loadPlaces()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.style = .PlacesStyle
    }
    
    
    // MARK: - Private Methods
    
    private func loadPlaces() {
        activityIndicator.startAnimating()
        places.loadPage { [unowned self] indexPaths, error in
            self.activityIndicator.stopAnimating()
            guard error == nil else { return PLShowErrorAlert(error: error!) }
            self.tableView?.beginUpdates()
            self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
            self.tableView?.endUpdates()
        }
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    
    private func configureResultsController() {
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceCell.identifier)
        resultsController.tableView.backgroundColor = .affairColor()
        resultsController.tableView.tableFooterView = UIView()
        resultsController.tableView.backgroundView  = UIView()
        resultsController.tableView.rowHeight       = 128.0
        resultsController.tableView.dataSource      = self
        resultsController.tableView.delegate        = self
    }

    

    // MARK: - Initialize Search Controller
    
    private func configureSearchController() {
        searchController = PLSearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder     = "Find a Place"
        searchController.searchBar.barTintColor    = .affairColor()
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor       = .whiteColor()
        searchController.searchResultsUpdater      = self
        searchController.delegate                  = self
        tableView.tableHeaderView                  = searchController.searchBar
        tableView.backgroundView                   = UIView()
        definesPresentationContext                 = true
    }
    

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = SegueIdentifier(rawValue: segue.identifier!) else { return }
        switch identifier {
        case .PlaceProfileSegue:
            let placeProfileViewController = segue.destinationViewController as! PLPlaceProfileViewController
            placeProfileViewController.place = selectedPlace
        default: break
        }
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


// MARK: - UISearchControllerDelegate

extension PLPlacesViewController: UISearchControllerDelegate {
    
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
        let text = searchController.searchBar.text!
        if text.isEmpty { places.searching = false }
        else {
            activityIndicator.startAnimating()
            places.filter(text, completion: { [unowned self] in
                self.resultsController.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.resultsController.tableView.reloadData()
            })
        }
    }
    
}