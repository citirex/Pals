//
//  PLFriendsTableViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLFriendsTableViewController: UITableViewController {
	
	let searchBar = UISearchBar()
	
	@IBAction func searchButton(sender: AnyObject) {
		navigationController!.navigationItem.titleView = searchBar
		navigationItem.titleView = searchBar
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}

	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return PLFriendsModel.FriendModel.itemsArray.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
		
		let cell:PLFriendCell = self.tableView.dequeueReusableCellWithIdentifier("FriendCell") as! PLFriendCell
		
		cell.avatarImage.image = UIImage(named: PLFriendsModel.FriendModel.itemsArray[indexPath.row].backgroundImageName)
		cell.nameLabel.text = PLFriendsModel.FriendModel.itemsArray[indexPath.row].titleText
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("Row \(indexPath.row) selected")
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
}
