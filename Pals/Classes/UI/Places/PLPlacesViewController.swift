//
//  PLPlacesViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import DZNEmptyDataSet

class PLPlacesViewController: PLSearchableViewController {
    
    let nib = UINib(nibName: PLPlaceCell.nibName, bundle: nil)
    
    private var placeView: PLTableView! { return view as! PLTableView }
    
    lazy var places: PLPlacesDatasource = { return PLPlacesDatasource() }()
    
    private lazy var tableView: UITableView! = {
        let tableView = self.placeView.tableView
        tableView.backgroundColor = .affairColor()
        tableView.backgroundView  = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight  = 128
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.emptyDataSetSource   = self
        tableView.emptyDataSetDelegate = self
        return tableView
    }()
    
    private lazy var downtimer = PLDowntimer()
    
    override func loadView() {
        view = PLTableView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = .affairColor()
        placeView.configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureResultsController(PLPlaceCell.nibName, cellIdentifier: PLPlaceCell.identifier, responder: self)
        configureSearchController("Find a Place", tableView: tableView, responder: self)
        tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceCell.identifier)
        
		searchController.isFriends = false

        tableView.hideSearchBar()

        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .PlacesStyle
    }

    private var didSetupConstraints = false
    override func updateViewConstraints() {
        if !didSetupConstraints {
            tableView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
            tableView.autoPinToBottomLayoutGuideOfViewController(self, withInset: 0)
            tableView.autoPinEdgeToSuperviewEdge(.Leading)
            tableView.autoPinEdgeToSuperviewEdge(.Trailing)
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        places.cancel()
    }
    
    
    // MARK: - Private Methods
    
    func loadData() {
        loadData(places) { [unowned self] Void -> UITableView in
            return self.places.searching ? self.resultsController.tableView : self.tableView
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
    
    override func searchDidChange(text: String, active: Bool) {
        PLLog("Search active: \(active)")
        PLLog("Search text: \(text)")
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
        cell.backgroundColor = .clearColor()
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