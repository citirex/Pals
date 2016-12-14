//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import DZNEmptyDataSet

protocol PLPlacesViewControllerDelegate: class {
    func didSelectPlace(controller: PLPlacesViewController, place: PLPlace)
}

class PLPlacesViewController: PLViewController {
    
    private let nib = UINib(nibName: PLPlaceCell.nibName, bundle: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarContainer: UIView!
    
    lazy var places: PLPlacesDatasource = { return PLPlacesDatasource() }()
    private lazy var downtimer = PLDowntimer()

    private var searchController: PLSearchController!
    private var resultsController: UITableViewController!
    
    weak var delegate: PLPlacesViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureResultsController()
        configureSearchController()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceCell.reuseIdentifier)
        
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .PlacesStyle
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        places.cancel()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = SegueIdentifier(rawValue: segue.identifier!) else { return }
        switch identifier {
        case .PlaceProfileSegue:
            if let placeProfileViewController = segue.destinationViewController as? PLPlaceProfileViewController {
                if let place = sender as? PLPlace {
                    placeProfileViewController.place = place
                }
            }
        default:
            break
        }
    }
    
    
    // MARK: - Private Methods
    
    private func loadData() {
		startActivityIndicator(.WhiteLarge, color: .whiteColor())
        loadData(places) { [unowned self] Void -> UITableView in
			self.stopActivityIndicator()
            return self.places.searching ? self.resultsController.tableView : self.tableView
        }
    }
    
    private func configureResultsController() {
        resultsController = UITableViewController(style: .Plain)
        resultsController.tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceCell.reuseIdentifier)
        resultsController.tableView.rowHeight = tableView.rowHeight
        resultsController.tableView.backgroundColor = .affairColor()
        resultsController.tableView.tableFooterView = UIView()
        
        resultsController.tableView.dataSource           = self
        resultsController.tableView.delegate             = self
        resultsController.tableView.emptyDataSetSource   = self
        resultsController.tableView.emptyDataSetDelegate = self
    }
    
    private func configureSearchController() {
        searchController = PLSearchController(searchResultsController: resultsController)
        searchController.searchBar.textField?.tintColor = .affairColor()
        searchController.searchBar.barTintColor = .affairColor()
        searchController.searchBar.tintColor = .whiteColor()
        searchController.searchResultsUpdater = self
        
        searchBarContainer.addSubview(searchController.searchBar)
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    }

    
}


// MARK: - Table view data source
    
extension PLPlacesViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLPlaceCell.reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLPlaceCell else { return }
        let place = places[indexPath.row]
        let cellData = place.cellData
        cell.placeCellData = cellData
        cell.chevron.hidden = delegate != nil
    }
    
}


// MARK: - Table view delegate

extension PLPlacesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if places.shouldLoadNextPage(indexPath) { loadData() }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let place = places[indexPath.row]
    
        guard delegate == nil else { return delegate!.didSelectPlace(self, place: place) }
        performSegueWithIdentifier(SegueIdentifier.PlaceProfileSegue, sender: place)
    }
    
}


// MARK: - UISearchResultsUpdating

extension PLPlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            places.searchFilter = text
            if text.isEmpty {
                places.searchFilter = nil
            } else {
                downtimer.wait { [unowned self] in
                    PLLog("Searched text: \(text)")
                    self.loadData()
                    
                    self.resultsController.tableView.reloadData()
                    self.resultsController.tableView.reloadEmptyDataSet()
                }
            }
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
        let string = scrollView === tableView ? "No data" : "No places were found that match '\(searchController.searchBar.text!)'"
        let attributedString = NSAttributedString(string: string, font: .systemFontOfSize(18), color: .lightGrayColor())
        return attributedString
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        let named = scrollView === tableView ? "location_placeholder" : "search"
        return UIImage(named: named)!.imageResize(CGSizeMake(100, 100))
    }
    
}


// MARK: - DZNEmptyDataSetDelegate

extension PLPlacesViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        if !places.loading && places.empty { tableView.contentOffset = CGPointZero }
        return !places.loading
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
}