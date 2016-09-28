//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsViewController: PLFriendBaseViewController {

    var datasource = PLDatasourceHelper.createMyFriendsDatasource()
    
	@IBAction func searchButton(sender: AnyObject) {
		performSegueWithIdentifier("FriendSearchSegue", sender: self)
	}
    
    override func loadData() {
        self.spinner.startAnimating()
        datasource.loadPage {[unowned self] (indices, error) in
            self.didLoadPage(indices, error: error)
            self.spinner.stopAnimating()
        }
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.setNavigationBarTransparent(false)
        searchController.searchResultsUpdater = self
        tableView.dataSource = self
        resultsController.tableView.dataSource = self
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.title = "Friends"
		navigationItem.titleView?.tintColor = .vividViolet()
		navigationController?.navigationBar.tintColor = .vividViolet()
	}
	
	override func viewWillDisappear(animated: Bool) {
		navigationController?.navigationBar.addBorder(.Bottom, color: .clearColor(), width: 0.5)
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y < -20 {
            navigationController?.navigationBar.addBorder(.Bottom, color: .miracleColor(), width: 0.5)
		} else {
		navigationController?.navigationBar.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
		}
	}
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		performSegueWithIdentifier("FriendSearchSegue", sender: self)
	}
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "FriendProfileSegue":
            let friendProfileViewController = segue.destinationViewController as! PLFriendProfileViewController
            friendProfileViewController.friend = selectedFriend
        case "FriendSearchSegue":
            let friendSearchViewController = segue.destinationViewController as! PLFriendsSearchViewController
            friendSearchViewController.seekerText = searchController.searchBar.text
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
        let friend = datasource[indexPath.row]
        cell.friend = friend
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
}

// MARK: - UISearchResultsUpdating

extension PLFriendsViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        datasource.searching = searchController.active
        let filter = searchController.searchBar.text!
        if filter.isEmpty {
            datasource.searching = false
        } else {
            spinner.startAnimating()
            
            datasource.filter({ (user) -> Bool in
                let tmp: NSString = user.name
                let range = tmp.rangeOfString(filter, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            }) { [unowned self] in
                self.resultsController.tableView.reloadData()
                self.spinner.stopAnimating()
            }
            
        }
    }
}