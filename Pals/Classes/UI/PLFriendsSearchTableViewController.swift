//
//  PLFriendsSearchTableViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLFriendsSearchTableViewController: UITableViewController, UISearchBarDelegate {
	
	var searchBar = UISearchBar()
	
	@IBAction func searchButton(sender: AnyObject) {
		
		if navigationItem.titleView != searchBar {
			navigationItem.titleView = searchBar
		} else {
			navigationItem.titleView = nil
			navigationItem.title = "Friends Search"
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as! UITextField
		textFieldInsideSearchBar.leftViewMode = UITextFieldViewMode.Never
		searchBar.placeholder = "Find Your Pals                           "
		searchBar.layer.cornerRadius = 25
		searchBar.clipsToBounds = true
		searchBar.delegate = self
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return PLFriendsModel.FriendModel.itemsArray.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
		
		let cell:PLFriendSearchTableViewCell = tableView.dequeueReusableCellWithIdentifier("FriendSearchCell") as! PLFriendSearchTableViewCell
		
		cell.avatarImage.image = UIImage(named: PLFriendsModel.FriendModel.itemsArray[indexPath.row].backgroundImageName)
		cell.nameLabel.text = PLFriendsModel.FriendModel.itemsArray[indexPath.row].titleText
		cell.addButtonOutlet.setImage(UIImage(named: "plus"), forState: .Normal)
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		print("Row \(indexPath.row) selected")
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		registerKeyboardNotifications()
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		NSNotificationCenter.defaultCenter().removeObserver(self)
		navigationItem.titleView = nil
		navigationItem.title = "Friends"
	}
	
	// MARK: - Dismiss Keyboard
	func dismissKeyboard(sender: UITapGestureRecognizer) {
		searchBar.endEditing(true)
	}
	
	// MARK: - Notifications
	private func registerKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	// MARK: - Keyboard
	func keyboardWillShow(notification: NSNotification) {
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:))))
	}
	func keyboardWillHide(notification: NSNotification) {
		
		let tapOnScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
		tapOnScreen.cancelsTouchesInView = false
		view.addGestureRecognizer(tapOnScreen)
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		//search result from server
	}
}
