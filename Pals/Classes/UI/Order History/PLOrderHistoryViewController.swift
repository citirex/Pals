//
//  PLOrderHistoryViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLOrderHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var activityIndicator: UIActivityIndicatorView!
    private let dates = ["Yesterday", "Last Week", "2 Weeks Ago"]
    private lazy var orders: PLOrderDatasource = {
        let orderDatasource = PLOrderDatasource(orderType: .Drinks)
        return orderDatasource
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureActivityIndicator()
        
        loadOrders()
    }
    
    
    private func loadOrders() {
        activityIndicator.startAnimating()
        orders.load { objects, error in
            guard error == nil else { return }
            let orders = objects as! [PLOrder]
            var indexPaths = [NSIndexPath]()
            let filterOrders = orders.filter { $0.drinkSets.count > 0 }
            
            for section in 0..<filterOrders.count {
                for row in 0..<filterOrders[section].drinkSets.count {
                    indexPaths.append(NSIndexPath(forRow: row, inSection: section))
                }
            }
            self.tableView?.beginUpdates()
            self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
            self.tableView?.endUpdates()

            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
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
    
    
    // MARK: - Private methods
    
    private func setupTableView() {
        let cellNib = UINib(nibName: PLOrderHistoryCell.nibName, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: PLOrderHistoryCell.reuseIdentifier)
        
        let sectionHeaderNib = UINib(nibName: PLOrderHistorySectionHeader.nibName, bundle: nil)
        tableView.registerNib(sectionHeaderNib, forCellReuseIdentifier: PLOrderHistorySectionHeader.reuseIdentifier)
    }
    
}


// MARK: - UITableViewDataSource

extension PLOrderHistoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dates.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count > 0 ? orders[section].drinkSets.count : 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLOrderHistoryCell.reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let drink = orders[indexPath.section].drinkSets[indexPath.row].drink
        if let cell = cell as? PLOrderHistoryCell {
            cell.drinkCellData = drink.cellData
        }
    }
    
}


// MARK: - UITableViewDelegate

extension PLOrderHistoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCellWithIdentifier(PLOrderHistorySectionHeader.reuseIdentifier) as! PLOrderHistorySectionHeader
        
        guard orders.count > 0 else { return UIView() }
        sectionHeader.dateLabel.text = dates[section]
        sectionHeader.orderCellData = orders[section].cellData
        return sectionHeader
    }
    
}

