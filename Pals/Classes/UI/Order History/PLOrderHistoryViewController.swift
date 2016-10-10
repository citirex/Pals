//
//  PLOrderHistoryViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLOrderHistoryViewController: PLViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var activityIndicator: UIActivityIndicatorView!
    private lazy var orders: PLOrderDatasource = {
        let orderDatasource = PLOrderDatasource(orderType: .Drinks, sectioned: true)
        return orderDatasource
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureActivityIndicator()
        loadOrders()
    }
    
    
    // MARK: - Private methods
    
    private func loadOrders() {
        activityIndicator.startAnimating()
        orders.loadPage { [unowned self] indexPaths, error in
            self.activityIndicator.stopAnimating()
            
            self.tableView.reloadData()
            
//            guard error == nil else { return PLShowErrorAlert(error: error!) }
//            
//            self.tableView?.beginUpdates()
//            let indexSet = NSIndexSet(indexesInRange: NSMakeRange(0, 20))
//            self.tableView.insertSections(indexSet, withRowAnimation: .Bottom)
//            self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
//            self.tableView?.endUpdates()
//            self.tableView.reloadData()
        }
    }
    
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .grayColor()
        view.addSubview(activityIndicator)
        
        activityIndicator.addConstraintCentered()
    }

}


// MARK: - UITableViewDataSource

extension PLOrderHistoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //orders[section].drinkSets.count ?? 0
        return orders.ordersCountInSection(section) + orders.drinkCountInSection(section)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = indexPath.row  == 0 ? PLPlaceNameCell.reuseIdentifier : PLOrderHistoryCell.reuseIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
//        let drink = orders[indexPath.section].drinkSets[indexPath.row].drink
//        if let cell = cell as? PLOrderHistoryCell {
//            cell.drinkCellData = drink.cellData
//        }
//        if let cell = cell as? PLPlaceNameCell {
//            cell.orderCellData = orders[indexPath.section].cellData
//        }
        
//        if let dateType = PLDateType(rawValue: indexPath.section) {
//            let ordersInSection = orders[dateType]
//            print(ordersInSection!.count)
//        }
        
//        let drink = orders[indexPath.section].drinkSets[indexPath.row].drink
//        if let cell = cell as? PLOrderHistoryCell {
//            cell.drinkCellData = drink.cellData
//        }

    }
    
}


// MARK: - UITableViewDelegate

extension PLOrderHistoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if orders.shouldLoadNextPage(indexPath) { loadOrders() }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCellWithIdentifier(PLOrderHistorySectionHeader.reuseIdentifier) as!
        PLOrderHistorySectionHeader
        sectionHeader.orderCellData = orders[section].cellData
        return sectionHeader
    }
    
}

