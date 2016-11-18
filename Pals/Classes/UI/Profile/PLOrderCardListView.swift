//
//  PLOrderCardListView.swift
//  Pals
//
//  Created by ruckef on 16.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLOrderContainable {
    var order: PLOrder? {get set}
}

class PLOrderCardListView: UIView, PLOrderContainable, PLNibNamable {

    @IBOutlet var tableView: UITableView!
    lazy var headerView: PLOrderItemHeaderView = PLOrderItemHeaderView.loadFromNib()!
    lazy var footerView: PLOrderItemFooterView = PLOrderItemFooterView.loadFromNib()!
    
    class var nibName: String { return "PLOrderCardListView" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    
    func initialize() {
        let nib = UINib(nibName: PLOrderItemCell.nibName(), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLOrderItemCell.identifier())
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
        let tableHeaderHeight = CGFloat(60)
        var frame = tableView.tableHeaderView!.frame
        if frame.height != tableHeaderHeight {
            frame.size.height = tableHeaderHeight
            tableView.tableHeaderView?.frame = frame
        }
        
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
        let tableFooterHeight = footerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        let tableFooterMinHeight = CGFloat(60)
        frame = tableView.tableFooterView!.frame
        if frame.height != tableFooterHeight && tableFooterHeight >= tableFooterMinHeight {
            frame.size.height = tableFooterHeight
            tableView.tableFooterView?.frame = frame
        }
    }
    
    var order: PLOrder? {
        didSet {
            if let o = order {
                tableView.reloadData()
                let date = o.date?.stringForStyles(.MediumStyle, timeStyle: .ShortStyle) ?? ""
                headerView.update(o.place.address, date: date, placeURL: o.place.picture)
                footerView.update(o.user.name, message: o.message, userPicture: o.user.picture)
            } else {
                
            }
        }
    }
}

extension PLOrderCardListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = order?.itemsCount ?? 0
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLOrderItemCell.identifier()) as! PLOrderItemCell
        let item = order![indexPath.row]
        cell.item = item
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }

}
