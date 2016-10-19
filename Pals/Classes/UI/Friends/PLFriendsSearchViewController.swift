//
//  PLFriendsSearchViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLFriendsSearchViewController: PLFriendBaseViewController{
	
    var datasource = PLDatasourceHelper.createFriendsInviteDatasource()
	
	override func loadData() {
		isLoading = true
		self.spinner.startAnimating()
		datasource.loadPage {[unowned self] (indices, error) in
			self.isLoading = false
			self.didLoadPage(indices, error: error)
			self.spinner.stopAnimating()
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		datasource.cancel()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

        searchController.searchResultsUpdater = self
        tableView.dataSource = self
        resultsController.tableView.dataSource = self
    }
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		tableView.reloadData()
		searchBar.endEditing(true)
	}
	
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

extension PLFriendsSearchViewController : UITableViewDataSource, PLFriendCellDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! PLFriendCell
        let friend = datasource[indexPath.row]
        cell.setupWith(friend.cellData)
        cell.setupAddButtonFor(friend.invited)
        cell.delegate = self
        return cell
    }
    
    func addFriendButtonPressed(sender: PLFriendCell) {
        if let index = tableView.indexPathForCell(sender)?.row {
            let newFriend = datasource[index]
            startActivityIndicator(.Gray)
            PLFacade.addFriend(newFriend, completion: {[weak sender, weak newFriend, weak self] (error) in
                if error != nil {
                    PLShowAlert("Failed to add friend", message: "Please try again later")
                    PLLog(error?.localizedDescription,type: .Network)
                } else {
                    newFriend?.invited = true
                    sender?.setupAddButtonFor(true)
                }
                self?.stopActivityIndicator()
            })
            
        }
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