//
//  PLSearchableViewController.swift
//  Pals
//
//  Created by ruckef on 19.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import DZNEmptyDataSet

class PLSearchableViewController: PLViewController {
    
    lazy var resultsController: UITableViewController! = {
        let rc = UITableViewController(style: .Plain)
        rc.tableView.backgroundColor        = .affairColor()
        rc.tableView.tableFooterView        = UIView()
        rc.tableView.rowHeight              = 128.0
        return rc
    }()
    var searchController: PLSearchController!
    
    func configureSearchController
        <T where T: UISearchResultsUpdating>
        (placeholder: String, tableView: UITableView, responder: T) {
        searchController = PLSearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder     = placeholder
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor       = .whiteColor()
        searchController.searchBar.barTintColor    = .affairColor()
        searchController.searchResultsUpdater      = responder

        tableView.tableHeaderView                  = searchController.searchBar
        tableView.backgroundView                   = UIView()
        definesPresentationContext                 = true
    }
        
    func configureResultsController
        <T where T : UITableViewDataSource, T: UITableViewDelegate, T: DZNEmptyDataSetSource, T: DZNEmptyDataSetDelegate>
        (cellNib: String, cellIdentifier: String, responder: T) {
        let nib = UINib(nibName: cellNib, bundle: nil)
        resultsController.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        resultsController.tableView.dataSource             = responder
        resultsController.tableView.delegate               = responder
        resultsController.tableView.emptyDataSetSource     = responder
        resultsController.tableView.emptyDataSetDelegate   = responder
    }

    func searchDidChange(text: String, active: Bool) {} // to override
}

extension PLSearchableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            searchDidChange(text, active: searchController.active)
        }
    }
}
