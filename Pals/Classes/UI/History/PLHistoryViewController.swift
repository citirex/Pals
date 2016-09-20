//
//  PLHistoryViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/19/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var user: PLUser!
    
    
    let datasource = PLOrderDatasource(orderType: .Drinks)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource.userId = user.id
        
        print("user id \(user.id)")
        
        let cellNib = UINib(nibName: PLHistoryCell.nibName, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: PLHistoryCell.reuseIdentifier)
        
        let sectionHeaderNib = UINib(nibName: PLHistorySectionHeader.nibName, bundle: nil)
        tableView.registerNib(sectionHeaderNib, forCellReuseIdentifier: PLHistorySectionHeader.reuseIdentifier)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPage()
        
        navigationController?.hideTransparentNavigationBar()
    }
    
    
    private func loadPage() {
        datasource.load { pages, error in
            if error == nil {
                let orders = pages as! [PLOrder]
                var indexPaths = [NSIndexPath]()
                
                for section in 0..<orders.count {
                    print("section: \(section)")
                  
                    for row in 0..<orders[section].drinkSets.count {
                    
                        print("row: \(row)")
                        
                        indexPaths.append(NSIndexPath(forRow: row, inSection: section))
                    }
                }
//                self.tableView?.beginUpdates()
//                self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
//                self.tableView?.endUpdates()
                
            } else {
                PLShowErrorAlert(error: error!)
            }
        }
    }


}


// MARK: - UITableViewDataSource

extension PLHistoryViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].drinkSets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLHistoryCell.reuseIdentifier, forIndexPath: indexPath)
       // configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let drink = datasource[indexPath.section].drinkSets[indexPath.row].drink
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