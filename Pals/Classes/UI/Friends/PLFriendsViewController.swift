//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//
import DZNEmptyDataSet

class PLFriendsViewController: PLFriendBaseViewController {
	
    var datasource = PLDatasourceHelper.createMyFriendsDatasource()
	var searchText: String!
	
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
		super.viewWillDisappear(animated)
		datasource.cancel()
	}
    
	override func viewDidLoad() {
		super.viewDidLoad()
        searchController.searchResultsUpdater  = self
        resultsController.tableView.dataSource = self
		tableView.dataSource = self
	}
	
    
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchController.searchBar.endEditing(true)
	}
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "FriendProfileSegue":
            let friendProfileViewController		  = segue.destinationViewController as! PLFriendProfileViewController
            friendProfileViewController.friend	  = selectedFriend
        default:
            break
        }
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if datasource.shouldLoadNextPage(indexPath) { loadData() }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedFriend = datasource[indexPath.row]
        performSegueWithIdentifier("FriendProfileSegue", sender: self)
    }
}

// MARK: - UITableViewDataSource

extension PLFriendsViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! PLFriendCell
        let friend		   = datasource[indexPath.row]
        cell.friend		   = friend
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
}

// MARK: - UISearchResultsUpdating

extension PLFriendsViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        datasource.searching = searchController.active
        searchText = searchController.searchBar.text!
        if searchText.isEmpty { datasource.searching = false}
		else {
            spinner.startAnimating()
            datasource.filter(searchText, completion: { [unowned self] in
                self.resultsController.tableView.reloadData()
                self.spinner.stopAnimating()
            })
        }
    }
}