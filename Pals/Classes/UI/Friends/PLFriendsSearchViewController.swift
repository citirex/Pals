//
//  PLFriendsSearchViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLFriendsSearchViewController: PLFriendBaseViewController{
	
	var seekerText: String?
    var datasource = PLDatasourceHelper.createFriendsInviteDatasource()
	
//	var collectionUsers: [PLUser] {
//		return datasource.collection.objectsInSection(99) ?? []
//	}
	
	override func loadData() {
		self.spinner.startAnimating()
		datasource.loadPage {[unowned self] (indices, error) in
			self.didLoadPage(indices, error: error)
			self.spinner.stopAnimating()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

        searchController.searchResultsUpdater = self
        tableView.dataSource = self
        resultsController.tableView.dataSource = self
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .FriendsStyle
		if seekerText != "" {
			searchController.searchBar.text = seekerText
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		navigationController?.navigationBar.shadowImage = UIImage()
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		seekerText = searchBar.text
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y < -20 {
			navigationController?.navigationBar.shadowImage = UIImage()
		} else {
			navigationController?.navigationBar.shadowImage = nil
		}
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//		sendSearchFriendsRequest()
		tableView.reloadData()
		searchBar.endEditing(true)
	}
	
//	func sendSearchFriendsRequest() -> [PLUser] {
		
//		let filtered = collectionUsers.filter({ (user) -> Bool in
//			let tmp: NSString = user.name
//			let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
//			return range.location != NSNotFound
//		})
//		
//		print("req with word: \(searchController.searchBar.text!)")
//		
//		return filtered
//	}
	
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let friend = datasource[indexPath.row]
		performSegueWithIdentifier("FriendsProfileSegue", sender: friend)
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if datasource.shouldLoadNextPage(indexPath) { loadData() }
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let friendProfileViewController = segue.destinationViewController as! PLFriendProfileViewController
        if let friend = sender as? PLUser {
            friendProfileViewController.friend = friend
        }
	}

}

// MARK: - UITableViewDataSource

extension PLFriendsSearchViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! PLFriendCell
        let friend = datasource[indexPath.row]
        cell.friend = friend
        cell.accessoryView = cell.addButton
        return cell
    }
}

// MARK: - UISearchResultsUpdating

extension PLFriendsSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        datasource.searching = searchController.active
        let text = searchController.searchBar.text!
        if text.isEmpty {
            datasource.searching = false
        } else {
            spinner.startAnimating()
            datasource.filter(text, completion: { [unowned self] in
                self.resultsController.tableView.reloadData()
                self.spinner.stopAnimating()
            })
        }
    }
}