//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import DZNEmptyDataSet

class PLPlacesViewController: PLSearchableViewController {
    
    @IBOutlet var tableView: UITableView!
    private var searchPlace: String!
    lazy var places: PLPlacesDatasource = { return PLPlacesDatasource() }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureResultsController(PLPlaceCell.nibName, cellIdentifier: PLPlaceCell.identifier, responder: self)
        configureSearchController("Find a Place", tableView: tableView, responder: self)
        tableView.hideSearchBar()
        let nib = UINib(nibName: PLPlaceCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceCell.identifier)
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.style = .PlacesStyle
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        places.cancel()
    }
    
    // MARK: - Private Methods
    
    func loadData() {
        startActivityIndicator(.WhiteLarge)
        places.loadPage {[unowned self] (indices, error) in
            self.stopActivityIndicator()
            self.didLoadPage(self.tableView, indices: indices, error: error)
        }
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
    
    func hideSearchBar() {
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
    }
    
    override func searchDidChange(text: String, active: Bool) {
        searchPlace = text
        places.searching = active
        if text.isEmpty {
            places.searching = false
        } else {
            startActivityIndicator(.WhiteLarge)
            places.filter(text, completion: { [unowned self] in
                self.stopActivityIndicator()
                self.resultsController.tableView.reloadEmptyDataSet()
                self.resultsController.tableView.reloadData()
            })
        }
    }
}

// MARK: - Table view data source
    
extension PLPlacesViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = places.count
        return count
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
}

// MARK: - Table view delegate

extension PLPlacesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if places.shouldLoadNextPage(indexPath) { loadData() }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let place = places[indexPath.row]
        performSegueWithIdentifier(SegueIdentifier.PlaceProfileSegue, sender: place)
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
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return !places.loading
    }
}