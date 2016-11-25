//
//  PLNotificationViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 15.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import DZNEmptyDataSet

class PLNotificationViewController: PLViewController {
	
	var nib = UINib(nibName: PLNewFriendNotificationCell.nibName, bundle: nil)
	
	private var notificationView: PLTableView! { return view as! PLTableView }
	lazy var tableView: UITableView = {
		let tableView = self.notificationView.tableView
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = UIColor(r: 59, g: 204, b: 136)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.emptyDataSetSource = self
		tableView.emptyDataSetDelegate = self
		return tableView
	}()
	
	override func loadView() {
		view = PLTableView(frame: UIScreen.mainScreen().bounds)
		notificationView.configure()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.registerNib(nib, forCellReuseIdentifier: PLNewFriendNotificationCell.identifier)
    }
}

// MARK: - UITableViewDataSource

extension PLNotificationViewController : UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//		let count = datasource.count
		return 3//count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
		
		let cell = tableView.dequeueReusableCellWithIdentifier(PLNewFriendNotificationCell.identifier, forIndexPath: indexPath)
		configureCell(cell, atIndexPath: indexPath)
		return cell
	}
	
	func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
		cell.layer.cornerRadius = 25
		cell.layer.borderWidth = 3
		PLNewFriendNotificationCell().contentView.layer.cornerRadius = 25
		if indexPath.row % 2 == 0 {
			cell.layer.borderColor = UIColor.violetColor.CGColor
		} else{
			cell.layer.borderColor = UIColor.orangeColor().CGColor
		}
	}

}


// MARK: - UITableViewDelegate

extension PLNotificationViewController : UITableViewDelegate {
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//		if datasource.shouldLoadNextPage(indexPath) {
//			loadData()
//		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 128
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
//		let friend = datasource[indexPath.row]
		
//		performSegueWithIdentifier(SegueIdentifier.FriendProfileSegue, sender: friend)
	}
	
}

// MARK: - DZNEmptyDataSetSource

extension PLNotificationViewController: DZNEmptyDataSetSource {
	
	func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
		let string = "Notifications"
		let attributedString = NSAttributedString(string: string, font: .boldSystemFontOfSize(20), color: .grayColor())
		return attributedString
	}
	
	func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
		let string = "No Notifications yet"
		let attributedString = NSAttributedString(string: string, font: .systemFontOfSize(18), color: .grayColor())
		return attributedString
	}
	
	func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
		let named = "notification-tab"
		return UIImage(named: named)!.imageResize(CGSizeMake(100, 100))
	}
	
}


// MARK: - DZNEmptyDataSetDelegate

extension PLNotificationViewController: DZNEmptyDataSetDelegate {
	
	func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
		navigationController?.navigationBar.shadowImage = nil
		return true
	}
}
