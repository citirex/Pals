//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsViewController: PLViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
	
	private var resultsController: UITableViewController!
	private var searchController: PLSearchController!
	

	var tableView = UITableView()
	lazy var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let datasource = PLFriendsDatasource(userId: PLFacade.profile!.id)

	
    private var selectedFriend: PLUser!
	
	
	@IBAction func searchButton(sender: AnyObject) {
		performSegueWithIdentifier("ShowFriendSearch", sender: self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureSearchController()
		
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		tableView.keyboardDismissMode = .OnDrag
		tableView.separatorInset.left = 75
		
		tableView.delegate = self
		tableView.dataSource = self
		
		view.addSubview(tableView)
		view.addSubview(spinner)

		spinner.center = view.center
		spinner.transform = CGAffineTransformMakeScale(2, 2)
        loadDatasource()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.titleView = nil
		navigationItem.title = "Friends"
//		registerKeyboardNotifications()
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		tableView.reloadData()
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidLayoutSubviews() {
		tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 49)
	}
    
    func loadDatasource() {
		self.spinner.startAnimating()
        datasource.load {[unowned self] (page, error) in
            if error == nil {
				self.tableView.hidden = false
				let count = self.datasource.count
				let lastLoadedCount = page.count
				if lastLoadedCount > 0 {
					var indexPaths = [NSIndexPath]()
					for i in count - lastLoadedCount..<count {
						indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
					}
					self.tableView.beginUpdates()
					self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
					self.tableView.endUpdates()
				}
				self.spinner.stopAnimating()
			} else {
				PLShowAlert("Error!", message: "Cannot download your friends.")
			}
        }
    }
	
	// MARK: - Initialize search controller
	
	private func configureSearchController() {
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		resultsController = UITableViewController(style: .Plain)
		resultsController.tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		resultsController.tableView.backgroundColor = .miracleColor()
		resultsController.tableView.tableFooterView = UIView()
		resultsController.tableView.backgroundView = UIView()
		resultsController.tableView.rowHeight = 110.0
		resultsController.tableView.dataSource = self
		resultsController.tableView.delegate = self
		
		searchController = PLSearchController(searchResultsController: resultsController)
		searchController.searchBar.placeholder = "Find Your Pals"
		searchController.searchBar.barTintColor = .miracleColor()
		searchController.searchBar.backgroundImage = UIImage()
		searchController.searchBar.tintColor = .miracleColor()
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.delegate = self
		tableView.tableHeaderView = searchController.searchBar
		definesPresentationContext = true
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.endEditing(true)
	}
	
	
	// MARK: - tableView
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return datasource.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
		
		let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! PLFriendCell
		
		let friend = datasource[indexPath.row]
		
			cell.friend = friend
		cell.accessoryType = .DisclosureIndicator
		
		return cell
		
	}
	
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
        if indexPath.row == datasource.count-1 {
            loadDatasource()
        }
    }
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		selectedFriend = datasource[indexPath.row]
        performSegueWithIdentifier("ShowFriendProfile", sender: self)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "ShowFriendSearch" {
			let friendSearchViewController = segue.destinationViewController as! PLFriendsSearchViewController
		}
		
        guard segue.identifier == "ShowFriendProfile" else { return }
        let friendProfileViewController = segue.destinationViewController as! PLFriendProfileViewController
        friendProfileViewController.friend = selectedFriend
    }
	
}

// MARK: - UISearchControllerDelegate

extension PLFriendsViewController : UISearchControllerDelegate {
	func willDismissSearchController(searchController: UISearchController) {
		let offset = tableView.contentOffset.y + tableView.contentInset.top
		if offset >= searchController.searchBar.frame.height {
			UIView.animateWithDuration(0.25) {
				searchController.searchBar.alpha = 0
			}
		}
	}
	
	func didDismissSearchController(searchController: UISearchController) {
		if searchController.searchBar.alpha == 0 {
			UIView.animateWithDuration(0.25) {
				searchController.searchBar.alpha = 1
			}
		}
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
