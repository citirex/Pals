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
    private lazy var orders: PLOrderDatasource = {
        let orderDatasource = PLOrderDatasource(orderType: .Drinks)
        orderDatasource.userId = self.user.id
        return orderDatasource
    }()
    
    var user: PLUser!
    
    private let dates = ["Yesterday", "Last Week", "2 Weeks Ago"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureActivityIndicator()
        
        loadOrders()
    }
    
    var numberOfSections = 0
    private func loadOrders() {
        activityIndicator.startAnimating()
        orders.load { orders, error in
            guard error == nil else { return }
            
            let orders = orders as! [PLOrder]
            var indexPaths = [NSIndexPath]()
            
            for order in orders {
                if order.drinkSets.count > 0 {
                    self.numberOfSections += 1
                }
            }
            
            for section in 0..<self.numberOfSections {
                for row in 0..<orders[section].drinkSets.count {
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
        return 3
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

