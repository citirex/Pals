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
        let cellNib = UINib(nibName: PLOrderHistoryCell.nibName, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: PLOrderHistoryCell.reuseIdentifier)
        
        let sectionHeaderNib = UINib(nibName: PLOrderHistorySectionHeader.nibName, bundle: nil)
        tableView.registerNib(sectionHeaderNib, forCellReuseIdentifier: PLOrderHistorySectionHeader.reuseIdentifier)
    }
    
}


// MARK: - UITableViewDataSource

extension PLOrderHistoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orders.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders[section].drinkSets.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLOrderHistoryCell.reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let drink = orders[indexPath.section].drinkSets[indexPath.row].drink
        if let cell = cell as? PLOrderHistoryCell {
            cell.drink = drink
        }
    }
    
}


// MARK: - UITableViewDelegate

extension PLOrderHistoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCellWithIdentifier(PLOrderHistorySectionHeader.reuseIdentifier) as! PLOrderHistorySectionHeader
        //        sectionHeader.dateLabel.text = orders[section].date
        sectionHeader.placeNameLabel.text = orders[section].place.name
        return sectionHeader
    }
    
}

