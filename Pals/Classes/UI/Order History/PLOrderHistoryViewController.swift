//
//  PLOrderHistoryViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import DZNEmptyDataSet

class PLOrderHistoryViewController: PLViewController {

    @IBOutlet weak var tableView: UITableView!

    private lazy var orders: PLOrderDatasource = {
        let orderDatasource = PLOrderDatasource(orderType: .Drinks, sectioned: true)
        return orderDatasource
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: PLOrderHistorySectionHeader.nibName, bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: PLOrderHistorySectionHeader.reuseIdentifier)
        
        loadOrders()
    }
    
    // MARK: - Private methods
    
    private func loadOrders() {
        startActivityIndicator(.WhiteLarge, color: .grayColor())
        orders.load {[unowned self] (page, error) in
            self.stopActivityIndicator()
            guard error == nil else { return PLShowErrorAlert(error: error!) }

            let objects = page.objects
            let lastIdxPath = self.findLastIdxPath()
            let indexPaths = self.orders.indexPathsFromObjects(objects as [AnyObject], lastIdxPath: lastIdxPath, mergedSection: page.mergedWithPreviousSection)
            self.logInsertingCellPaths(indexPaths)

            self.tableView?.beginUpdates()
            let newSectionIdxSet = self.makeIndexSetForInsertingSections(page, datasource: self.orders)
            self.tableView.insertSections(newSectionIdxSet, withRowAnimation: .Bottom)
            self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
            self.tableView?.endUpdates()
        }
    }
    
    private func makeIndexSetForInsertingSections(page: PLPage, datasource: PLOrderDatasource) -> NSIndexSet {
        let adding = page.mergedWithPreviousSection ? 1 : 0
        let range = NSMakeRange(datasource.count - page.objects.count + adding, page.objects.count - adding)
        return NSIndexSet(indexesInRange: range)
    }
    
    private func logInsertingCellPaths(paths: [NSIndexPath]) {
        PLLog("===== Loaded orders with index paths:")
        for idxPath in paths {
            PLLog("\(idxPath.section) : \(idxPath.row)")
        }
        PLLog("==========")
    }

}


// MARK: - UITableViewDataSource

extension PLOrderHistoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.cellCountInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let historyObject = orders.historyObjectForIndPath(indexPath)
        let cellType = orders.orderCellTypeFromHistoryObject(historyObject)
        let reuseIdentifier = cellType == .Place ? PLPlaceNameCell.reuseIdentifier : PLOrderHistoryCell.reuseIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        switch cellType {
        case .Place:
            if let cell = cell as? PLPlaceNameCell {
                let place = historyObject as! PLPlace
                cell.place = place
            }
        case .Drink:
            if let cell = cell as? PLOrderHistoryCell {
                let drink = (historyObject as! PLDrinkset).drink
                cell.drink = drink
            }
        }
        return cell
    }
    
}


extension PLOrderHistoryViewController {

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
        let sectionHeader = tableView.dequeueReusableHeaderFooterViewWithIdentifier(PLOrderHistorySectionHeader.reuseIdentifier) as! PLOrderHistorySectionHeader
        
        if let firstOrder = orders.objectsInSection(section).first {
            sectionHeader.orderCellData = firstOrder.cellData
        }
        return sectionHeader
    }
    
}


// MARK: - DZNEmptyDataSetSource

extension PLOrderHistoryViewController: DZNEmptyDataSetSource {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "Orders History"
        let attributedString = NSAttributedString(string: string, font: .boldSystemFontOfSize(20), color: .grayColor())
        return attributedString
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "You don't have any orders yet"
        let attributedString = NSAttributedString(string: string, font: .systemFontOfSize(18), color: .lightGrayColor())
        return attributedString
    }
    
}


// MARK: - DZNEmptyDataSetDelegate

extension PLOrderHistoryViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
//    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
//        return
//    }
}

