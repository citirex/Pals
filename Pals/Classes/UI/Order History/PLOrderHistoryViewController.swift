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
        let orderDatasource = PLOrderDatasource(orderType: .Drinks, sectioned: true)
        return orderDatasource
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
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
//            self.tableView?.beginUpdates()
            
//            indexPaths.forEach { PLLog("rows: \($0.row), section: \($0.section)") }

//            let indexSet = NSIndexSet(indexesInRange: NSMakeRange(0, 20))
//            self.tableView.insertSections(indexSet, withRowAnimation: .Bottom)
//            self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
//            self.tableView?.endUpdates()
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
    
    
    private func setupTableView() {
        let cellNib = UINib(nibName: PLOrderHistoryCell.nibName, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: PLOrderHistoryCell.reuseIdentifier)
        
        let sectionHeaderNib = UINib(nibName: PLOrderHistorySectionHeader.nibName, bundle: nil)
        tableView.registerNib(sectionHeaderNib, forCellReuseIdentifier: PLOrderHistorySectionHeader.reuseIdentifier)
    }
    
    
    
    // TODO: - needs?
    private func adjustSectionHeightToIPhoneSize() -> CGFloat? {
        let deviceType = UIDevice.currentDevice().type
        
        switch deviceType {
        case .iPhone4S, .iPhone5, .iPhone5C, .iPhone5S:
            return 89
        case .iPhone6, .iPhone6S:
            return 97
        case .iPhone6plus:
            return 105
        default:
            return nil
        }
    }

}


// MARK: - UITableViewDataSource

extension PLOrderHistoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count = orders.count
        return count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = orders.ordersCountInSection(section) + orders.drinkCountInSection(section)
        return count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLOrderHistoryCell.reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let dateType = PLDateType(rawValue: indexPath.section) {
//            let ordersInSection = orders[dateType]
//            print(ordersInSection.count)
        }
        
//        let drink = orders[indexPath].drinkSets[indexPath.row].drink
        if let cell = cell as? PLOrderHistoryCell {
//            cell.drinkCellData = drink.cellData
        }
    }
 
    
    
}


// MARK: - UITableViewDelegate

extension PLOrderHistoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        if orders.shouldLoadNextPage(indexPath) { loadOrders() }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCellWithIdentifier(PLOrderHistorySectionHeader.reuseIdentifier) as! PLOrderHistorySectionHeader

//        sectionHeader.orderCellData = orders[section].cellData
        return sectionHeader
    }
    
}

