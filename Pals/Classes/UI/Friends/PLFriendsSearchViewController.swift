//
//  PLFriendsSearchViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLAddFriendStatus : Int {
	case NotFriend
	case Friend
}


class PLFriendsSearchViewController: PLFriendBaseViewController {
	
	var seekerText: String?
	
	var collectionUsers: [PLUser] {
		return datasource.collection.objects ?? []
	}
	
	func searchButton(sender: AnyObject) {
		sendSearchFriendsRequest()
		tableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.extendedLayoutIncludesOpaqueBars = true
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.addBorder(.Bottom, color: .clearColor(), width: 0.5)
		navigationItem.title = "Friends Search"
        navigationController?.navigationBar.barStyle = .Default
		navigationController?.navigationBar.tintColor = .vividViolet()
		if seekerText != "" {
			searchController.searchBar.text = seekerText
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		navigationController?.navigationBar.addBorder(.Bottom, color: .clearColor(), width: 0.5)
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		seekerText = searchBar.text
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y < -20 {
		navigationController?.navigationBar.addBorder(.Bottom, color: .miracleColor(), width: 0.5)
		} else {
		navigationController?.navigationBar.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
		}
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		sendSearchFriendsRequest()
		tableView.reloadData()
		searchBar.endEditing(true)
	}
	
	func sendSearchFriendsRequest() -> [PLUser] {
		
		let filtered = collectionUsers.filter({ (user) -> Bool in
			let tmp: NSString = user.name
			let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
			return range.location != NSNotFound
		})
		
		print("req with word: \(searchController.searchBar.text!)")
		
		return filtered
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! PLFriendCell
		
		let friend = datasource[indexPath.row]
		
		cell.friend = friend
		cell.accessoryView = cell.addButton
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		selectedFriend = datasource[indexPath.row]
		performSegueWithIdentifier("FriendsProfileSegue", sender: self)
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let friendProfileViewController = segue.destinationViewController as! PLFriendProfileViewController
		friendProfileViewController.friend = selectedFriend
	}

}