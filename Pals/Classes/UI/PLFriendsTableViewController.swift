//
//  PLFriendsTableViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLFriendsTableViewController: UITableViewController, UISearchBarDelegate {
	
	var searchBar = UISearchBar()
	var searchArray = [String]()
	
	@IBAction func searchButton(sender: AnyObject) {
		
		if navigationItem.titleView != searchBar {
			navigationItem.titleView = searchBar
			searchBar.becomeFirstResponder()
		} else {
			navigationItem.titleView = nil
			navigationItem.title = "Friends"
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let textFieldInsideSearchBar = self.searchBar.valueForKey("searchField") as! UITextField
		textFieldInsideSearchBar.leftViewMode = UITextFieldViewMode.Never
		searchArray = ["1","2","3"]
		searchBar.placeholder = "Find Your Pals                                        "
		searchBar.layer.cornerRadius = 25
		searchBar.clipsToBounds = true
		searchBar.delegate = self
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch navigationItem.titleView == searchBar {
		case true:
			return searchArray.count
		case false:
			return PLFriendsModel.FriendModel.itemsArray.count
		}
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
		
		let cell:PLFriendCell = tableView.dequeueReusableCellWithIdentifier("FriendCell") as! PLFriendCell
		
		cell.avatarImage.image = UIImage(named: PLFriendsModel.FriendModel.itemsArray[indexPath.row].backgroundImageName)
		cell.nameLabel.text = PLFriendsModel.FriendModel.itemsArray[indexPath.row].titleText
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		print("Row \(indexPath.row) selected")
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowFriendProfile" {
            let friendProfileViewController = segue.destinationViewController as! PLFriendProfileViewController
            friendProfileViewController.title = ""
        }
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
		self.navigationController?.pushViewController((storyboard?.instantiateViewControllerWithIdentifier("FriendsSearch"))!, animated: true)
	}

}

extension PLFriendsTableViewController: UISearchResultsUpdating
{
	func updateSearchResultsForSearchController(searchController: UISearchController)
	{
		searchArray.removeAll(keepCapacity: false)
		
		let range = searchController.searchBar.text!.characters.startIndex ..< searchController.searchBar.text!.characters.endIndex
		var searchString = String()
		
		searchController.searchBar.text?.enumerateSubstringsInRange(range, options: .ByComposedCharacterSequences, { (substring, substringRange, enclosingRange, success) in
			searchString.appendContentsOf(substring!)
			searchString.appendContentsOf("*")
		})
		
		let searchPredicate = NSPredicate(format: "SELF LIKE[cd] %@", searchString)
//		let array = (PLFriendsModel.FriendModel.itemsArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
//		searchArray = array as! [String]
		tableView.reloadData()
	}
}

