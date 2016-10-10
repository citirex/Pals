//
//  PLOrderHistoryViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

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
    
    private func indexPathsFromObjects(objects: [AnyObject], lastIdxPath: NSIndexPath?, mergedSection: Bool) -> [NSIndexPath] {
        var paths = [NSIndexPath]()
        var sectionIdx = 0
        var rowIdx = 0
        if lastIdxPath != nil {
            sectionIdx = mergedSection ? lastIdxPath!.section : lastIdxPath!.section+1
            if mergedSection {
                rowIdx = lastIdxPath!.row+1
            }
        }
        for i in 0..<objects.count {
            if let section = objects[i] as? [PLOrder] {
                var rowsInSection = 0
                for order in section {
                    // +1 row for a place name
                    let rowsForOrder = order.drinkSets.count+1
                    rowsInSection += rowsForOrder
                }
                for i in 0..<rowsInSection {
                    paths.append(NSIndexPath(forRow: rowIdx+i, inSection: sectionIdx))
                }
                rowIdx = 0
            }
            sectionIdx += 1
        }
        return paths
    }
    
    private func findLastIdxPath() -> NSIndexPath? {
        let sections = tableView.numberOfSections
        if sections == 0 {
            return nil
        }
        let rows = tableView.numberOfRowsInSection(sections-1)
        if rows == 0 {
            return nil
        }
        return NSIndexPath(forRow: rows-1, inSection: sections-1)
    }
    
    private func loadOrders() {
        activityIndicator.startAnimating()
        orders.load {[unowned self] (page, error) in
            guard error == nil else { return PLShowErrorAlert(error: error!) }

            let objects = page.objects
            let lastIdxPath = self.findLastIdxPath()
            let indexPaths = self.indexPathsFromObjects(objects as [AnyObject], lastIdxPath: lastIdxPath, mergedSection: page.mergedWithPreviousSection)
            PLLog("===== Loaded orders with index paths:")
            for idxPath in indexPaths {
                PLLog("\(idxPath.section) : \(idxPath.row)")
            }
            PLLog("==========")
            self.activityIndicator.stopAnimating()
            self.tableView?.beginUpdates()
            let adding = page.mergedWithPreviousSection ? 1 : 0
            let range = NSMakeRange(self.orders.count - page.objects.count + adding, page.objects.count - adding)
            let idxSet = NSIndexSet(indexesInRange: range)
            self.tableView.insertSections(idxSet, withRowAnimation: .Bottom)
            self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
            self.tableView?.endUpdates()
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
        return orders.ordersCountInSection(section) + orders.drinkCountInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = indexPath.row  == 0 ? PLPlaceNameCell.reuseIdentifier : PLOrderHistoryCell.reuseIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        // TODO: figure out
    }
    
}

// MARK: - UITableViewDelegate

extension PLOrderHistoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let last = findLastIdxPath() {
            if indexPath.compare(last) == .OrderedSame {
                loadOrders()
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCellWithIdentifier(PLOrderHistorySectionHeader.reuseIdentifier) as!
        PLOrderHistorySectionHeader
        if let firstOrder = orders.objectsInSection(section).first {
            sectionHeader.orderCellData = firstOrder.cellData
        }
        return sectionHeader
    }
    
}

