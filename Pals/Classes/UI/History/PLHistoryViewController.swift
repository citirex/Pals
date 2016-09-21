//
//  PLHistoryViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/21/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLHistoryViewController: PLViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var activityIndicator: UIActivityIndicatorView!
    private lazy var orderDatasource: PLOrderDatasource = {
        let orderDatasource = PLOrderDatasource(orderType: .Drinks)
        orderDatasource.userId = self.user.id
        return orderDatasource
    }()
    
    var user: PLUser!
    private var orders = [PLOrder]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureActivityIndicator()
        
        loadOrders()
    }
    
    
    private func loadOrders() {
        orderDatasource.load { orders, error in
            guard error == nil else { return }
            for order in orders as! [PLOrder] {
                if order.drinkSets.count > 0 {
                    self.orders.append(order)
                }
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .grayColor()
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        activityIndicator.addConstraintCentered()
    }
    
    
    // MARK: - Private methods
    
    private func setupTableView() {
        let cellNib = UINib(nibName: PLHistoryCell.nibName, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: PLHistoryCell.reuseIdentifier)
        
        let sectionHeaderNib = UINib(nibName: PLHistorySectionHeader.nibName, bundle: nil)
        tableView.registerNib(sectionHeaderNib, forCellReuseIdentifier: PLHistorySectionHeader.reuseIdentifier)
    }
    
}


// MARK: - UITableViewDataSource

extension PLHistoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orders.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders[section].drinkSets.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLHistoryCell.reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let drink = orders[indexPath.section].drinkSets[indexPath.row].drink
        if let cell = cell as? PLHistoryCell {
            cell.drink = drink
        }
    }
    
}


// MARK: - UITableViewDelegate

extension PLHistoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCellWithIdentifier(PLHistorySectionHeader.reuseIdentifier) as! PLHistorySectionHeader
        return sectionHeader
    }
    
}
