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
    
    let numberOfSections = 10
    
    lazy var datasource: PLOrderDatasource = {
        let datasource = PLOrderDatasource()
        datasource.userId = self.user.id
        return datasource }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                var indexPaths = [NSIndexPath]()
                for index in 0..<pages.count {
                    
                    indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
                }
                self.tableView?.beginUpdates()
                self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
                self.tableView?.endUpdates()
                
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
        let order = datasource[section]
        return order.drinkSets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLHistoryCell.reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let order = datasource[indexPath.row]
        if let cell = cell as? PLHistoryCell {
            cell.drink = order.drinkSets[indexPath.row].drink
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