//
//  PLSearchableViewController.swift
//  Pals
//
//  Created by ruckef on 19.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import DZNEmptyDataSet

class PLSearchableViewController: PLViewController {
    
    var interfaceColor = UIColor.violetColor
    
    var searchController: PLSearchController!
    
    lazy var resultsController: UITableViewController! = {
        let rc = UITableViewController(style: .Plain)
        rc.tableView.backgroundColor = self.interfaceColor
        rc.tableView.tableFooterView = UIView()
        return rc
    }()

    
    func configureSearchController
        <T where T: UISearchResultsUpdating>
        (placeholder: String, tableView: UITableView, responder: T) {
        searchController = PLSearchController(searchResultsController: resultsController)
		searchController.searchBar.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
        resultsController.tableView.rowHeight      = tableView.rowHeight
        searchController.searchBar.tintColor       = .whiteColor()
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.backgroundColor = interfaceColor
        searchController.searchBar.barTintColor    = interfaceColor
        searchController.searchBar.placeholder     = placeholder
        searchController.searchResultsUpdater      = responder
        tableView.tableHeaderView                  = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    func configureResponder<T, N : UITableViewCell where T: UITableViewDataSource, T : UITableViewDelegate, T : DZNEmptyDataSetSource, T : DZNEmptyDataSetDelegate, N : PLReusableCell>
        (responder: T, withCellType cellType: N.Type)
    {
        resultsController.tableView.dataSource           = responder
        resultsController.tableView.delegate             = responder
        resultsController.tableView.emptyDataSetSource   = responder
        resultsController.tableView.emptyDataSetDelegate = responder
        resultsController.tableView.registerCell(cellType)
    }
    
    func configureResultsController
        <T where T : UITableViewDataSource, T: UITableViewDelegate, T: DZNEmptyDataSetSource, T: DZNEmptyDataSetDelegate>
        (cellNib: String, cellIdentifier: String, responder: T) {
        let nib = UINib(nibName: cellNib, bundle: nil)
        resultsController.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        resultsController.tableView.dataSource           = responder
        resultsController.tableView.delegate             = responder
        resultsController.tableView.emptyDataSetSource   = responder
        resultsController.tableView.emptyDataSetDelegate = responder
    }

    func searchDidChange(text: String, active: Bool) {
        PLLog("Search active: \(active)")
        PLLog("Search text: \(text)")
    } // to override
}

extension PLSearchableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            searchDidChange(text, active: searchController.active)
        }
    }
}

